import json
import subprocess
import re
import urllib.request
import urllib.error

PLAN_ID = 8202
SUITE_ID = 26043
ORG = "https://pgltravel.visualstudio.com"
PROJECT = "Apps"

def get_access_token():
    result = subprocess.run(
        ['az.cmd', 'account', 'get-access-token', '--query', 'accessToken', '-o', 'tsv'],
        capture_output=True, text=True
    )
    return result.stdout.strip()

def add_to_suite(work_item_id, token):
    url = f"{ORG}/{PROJECT}/_apis/test/Plans/{PLAN_ID}/suites/{SUITE_ID}/testcases/{work_item_id}?api-version=5.0"
    req = urllib.request.Request(url, method='POST')
    req.add_header('Authorization', f'Bearer {token}')
    req.add_header('Content-Type', 'application/json')
    try:
        with urllib.request.urlopen(req) as response:
            return response.status == 200
    except urllib.error.HTTPError as e:
        print(f'  Error adding to suite: {e.code} {e.reason}')
        return False

token = get_access_token()

# Add already-created test cases #26775-#26787
existing_ids = list(range(26775, 26788))
print("Adding existing test cases to suite...")
for wid in existing_ids:
    success = add_to_suite(wid, token)
    print(f'  {"Added" if success else "FAILED"}: #{wid}')

# Create and add new test cases from JSON
print("\nCreating and adding new test cases...")
with open('TestCases/pbi-26041-testcases.json') as f:
    tests = json.load(f)

for tc in tests:
    result = subprocess.run([
        'az.cmd', 'boards', 'work-item', 'create',
        '--type', 'Test Case',
        '--title', tc['title'],
        '--fields', 'Microsoft.VSTS.TCM.Steps=' + tc['steps']
    ], capture_output=True, text=True, shell=False)

    if '"id"' in result.stdout:
        wid = int(re.search(r'"id": (\d+)', result.stdout).group(1))
        print(f'Created: {tc["title"]} -> #{wid}')
        success = add_to_suite(wid, token)
        print(f'  {"Added to suite" if success else "FAILED to add to suite"}')
    else:
        print(f'FAILED to create: {tc["title"]}')
        print(result.stderr)
