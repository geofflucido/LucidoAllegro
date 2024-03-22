function CleanUp {
    param (
        [Parameter(Mandatory=$true)] [string] $diretoryPath
    )

    Write-Host "Cleaning up directory $diretoryPath"

    # Check if the directory exists
    if (Test-Path -Path $diretoryPath) {
        # Remove the directory
        Remove-Item -Path $diretoryPath -Recurse -Force
    } else {
        Write-Host "Directory does not exist."
    }
}

function Get-Changes([string]$deputyStagingDirectory, [string]$branch, [string]$baseBranch, [string]$packageType, [string]$diffMode) {

    Write-Host "Copying changes to $deputyStagingDirectory"

    git fetch --all

    if ($packageType -eq "Incremental") {
        if ($diffMode -eq "Incremental") {
            $files = git diff --name-only origin/$baseBranch...origin/$branch
        } elseif ($diffMode -eq "Full") {
            $files = git diff --name-only origin/$baseBranch origin/$branch
        }
    } else {
        $files = Get-ChildItem -File -Recurse | Select-Object -ExpandProperty FullName
    }

    foreach ($_ in $files) { 

        if (-not $_.EndsWith(".xml")) {
            continue #skip non xml files
        }

        $currentLocation = (Get-Location).Path + "\";
        if ($_.StartsWith($currentLocation)) {
            $sourceFile = $_
        } else {
            $sourceFile = $currentLocation + $_.Replace("/", "\")
        }

        $sourceDirectory = Split-Path -Path $sourceFile
        $targetRelativePath = $sourceDirectory.Replace($currentLocation, "")
        $targetDir = Join-Path -Path $deputyStagingDirectory -ChildPath $targetRelativePath

        # Check if the source file exists
        if (Test-Path -Path $sourceFile -PathType Leaf) {

            # Check if the target directory exists
            if (-not (Test-Path -Path $targetDir -PathType Container)) {
                Write-Host "Creating directory $targetDir"
                New-Item -ItemType Directory -Force -Path $targetDir
            }
            
            # Copy the file to the target directory
            Write-Host "Copying $sourceFile to $targetDir"
            Copy-Item $sourceFile -Destination $targetDir
        }
    }  
}