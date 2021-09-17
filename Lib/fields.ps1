<#
	.DESCRIPTION
		Public Module fields. In order to be visible when module is loaded, variable must be added to the list in the script module file.
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>

$desktop = "C:\Users\$env:UserName\Desktop"
$mod = "$((Split-Path $PSScriptRoot -Parent))"
$prg = "C:\Program Files"
$prg86 = "C:\Program Files (x86)"
$prof = "C:\Users\$env:UserName\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$sysprof = "C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1"
$profdir = "C:\Users\$env:UserName\Documents\WindowsPowerShell\"
$emailaddress = "reesek@nsoftware.com"
$nsoftwarepath = "C:\Program Files\nsoftware";
$mozillapath = "C:\Program Files\Mozilla Firefox\firefox.exe";
$sftpdrivepath = "C:\Program Files\nsoftware\SFTP Drive V2\SFTPDrive.exe";
$repos = "C:\Users\$env:UserName\source\repos"
<#
	.DESCRIPTION
	  From WorkPS
#>
$compose = "$repos\docker\compose\"
$resourcepath = "$((Split-Path $PSScriptRoot -Parent))\Resources"
$scriptspath = "$((Split-Path $PSScriptRoot -Parent))\Scripts"
$tools = "C:\dev\tools\scripts"
$ndockerpath = "$tools\docker\nsoftware";
$dockerpath = "$tools\docker\nsoftware\support"
$rabbitlogpath = "C:\Users\reese\AppData\Roaming\RabbitMQ\log"
$rabbitctlpath = "C:\Program Files\RabbitMQ Server\rabbitmq_server-3.7.16\sbin"
$sftpdriveperformancelogpath = "C:\dev\branches\v20\SFTPDrive\tests";
$sftpdrivebinpath = "C:\dev\branches\v20\SFTPDrive\tests\bin\Release";

<#
.DESCRIPTION
	Change location functions
#>
function cdprogramfiles {Set-Location $prg}
function cdprogramfiles86 {Set-Location $prg86}
function cddesktop {Set-Location $desktop}
function cdmod {Set-Location $mod}
function cdcompose {Set-Location $compose}
function cdscripts {Set-Location $scriptspath}
function Set-ToolsPath(){Set-Location $tools}
function Set-SftpDrivePerformanceLogPath(){Set-Location $sftpdriveperformancelogpath}
function Set-SftpDriveBinPath(){Set-Location $sftpdrivebinpath}
function Set-DockerPath(){Set-Location $dockerpath}
function Set-RabbitPath(){Set-Location $rabbitctlpath}
function Set-RabbitLogPath(){Set-Location $rabbitlogpath}
function Set-ReleasePath([switch] $v10){ if ($v10){ Set-Location $v10releasepath } else {Set-Location $v20releasepath } }
function Set-V10Path(){ Set-Location $v10  }
function Set-V20Path(){ Set-Location $v20  }
function Set-NsoftwarePath(){ Set-Location $nsoftwarepath  }
function Get-TailPerformanceLog(){Set-SftpDrivePerformanceLogPath; Get-Content performance.txt -wait}
function Set-NsoftwareDockerPath(){ Set-Location $ndockerpath }
function Start-SFTPDrive(){ Start-Process $sftpdrivepath -ArgumentList "/start" }

<#
	.DESCRIPTION
		Aliases that help with getting around and doing tasks
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>

#Aliases
Set-Alias -Name z -Value Stop-Computer
Set-Alias -Name s -Value sendsms
Set-Alias -Name prg -Value cdprogramfiles
Set-Alias -Name p86 -Value cdprogramfiles86
Set-Alias -Name mod -Value cdmod
Set-Alias -Name dsk -Value cddesktop
Set-Alias -Name cmp -Value cdcompose
Set-Alias -Name vmip -Value Get-VMIPAddresses
Set-Alias -Name find -Value tclsearch
Set-Alias -Name scripts -Value cdcompose
Set-Alias -Name thesaur -Value callthesaurox
# WorkPS
Set-Alias -Name b -Value Search-Bugz
Set-Alias -Name tl -Value Set-ToolsPath
Set-Alias -Name fp -Value "$tools\Find-Product.ps1"
Set-Alias -Name dll -Value Get-DLLs -Scope Global
Set-Alias -name lic -value "$tools\toggle-lic.ps1" -Scope Global
Set-Alias -name gbn -value "$tools\get-buildnumber.ps1" -Scope Global
Set-Alias -name gmi -value Get-MoreInfo -Scope Global
Set-Alias -Name v10 -Value Set-V10Path -Scope Global
Set-Alias -Name v20 -Value Set-V20Path -Scope Global
Set-Alias -Name sku -Value Find-SKU -Scope Global
Set-Alias -Name dock -Value Set-DockerPath
Set-Alias -Name nsoft -Value Set-NsoftwarePath -Scope Global
Set-Alias -Name ndock -Value Set-NsoftwareDockerPath
Set-Alias -Name rabbit -Value Set-RabbitPath
Set-Alias -Name rabbitlog -Value Set-RabbitLogPath
Set-Alias -name nettest -value Start-Net -Scope Global
Set-Alias -name cpptest -value Start-Cpp -Scope Global
Set-Alias -name cppdtest -value Start-CppDebug -Scope Global
Set-Alias -Name svnlog -Value Get-SVNLog -Scope Global
Set-Alias -Name dockertags -Value Get-DockerTags -Scope Global
Set-Alias -Name dockerstop -Value Stop-Containers -Scope Global
Set-Alias -Name dockerrm -Value Remove-Containers -Scope Global
Set-Alias -Name dockerclear -Value Clear-Containers -Scope Global
Set-Alias -Name release -Value Set-ReleasePath -Scope Global
Set-Alias -Name gbndll -Value Get-DLLBuildNumbers -Scope Global
Set-Alias -Name dlltime -Value Get-DLLModifiedTime -Scope Global
Set-Alias -Name codetime -Value Get-CodeModifiedTime -Scope Global
Set-Alias -Name perflog -Value Get-TailPerformanceLog
Set-Alias -Name perfexe -Value Start-PerformanceTest
Set-Alias -Name green -Value Format-GreenFolder
Set-Alias -Name red -Value Format-RedFolder
Set-Alias -Name cc -Value Remove-SetIcon
Set-Alias -Name getuser -Value Get-UserFromSID
Set-Alias -Name getsid -Value Get-SIDFromUser
Set-Alias -Name drives -Value Start-SFTPDrive