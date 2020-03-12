# NUKE and install latest SFTP Drive
#Requires -RunAsAdministrator

if (Test-Path -Path "HKCU:\Software\nsoftware\SFTPDrive") { 
  Remove-Item -Path "HKCU:\Software\nsoftware\SFTPDrive" -ErrorAction Stop 
  Status "Successfully nuked HKCU settings." "OK" "Green"
} else {
  Status "No HKCU configuration present." "OK" "Yellow"
}

If (Test-Path -Path "HKLM:\Software\nsoftware\SFTPDrive") {
  Remove-Item -Path "HKLM:\Software\nsoftware\SFTPDrive" -ErrorAction Stop
  Status "Successfully nuked HKLM settings." "OK" "Green"
} else {
  Status "No HKLM configuration present." "OK" "Yellow"
}

Start-Process -FilePath "C:\Program Files\nsoftware\SFTP Drive V2\uninstall.exe" -Verb RunAs -ArgumentList "/S" -Wait -ErrorAction Stop
# TODO: Uninstall CBFS Drivers

Status "Successfully uninstalled SFTP Drive." "OK" "Green"

fp ndx2a -i -silent




