# Author: Michael Harhay
# Copyright: Arxtron Technologies Inc.. All Rights Reserved.
# Date: 2025/10/17 
# Description: This script automates updating the master
#              branch after a new release is made. Should
#              be run after ReleaseScript.ps1


# ----------------------- Setup ----------------------- #
$Root = Split-Path -Parent $MyInvocation.MyCommand.Definition

$glbCurrentBranch = git branch --show-current
$glbLibName = Split-Path -Path (Get-Location) -Leaf
$glbLibPathName = "LabWindows\" + $glbLibName

$glbPrjFilePath = Get-ChildItem -Path $Root -Filter *.prj -File | Select-Object -First 1 -ExpandProperty FullName
$glbBuildFilePath = Get-ChildItem -Path $Root -Filter *.dll -File | Select-Object -First 1 -ExpandProperty FullName
$glbReleaseNotesFilePath = Join-Path $Root "ReleaseNotes.md"


# ------------------ Main Execution ------------------- #

# 1. Check for GitHub CLI, install if necessary
Write-Host "`n==> Checking that GitHub CLI is installed..." -ForegroundColor Cyan
gh --version

if ($LASTEXITCODE -ne 0)
{
    Write-Host "GitHub CLI not installed. Installing now..." -ForegroundColor Yellow
    winget install GitHub.cli
}



# 2. Get version number from project file
git checkout release

$prjFileContent = Get-Content $glbPrjFilePath -Raw
if ($prjFileContent -match 'Numeric File Version\s*=\s*"([\d,]+)"') 
{
    $versionNum = $Matches[1]
    Write-Host "Current version: $versionNum"
} 
else 
{
    Write-Host "Error: no project version number found." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}



# 3. Pull master branch, tag, push
Write-Host "`n==> Pulling remote master branch..." -ForegroundColor Cyan
git checkout master
git pull origin master

if ($LASTEXITCODE -ne 0)
{
    Write-Host "Error: could not pull from remote master branch." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}

Write-Host "`n==> Tagging release & pushing to remote..." -ForegroundColor Cyan
$tagNum = "v" + $versionNum
git tag $tagNum
git push origin --tags

if ($LASTEXITCODE -ne 0)
{
    Write-Host "Error: could not push tag to remote master branch." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}



# 4. Create GitHub release
gh release create $tagNum $glbBuildFilePath --title "Release $tagNum" --notes-file $glbReleaseNotesFilePath

if ($LASTEXITCODE -ne 0)
{
    Write-Host "Error: issue creating GitHub release." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}



# 5. Merge back to develop
Write-Host "`n==> Merging master branch back into develop..." -ForegroundColor Cyan
git checkout develop
git merge master --no-ff
git push origin develop

if ($LASTEXITCODE -ne 0)
{
    Write-Host "Error: could not merge back to develop." -ForegroundColor Red
    Read-Host "Press Enter to exit..."
    exit 1
}


<#
# 6. Change directory to SourceLibraries, commit changes
Write-Host "`n==> Committing change to SourceLibraries..." -ForegroundColor Cyan

cd ..
cd ..
$currentDir = Split-Path -Path (Get-Location) -Leaf
while ($currentDir -ne "SourceLibraries")
{
    Write-Host "Could not find SourceLibraries." -ForegroundColor Yellow
    $srcLibPath = Read-Host "Please enter path:"
}
cd $srcLibPath

git add $glbLibPathName
git commit -m "New release for ${glbLibName}: $tagNum"
git push origin master
#>


# 7. End script
git checkout $currentBranch
Write-Host "`nScript execution complete." -ForegroundColor Green
Read-Host "Press Enter to exit..."