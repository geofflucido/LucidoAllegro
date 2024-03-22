param (
    [Parameter(Mandatory=$true)] [string] $deputyStagingDirectory,
    [Parameter(Mandatory=$true)] [string] $branch,
    [Parameter(Mandatory=$true)] [string] $baseBranch,
    [Parameter(Mandatory=$true)] [string] $packageType,
    [Parameter(Mandatory=$true)] [string] $diffMode
)

. "$PSScriptRoot\pipeline-functions.ps1"

$deputyStagingDirectory = $deputyStagingDirectory.Replace('/', '\')

Get-Changes $deputyStagingDirectory $branch $baseBranch $packageType $diffMode