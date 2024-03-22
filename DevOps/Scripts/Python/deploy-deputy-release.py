import os
import sys
import requests
from requests_negotiate_sspi import HttpNegotiateAuth
import json

def logWarning(message: str):
    print(f"##vso[task.logissue type=warning]{message}")    

def logError(message: str):
    print(f"##vso[task.logissue type=error]{message}")

def taskFailed():
    print("##vso[task.complete result=Failed;]DONE")

def find_release_folder(release_root_folder):
    for root, directories, files in os.walk(release_root_folder):
        for subdirectory in directories:
            if (subdirectory.startswith("Rel")):
                return os.path.join(release_root_folder, subdirectory)

if len(sys.argv) > 1:
    deputy_url = sys.argv[1]
    release_root_folder = sys.argv[2]
    release_name = sys.argv[3]
    target_env_url = sys.argv[4]

release_folder = find_release_folder(release_root_folder)
release_id = os.path.basename(release_folder).replace("Rel_", "")

print(f"Deploying release {release_name} to {target_env_url}")
print(f"Deputy URL: {deputy_url}")
print(f"Release folder: {release_folder}")

request_url = f"{deputy_url}/api/lucido/devops/SetupFromFolder"

body = {
  "Credentials": {
    "UseCurrentCredentials": True,
    "Login": None,
    "Password": None,
    "Domain": None
  },
  "Server": target_env_url,
  "Release": {
    "d": release_id,
    "Name": release_name,
    "Folder": release_folder
  },
  "Id": "cb17bb05-a7cf-4015-bbd4-9c49d48e7ad9"
}

print(f"Request body: {body}")

json_body = json.dumps(body)

headers = {
    "Content-Type": "application/json"
}

print(f"Request url: {request_url}")

response = requests.request("POST", request_url, auth=HttpNegotiateAuth(), headers=headers, data=json_body)

if (response.ok):
    print(f"Respose status: {response.status_code} - {response.reason}")

    json_data = response.json()

    print(json_data)

    if (json_data["Ok"] == False):
        logError(json_data["LogBase64"])
        taskFailed()
        sys.exit(1)

else:
    logError(f"{response.status_code} - {response.reason}")
    taskFailed()
    sys.exit(1)