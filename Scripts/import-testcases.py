import subprocess
import urllib.request
import urllib.error

PLAN_ID = 8202
SUITE_ID = 26043
ORG = "https://pgltravel.visualstudio.com"
PROJECT = "Apps"

# IDs of the test cases to add to the suite
WORK_ITEM_IDS = list(range(26775, 26788))  # #26775 to #26787

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
        print(f'  Error adding #{work_item_id} to suite: {e.code} {e.reason}')
        return False

token = get_access_token()

print("Adding test cases to suite...")
for wid in WORK_ITEM_IDS:
    success = add_to_suite(wid, token)
    print(f'  {"Added" if success else "FAILED"}: #{wid}')

print("\nDone.")
