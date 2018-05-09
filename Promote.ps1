Param (
    $Package = '.\dbUp.zip',
    $Repository,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'

if (!(Test-Path $Repository)) {
    throw "Path $Repository not found"
}

$pkg = Get-DBOPackage $Package

#Create folders if needed
$repoFolder = Join-Path $Repository $pkg.BaseName
New-Item $repoFolder -Type Directory -Force

$versionsFolder = Join-Path $repoFolder 'Versions'
$currentVersionFolder = Join-Path $repoFolder 'Current'

New-Item $versionsFolder -Type Directory -Force
New-Item $currentVersionFolder -Type Directory -Force

# Copy old package to versions
$oldFile = Join-Path $currentVersionFolder $pkg.Name
if (Test-Path $oldFile) {
    $oldPkg = Get-DBOPackage $oldFile
    $versionDir = Join-Path $versionsFolder $oldPkg.Version
    New-Item $versionDir -Type Directory -Force
    Copy-Item $oldPkg $versionDir
}

# Copy new package to current
Copy-Item $pkg $currentVersionFolder






