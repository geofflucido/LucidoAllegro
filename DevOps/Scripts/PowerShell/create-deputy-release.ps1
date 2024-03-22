param (
    [string] $envUrl,
    [string] $releasesRootFolder,
    [string] $sourceFolder,
    [string] $releaseName,
    [string] $dataTablesRelPath,
    [string] $dataConstraintsRelPath,
    [string] $dataColumnsRelPath,
    [string] $dataViewsRelPath,
    [string] $indexesRelPath,
    [string] $classesRelPath,
    [string] $viewsRelPath,
    [string] $classEventsRelPath,
    [string] $templatesRelPath,
    [string] $messageEventsRelPath
)

Write-Host "Creating deployment package..."
Write-Host "Package will be built with files from Deputy Staging directory: $sourceFolder"
Write-Host "Deputy URL: $envUrl"
Write-Host "Releases folder: $releasesRootFolder"

$headers = @{
    Content = "application/json"
}

$body = @{
    ReleasesRootFolder = $releasesRootFolder
    SourceFolder = $sourceFolder
    ReleaseName = $releaseName
    HasRandomDistribution = "false"
    DataTablesRelativePath = $dataTablesRelPath
    DataConstraintsRelativePath = $dataConstraintsRelPath
    DataColumnsRelativePath = $dataColumnsRelPath
    DataViewsRelativePath = $dataViewsRelPath
    IndexesRelativePath = $indexesRelPath
    ClassesRelativePath = $classesRelPath
    ViewsRelativePath = $viewsRelPath
    ClassEventsRelativePath = $classEventsRelPath
    TemplatesRelativePath = $templatesRelPath
    MessageEventsRelativePath = $messageEventsRelPath
    Id = "cb17bb05-a7cf-4015-bbd4-9c49d48e7ad9"
}

$jsonBody = $body | ConvertTo-Json

Write-Host "Request body: $jsonBody"

#http://localhost:55084/api/lucido/devops/GenerateReleaseFromFolder
$requestUrl = "$envUrl/api/lucido/devops/GenerateReleaseFromFolder"
Write-Host "Request url: $requestUrl"
$response = Invoke-RestMethod $requestUrl -Method 'POST' -UseDefaultCredentials -Headers $headers -Body $jsonBody

Write-Host $response

# Write-Host "Raw response..."
# Write-Host $response
# Write-Host "ConvertTo-Json..."
# $jsonResponse = $response | ConvertTo-Json
# Write-Host $jsonResponse
# Write-Host "ConertFrom-Json..."
# $objResponse = $jsonResponse | ConvertFrom-Json
# Write-Host $objResponse