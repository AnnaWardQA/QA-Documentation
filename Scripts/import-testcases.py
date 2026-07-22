import json
import subprocess
import re

with open('TestCases/pbi-26041-testcases.json') as f:
    tests = json.load(f)

for tc in tests:
    result = subprocess.run([
        'az', 'boards', 'work-item', 'create',
        '--type', 'Test Case',
        '--title', tc['title'],
        '--fields', 'Microsoft.VSTS.TCM.Steps=' + tc['steps']
    ], capture_output=True, text=True)

    if '"id"' in result.stdout:
        wid = re.search(r'"id": (\d+)', result.stdout).group(1)
        print(f'Created: {tc["title"]} -> #{wid}')
    else:
        print(f'FAILED: {tc["title"]}')
        print(result.stderr)
