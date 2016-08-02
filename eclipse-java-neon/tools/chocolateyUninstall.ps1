$packageName = 'eclipse-java-neon'

$zipFileName = 'eclipse-java-neon-R-win32.zip'
if (Get-OSArchitectureWidth -eq 64) {
  $zipFileName = 'eclipse-java-neon-R-win32-x86_64.zip'
}

Uninstall-ChocolateyZipPackage $packageName $zipFileName

$desktop = $([Environment]::GetFolderPath([Environment+SpecialFolder]::CommonDesktopDirectory))
$shortcut = Join-Path $desktop 'Eclipse IDE (neon).lnk'
 
if (Test-Path $shortcut) {
    Write-Debug "Found the desktop shortcut. Deleting it..."
    Remove-Item $shortcut
}

