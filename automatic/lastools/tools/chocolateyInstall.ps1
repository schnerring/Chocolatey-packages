﻿$ErrorActionPreference = 'Stop'  # stop on all errors

$url      = 'http://www.cs.unc.edu/~isenburg/lastools/download/LAStools.zip'
$CheckSum = 'afc2906fc9437903e9cad46fef7c17129a021022026f12621eb5183ea160d394'

$ZipArgs = @{
   PackageName   = 'lastools'
   Url           = $url
   Checksum      = $CheckSum
   ChecksumType  = 'sha256'
   UnzipLocation = Split-Path (Split-Path -parent $MyInvocation.MyCommand.Definition)
}

Install-ChocolateyZipPackage @ZipArgs

$exes = Get-ChildItem $ZipArgs.UnzipLocation -filter *.exe -Recurse |select -ExpandProperty fullname
$txts = Get-ChildItem $ZipArgs.UnzipLocation -filter *.txt -Recurse |select -ExpandProperty fullname

foreach ($exe in $exes) {
   if ($txts -notcontains ($exe.trim('.exe') + '_README.txt')) {
      New-Item "$exe.ignore" -Type file -Force | Out-Null
   }
}

$GUI = (Get-ChildItem $ZipArgs.UnzipLocation -filter lastool.exe -Recurse).fullname
New-Item "$GUI.gui" -Type file -Force | Out-Null

$ShortcutArgs = @{
   ShortcutFilePath = Join-Path ([Environment]::GetFolderPath('Desktop')) 'LASTool.lnk'
   TargetPath = $GUI
}

Install-ChocolateyShortcut @ShortcutArgs
