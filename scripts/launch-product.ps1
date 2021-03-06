#Requires -RunAsAdministrator

# Note: sftpDriveDockerProfile must be created to point to localhost:2222 and set to an explicit drive letter

param(
  [Parameter(Position=0,mandatory=$true)]
  [string] $Sku,
  [string] $Container = "",
  [switch] $beta,
  [switch] $ssh
)
$dockerDesktopPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
$dockerFilesPath = "C:\Users\reese\source\repos\docker"
$dockerPollContainer = "ubuntu14_openssh78" 
$dockerExternalPort = 2222;
$dockerInternalPort = 22;

$sftpDriveDockerProfile = "docker"
$sftpDriveLocation = "C:\Program Files\nsoftware\SFTP Drive V2"
$sftpDrivePath = "C:\Program Files\nsoftware\SFTP Drive V2\SFTPDrive.exe"
$sftpDriveLetter = "" # no need to set

$sshUsername = "test"
$sshPassword = "nbanana"


function Test-DockerDesktop(){
  Push-Location $dockerFilesPath
  $retcode = ""
  while ([string]::IsNullOrWhiteSpace($retcode)){
    $retcode = (docker build . -f $dockerPollContainer -t lpcontainer --quiet)
    Sleep 8
  }
  Pop-Location
  return $retcode
}

# Start Docker Service
if ((Get-Service "Docker Desktop Service").Status -ne "Running") {
  Start-Service "Docker Desktop Service" -ErrorAction Stop
  Status "Started Docker Desktop Service." "OK" "Green"
} else {
  Status "Docker Desktop Service already running." "OK" "Yellow"
}

# Start Docker Desktop
if ($Container) { $dockerPollContainer = $Container }
try {
  $dockerDesktopId = (Get-Process "Docker Desktop" -ErrorAction Stop).Id
  Status "Docker Desktop already running." "OK" "Yellow"
} catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
  Start-Process -FilePath $dockerDesktopPath -Verb RunAs -ErrorAction Stop
}

# Build the container
Status "Docker Desktop starting..." "OK" "Yellow"
Test-DockerDesktop
Status "Docker Desktop started." "OK" "Green"

# Start the container
$retcode = (docker run -p "$dockerExternalPort`:$dockerInternalPort" -d -t lpcontainer)
if (-not [string]::IsNullOrWhiteSpace($retcode)) {
  Status "Container $dockerPollContainer running on $dockerExternalPort." "OK" "Green"
} else {
  throw "There was a problem starting the container."
}

# Start SFTPDrive
$profileExists = $false
Get-ChildItem -Path HKLM:\SOFTWARE\nsoftware\SFTPDrive\2\Drives | ForEach-Object {
  if ($_.Name -like "*$sftpDriveDockerProfile") {
    $profileExists = $true
    Set-ItemProperty -Path HKLM:\SOFTWARE\nsoftware\SFTPDrive\2\Drives\$sftpDriveDockerProfile -Name Enabled -Value 1 -ErrorAction Stop
    $sftpDriveLetter = (Get-ItemProperty -Path HKLM:\SOFTWARE\nsoftware\SFTPDrive\2\Drives\$sftpDriveDockerProfile -Name DriveLetter -ErrorAction Stop).DriveLetter
    Status "Enabled `"$sftpDriveDockerProfile`" profile ($sftpDriveLetter)." "OK" "Green"
  } 
}
if (-not $profileExists) { throw "SFTPDrive must contain a profile called $sftpDriveDockerProfile." }
try {
  $sftpDriveId = (Get-Process "SFTPDrive.exe" -ErrorAction Stop).Id
  Status "SFTPDrive already running." "OK" "Yellow"
} catch [Microsoft.PowerShell.Commands.ProcessCommandException] {
  Start-Process -FilePath $sftpDrivePath -ArgumentList "/start" -Verb RunAs -ErrorAction Stop
  Status "SFTPDrive started." "OK" "Green"
}

# Open explorer to j3
if ($beta) {
  fp -sku $Sku -e -beta
} else {
  fp -sku $Sku -e
}

if ($ssh) {
  ssh $sshUsername@localhost -p 2222
}

# Push-Location $sftpDriveLocation
# .\SFTPDrive.exe /start
# Pop-Location