<#
  .DESCRIPTION
    Functions for automating remote access
#>
<#
	.SYNOPSIS
		These functions are building blocks for automation that execute commands on remote machines by SSH.
	.DESCRIPTION
		These functions call Invoke-SSH on a specific machine. The command is passed as arguments to the function
	.PARAMETER <cmd>
		Space-separated list of commands and arguments.
	.EXAMPLE
		# SSH 
	
		sshh pwd
		sshh cd C:\temp# ls
		sshh cd C:\temp\test# ls
		sshh cd C:\temp\test# .\script.bat
		
		# SSH Powershell
		
		sshh pwd
		sshh push-location *desktop# .\somescript.ps1
		
	.NOTES
		Multiple commands can be passed with the # separator. Remote powershell variables are used with the * prefix.
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function sshh ([Parameter(ValueFromRemainingArguments=$true)][string[]] $cmd){ 
	#HOME DESKTOP
	$command = (($cmd -Join " ").replace("#", ";").replace("*", "$"))
	$resp = Invoke-SSH -Server 45.37.168.162 -User kouey -Password sfd4JK8466321 -Command $command -Force -Port 3596;
	$resp.Text 
}
function sshk ([Parameter(ValueFromRemainingArguments=$true)][string[]] $cmd){ 
	#KADEV
	$command = (($cmd -Join " ").replace("#", ";").replace("*", "$"))
	Log "Command: $command"
	$resp = Invoke-SSH -Server 10.0.1.67 -User joe -Password joe -Command $command -Force; 
	$resp.Text }
function sshn ([Parameter(ValueFromRemainingArguments=$true)][string[]] $cmd){ 
	#NIX
	$command = (($cmd -Join " ").replace("#", ";").replace("*", "$"))
	$resp = Invoke-SSH -Server 10.0.1.63 -User test -Password nbanana -Command $command -Force; 
	$resp.Text 
}
function ssht ([Parameter(ValueFromRemainingArguments=$true)][string[]] $cmd){ 
	#TESTGUY
	$command = (($cmd -Join " ").replace("#", ";").replace("*", "$"))
	$resp = Invoke-SSH -Server 10.0.1.56 -User administrator -Password admin -Command $command -Force; 
	$resp.Text 
}
<#
	.SYNOPSIS
		These functions are building blocks for automation that allow simple file transfer with a single command
	.DESCRIPTION
		These functions either call Get-SFTP or Send-SFTP based on the supplied parameters.
	.PARAMETER <cmd>
		A size two space-separated string array. The first string being the command itself, either 'get' or 'push'. The second string being the path to a file on the local or remote machine.
	.EXAMPLE
		sftpk get C:\temp\test.txt
		sftpk push test.txt
	.NOTES
		The functions are based out of the default sftp directory on the remote machine and the current working directory on the local machine.
	
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function sftph ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#HOME DESKTOP
	if ($args[0] -eq "get") {	
		Get-SFTP -Server 45.37.168.162 -Port 3596 -User kouey -Password sfd4JK8466321 -RemoteFile $args[1] -Localfile (".\" -Join (Split-Path $args[1] -leaf)) -Force 
	} elseif ($args[0] -eq "push") {
		Send-SFTP -Server 45.37.168.162 -Port 3596 -User kouey -Password sfd4JK8466321 -RemoteFile (".\" -Join (Split-Path $args[1] -leaf)) -LocalFile $args[1] -Force -Overwrite
	} else {
		Log "Incorrect Usage" $false $true "red"
	}
} 
function sftpk ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#KADEV
	if ($args[0] -eq "get") {	
		Get-SFTP -Server 10.0.1.67 -User joe -Password joe -RemoteFile $args[1] -Localfile (".\" -Join (Split-Path $args[1] -leaf)) -Force 
	} elseif ($args[0] -eq "push") {
		Send-SFTP -Server 10.0.1.67 -User joe -Password joe -RemoteFile (".\" -Join (Split-Path $args[1] -leaf)) -LocalFile $args[1] -Force -Overwrite
	} else {
		Log "Incorrect Usage" $false $true "red"
	}
} 
function sftpn ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#NIX
	if ($args[0] -eq "get") {	
		Get-SFTP -Server 10.0.1.63 -User test -Password nbanana -RemoteFile $args[1] -Localfile (".\" -Join (Split-Path $args[1] -leaf)) -Force 
	} elseif ($args[0] -eq "push") {
		Send-SFTP -Server 10.0.1.63 -User test -Password nbanana -RemoteFile (".\" -Join (Split-Path $args[1] -leaf)) -LocalFile $args[1] -Force -Overwrite
	} else {
		Log "Incorrect Usage" $false $true "red"
	}
} 
function sftpt ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#TESTGUY
	if ($args[0] -eq "get") {	
		Get-SFTP -Server 10.0.1.56 -User administrator -Password admin -RemoteFile $args[1] -Localfile (".\" -Join (Split-Path $args[1] -leaf)) -Force 
	} elseif ($args[0] -eq "push") {
		Send-SFTP -Server 10.0.1.56 -User administrator -Password admin -RemoteFile (".\" -Join (Split-Path $args[1] -leaf)) -LocalFile $args[1] -Force -Overwrite
	} else {
		Log "Incorrect Usage" $false $true "red"
	}
} 
