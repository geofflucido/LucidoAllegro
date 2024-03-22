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

if len(sys.argv) > 1:
    env_url = sys.argv[1]
    releases_root_folder = sys.argv[2]
    source_folder = sys.argv[3]
    release_name = sys.argv[4]
    data_tables_path = sys.argv[5]
    data_constraints_path = sys.argv[6]
    data_columns_path = sys.argv[7]
    data_views_path = sys.argv[8]
    indexes_path = sys.argv[9]
    classes_path = sys.argv[10]
    views_path = sys.argv[11]
    class_events_path = sys.argv[12]
    templates_path = sys.argv[13]
    message_events_path = sys.argv[14]

print(f"Creating deployment package for release {release_name}...")
print(f"Package will be build with files from Deputy Staging Directory: {source_folder}")
print(f"Deputy URL: {env_url}")
print(f"Releases folder: {releases_root_folder}")

request_url = f"{env_url}/api/lucido/devops/GenerateReleaseFromFolder"

body = {
    "ReleasesRootFolder": releases_root_folder,
    "SourceFolder": source_folder,
    "ReleaseName": release_name,
    "HasRandomDistribution": False,
    "DataTablesRelativePath": data_tables_path,
    "DataConstraintsRelativePath": data_constraints_path,
    "DataColumnsRelativePath": data_columns_path,
    "DataViewsRelativePath": data_views_path,
    "IndexesRelativePath": indexes_path,
    "ClassesRelativePath": classes_path,
    "ViewsRelativePath": views_path,
    "ClassEventsRelativePath": class_events_path,
    "TemplatesRelativePath": templates_path,
    "MessageEventsRelativePath": message_events_path,
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