﻿$ErrorActionPreference = 'Stop'

$WorkSpace = Join-Path $env:TEMP "$env:ChocolateyPackageName.$env:chocolateyPackageVersion"

$WebFileArgs = @{
   packageName  = $env:ChocolateyPackageName
   FileFullPath = Join-Path $WorkSpace "$env:ChocolateyPackageName.exe"
   Url          = 'https://help.oclc.org/@api/deki/files/11721/ClientOnly2.63.exe?revision=1'
   Checksum     = '07dbb0e9a856ac9f336aff51145bd58547b2d9abb29b946841914d1e62036768'
   ChecksumType = 'sha256'
   GetOriginalFileName = $true
}

$PackedInstaller = Get-ChocolateyWebFile @WebFileArgs

$UnzipArgs = @{
   PackageName  = $env:ChocolateyPackageName
   FileFullPath = $PackedInstaller
   Destination  = $env:ChocolateyPackageFolder
}

Get-ChocolateyUnzip @UnzipArgs

$InstallArgs = @{
   PackageName    = $env:ChocolateyPackageName
   File           = (Get-ChildItem -Path $env:ChocolateyPackageFolder -Filter '*.msi').FullName
   fileType       = 'msi'
   silentArgs     = "/qn /norestart /l*v `"$($env:TEMP)\$($env:ChocolateyPackageName).$($env:chocolateyPackageVersion).MsiInstall.log`" ALLUSERS=1"
   validExitCodes = @(0, 3010, 1641)
}

Install-ChocolateyInstallPackage @InstallArgs
