<#
	.SYNOPSIS
		Function executes a command on nix
	.DESCRIPTION
		Function makes a call to Invoke-SSH
	.PARAMETER <cmd>
		A hashtag delimited list of commands to execute. Powershell variables can be accessed with '*'
	.EXAMPLE
		sshn pwd
	.EXAMPLE
		sshn cd C:\temp\test# .\script.bat
	.EXAMPLE
		ssht *profile
	.NOTES
		Multiple commands can be passed with the # delimiter. Remote powershell variables are accessed with the * prefix.
		Author: Reese Krome
		Email: reesek@cdata.com
#>
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
		Function executes an sftp GET or PUSH command on nix
	.DESCRIPTION
		Function makes a call to Get-SFTP or Send-SFTP depending on the command parameter.
	.PARAMETER Cmd
		Either 'get' or 'push'
	.PARAMETER File
		A string path of the remote file to GET or local file to PUSH.
	.EXAMPLE
		sftpk get C:\temp\test.txt
		sftpk push test.txt
	.NOTES
		The default sftp directory is used.
	
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function sftpn ([string] $cmd = "get", [string] $file){
	#NIX
	if ($cmd.ToLower() -eq "get") {	
		Get-SFTP -Server 10.0.1.63 -User test -Password nbanana -RemoteFile $file -Localfile (".\" -Join (Split-Path $file -leaf)) -Force -Overwrite
	} elseif ($cmd.ToLower() -eq "push") {
		Send-SFTP -Server 10.0.1.63 -User test -Password nbanana -RemoteFile (".\" -Join (Split-Path $file -leaf)) -LocalFile $file -Force -Overwrite
	} else {
		Status "Unexpected command." "Failed" "red"
	}
} 
function sftpt ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#TESTGUY
	#NIX
	if ($cmd.ToLower() -eq "get") {	
		Get-SFTP -Server 10.0.1.63 -User administrator -Password admin -RemoteFile $file -Localfile (".\" -Join (Split-Path $file -leaf)) -Force -Overwrite
	} elseif ($cmd.ToLower() -eq "push") {
		Send-SFTP -Server 10.0.1.63 -User administrator -Password admin -RemoteFile (".\" -Join (Split-Path $file -leaf)) -LocalFile $file -Force -Overwrite
	} else {
		Status "Unexpected command." "Failed" "red"
	}
} 
