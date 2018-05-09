Param (
    $Package = 'dbUp',
    $Repository,
    $Target = '.'
)

$ErrorActionPreference = 'Stop'

$repoFolder = Join-Path $Repository $pkg.BaseName
$currentVersionFolder = Join-Path $repoFolder 'Current'

if (!(Test-Path $currentVersionFolder)) {
    throw "Path $currentVersionFolder not found"
}

Copy-Item (Get-ChildItem $currentVersionFolder) $Target