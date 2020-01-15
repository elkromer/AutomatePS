#Requires -RunAsAdministrator

# Note: sftpDriveDockerProfile must be created to point to localhost:2222 and set to an explicit drive letter

param(
  [Parameter(Position=0,mandatory=$true)]
  [string] $Container = "",
  [string] $p,
  [string] $BuildArgs
)

$dockerDesktopPath = "C:\Program Files\Docker\Docker\Docker Desktop.exe"
$dockerFilesPath = "C:\Users\reese\source\repos\docker"
$dockerPollContainer = "ubuntu14_openssh78" 
$sftpDriveDockerProfile = "docker"
$sftpDriveLocation = "C:\Program Files\nsoftware\SFTP Drive V2"
$sftpDrivePath = "C:\Program Files\nsoftware\SFTP Drive V2\SFTPDrive.exe"
$sftpDriveLetter = "" # no need to set

$sshUsername = "test"
$sshPassword = "nbanana"

if ($p) {
  $length = $p.length
  $dockerInternalPort = $p.Substring($p.IndexOf(":")+1)
  $dockerExternalPort = $p.Substring(0, $p.IndexOf(":"))
} else {
  $dockerExternalPort = 2222;
  $dockerInternalPort = 22;
}

function Build-Container(){
  Push-Location $dockerFilesPath
  if ($BuildArgs) {
    Status "docker build --build-arg $BuildArgs . -f $dockerPollContainer -t lpcontainer --quiet" "OK" "Yellow"
    $retcode = (docker build --build-arg $BuildArgs . -f $dockerPollContainer -t lpcontainer --quiet)
  
  } else {
    Status "docker build . -f $dockerPollContainer -t lpcontainer --quiet" "OK" "Yellow"
    $retcode = (docker build . -f $dockerPollContainer -t lpcontainer --quiet)
  }
  Pop-Location
}

function Run-Container(){
  Status "docker run -p $dockerExternalPort`:$dockerInternalPort -d -t lpcontainer" "OK" "Yellow"
  $retcode = (docker run -p $dockerExternalPort`:$dockerInternalPort -d -t lpcontainer) 
  if (-not [string]::IsNullOrWhiteSpace($retcode)) {
    Status "Container $dockerPollContainer running on $dockerExternalPort." "OK" "Green"
  } else {
    throw "There was a problem starting the container."
  }
}
function Test-DockerDesktop(){
  $retcode = ""
  while ([string]::IsNullOrWhiteSpace($retcode)){
    Build-Container
    Sleep 8
  }
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
  Status "Docker Desktop starting..." "OK" "Yellow"
  Test-DockerDesktop
  Status "Docker Desktop started." "OK" "Green"
}

# Build the container
Build-Container
Run-Container