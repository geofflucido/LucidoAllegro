param (
    [Parameter(Mandatory=$true)] [string] $directoryPath
)

. "$PSScriptRoot\pipeline-functions.ps1"

$directoryPath = $directoryPath.Replace('/', '\')

CleanUp($directoryPath)