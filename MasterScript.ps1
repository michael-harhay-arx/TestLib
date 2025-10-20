# Author: Michael Harhay
# Copyright: Arxtron Technologies Inc.. All Rights Reserved.
# Date: 2025/10/17 
# Description: This script automates updating the master
#              branch after a new release is made. Should
#              be run after ReleaseScript.ps1


# ----------------------- Setup ----------------------- #
$glbCurrentBranch = git branch --show-current
$glbLibName = Split-Path -Path (Get-Location) -Leaf
$glbLibPathName = "LabWindows\" + $glbLibName

$glbPrjFilePath = Get-ChildItem -Path $Root -Filter *.prj -File | Select-Object -First 1 -ExpandProperty FullName


# ------------------ Main Execution ------------------- #

# 1. Pull master branch
Write-Host "`n==> Fetching remote master branch..." -ForegroundColor Cyan
git checkout master
git fetch origin master



# 2. Tag release, commit and push
Write-Host "`n==> Tagging release & pushing to remote..." -ForegroundColor Cyan
$tagNum = "v" + $versionNum
git tag $tagNum
git push origin master



# 3. Change directory to SourceLibraries, commit changes
Write-Host "`n==> Committing change to SourceLibraries..." -ForegroundColor Cyan
<#
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


# 4. End script
git checkout $currentBranch
Write-Host "`nScript execution complete." -ForegroundColor Green
Read-Host "Press Enter to exit..."