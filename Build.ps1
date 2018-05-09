Param (
    $Package = '.\dbUp.zip',
	$ScriptPath = '.\Code',
	$HistoryPath = '.\History',
    $Version
)

$ErrorActionPreference = 'Stop'

$pkgName = $Package
if ($Version) {
    $newVer = [Version]$Version
}
else {
    $newVer = [Version]'1.0'
}
# Ensure version has three parts
if ($newVer.Build -eq -1) {
    $newVer = [version]::new($newVer.Major, $newVer.Minor, 0)
}
if (Test-Path $pkgName) {
    Remove-Item $pkgName
}
if (Test-Path $HistoryPath\$pkgName) {
    $pkg = Get-DBOPackage $HistoryPath\$pkgName
    Copy-Item $pkg . -Force
    $oldVer = [Version]$pkg.Version
    if (!$Version -or $newVer.CompareTo([version]::new($oldVer.Major, $oldVer.Minor)) -eq 0) {
        $newVer = [Version]::new($oldVer.Major, $oldVer.Minor, $oldVer.Build+1)
    }
    Add-DBOBuild -Package $pkgName -ScriptPath $scriptPath -Type New -Build $newVer.ToString(3)
}
else {
    New-DBOPackage -Name $pkgName -ScriptPath $scriptPath -Build $newVer.ToString(3)
}