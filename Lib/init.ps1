<#
	.DESCRIPTION
		Builds the product name mappings for utility functions
#>
if (-not (Test-Path "C:\Users\$env:UserName\source")) {
	Write-Host "C:\Users\$env:UserName\source does not exist. Creating it."
	mkdir "C:\Users\$env:UserName\source"
}

if (-not (Test-Path "C:\Users\$env:UserName\source\repos")) {
	Write-Host "C:\Users\$env:UserName\source\repos does not exist. Creating it."
	mkdir "C:\Users\$env:UserName\source\repos"
}

$v10productNames = $v10products.net
$v20productNames = $v20products.net
$v10NameMap = @{}
$v20NameMap = @{}

foreach ($prodname in $v10productNames){
	$v10NameMap.Add($prodname.ToLower(),(Join-Path "C:\dev\branches\v10" "$prodname\tests"))
}
foreach ($prodname in $v20productNames){
	$v20NameMap.Add($prodname.ToLower(), (Join-Path "C:\dev\branches\v20" "$prodname\tests"))
}
$v20NameMap.Add("sftpdrive", "C:\dev\branches\v20\SFTPDrive\tests")

<#
	.DESCRIPTION
		Public Module fields. In order to be visible when module is loaded, variable must be added to the list in the script module file.
#>
$mod 						 = "$((Split-Path $PSScriptRoot -Parent))"
$res 		   		 		 = "$((Split-Path $PSScriptRoot -Parent))\Resources"
$scr 						 = "$((Split-Path $PSScriptRoot -Parent))\Scripts"
$hom 						 = "C:\Users\$env:UserName"
$prg 						 = "C:\Program Files"
$prg86 						 = "C:\Program Files (x86)"
$tools 						 = "C:\dev\tools\scripts"
$emailaddress 				 = "reesek@nsoftware.com"
$smsemail					 = "hkrome26@gmail.com"
$smspass					 = "4P5@fpKT5r"
$phone						 = "9196217286"
$phonecarrier				 = "Verizon"
$nsoft 				 		 = "$prg\nsoftware";
$prof 						 = "$hom\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$profdir 					 = "$hom\Documents\WindowsPowerShell\"
$desktop 					 = "$hom\Desktop"
$ndockerpath 				 = "$tools\docker\nsoftware";
$dockerpath 				 = "$tools\docker\nsoftware\support"

<#
.DESCRIPTION
	Change location functions
#>
function cdprogramfiles { Set-Location $prg }
function cdprogramfiles86 { Set-Location $prg86 }
function cddesktop { Set-Location $desktop }
function cdmod { Set-Location $mod }
function cdscripts { Set-Location $scr }
function Set-ToolsPath(){ Set-Location $tools }
function Set-SftpDrivePerformanceLogPath(){ Set-Location $sftpdriveperformancelogpath }
function Set-SftpDriveBinPath(){ Set-Location $sftpdrivebinpath }
function Set-DockerPath(){ Set-Location $dockerpath }
function Set-RabbitPath(){ Set-Location $rabbitctlpath }
function Set-RabbitLogPath(){ Set-Location $rabbitlogpath }
function Set-ReleasePath(){ Set-Location $v20releasepath }
function Set-V10Path(){ Set-Location $v10 }
function Set-V20Path(){ Set-Location $v20 }
function Set-NsoftwarePath(){ Set-Location $nsoft }
function Get-TailPerformanceLog(){ Set-SftpDrivePerformanceLogPath; Get-Content performance.txt -wait }
function Set-NsoftwareDockerPath(){ Set-Location $ndockerpath }
function Start-SFTPDrive(){ Start-Process $sftpdrivepath -ArgumentList "/start" }

<#
	.DESCRIPTION
		Aliases that help with getting around and doing tasks
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
Set-Alias -Name z -Value Stop-Computer
Set-Alias -Name s -Value Do-SendSMS
Set-Alias -Name prg -Value cdprogramfiles
Set-Alias -Name p86 -Value cdprogramfiles86
Set-Alias -Name mod -Value cdmod
Set-Alias -Name dsk -Value cddesktop
Set-Alias -Name cmp -Value cdcompose
Set-Alias -Name vmip -Value Get-VMIPAddresses
Set-Alias -Name find -Value Do-TclSearch
Set-Alias -Name scripts -Value cdcompose
Set-Alias -Name thesaur -Value Do-ThesaurusLookup
Set-Alias -Name b -Value Search-Bugz
Set-Alias -Name tl -Value Set-ToolsPath
Set-Alias -Name fp -Value "$tools\Find-Product.ps1"
Set-Alias -Name dll -Value Get-DLLs -Scope Global
Set-Alias -name lic -value "$tools\toggle-lic.ps1" -Scope Global
Set-Alias -name gbn -value "$tools\get-buildnumber.ps1" -Scope Global
Set-Alias -name gmi -value Get-SupportInfo -Scope Global
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