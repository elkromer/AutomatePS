<#
	.DESCRIPTION
		Private Module fields. These variables will only be visible to Cmdlets, Functions, and Aliases. Not the PS user.
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>

$SMSCredentials = ""

<#
	.DESCRIPTION
		Special functions that do something useful without the need for an alias. Can be used as building blocks for automation.
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
<#
	.SYNOPSIS
		Send an SMS to the default location
	.DESCRIPTION
		Uses cmdlets from this module to set credentials and send an SMS.
	.PARAMETER <msg>
		The message to send
	.EXAMPLE
		s "remember to go to the store"
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function s ([string] $msg) { SET-SMSCREDENTIALS; SEND-SMS $msg;}
function rdp ([string] $domain) { mstsc /v:$domain}
<#
	.SYNOPSIS
		Pushes kmodule to a remote machine
	.DESCRIPTION
		An alias function that pushes the symlinked kmodule to the default sftp directory on a remote machine.
	.EXAMPLE
		k
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function pushkmodule {Push-Location $desktop; sftph push kmodule.psm1; Pop-Location;}

<#
	.DESCRIPTION
		Alias functions that are not typically used from the command line. 
#>
function cdprogramfiles {Set-Location $prg}
function cdprogramfiles86 {Set-Location $prg86}
function cddesktop {Set-Location $desktop}
function cdtoolspath {Set-Location $toolspath}
function cdmyscripts {Set-Location $myscripts}
function cdv10 {Set-Location $v10}
function cdv19 {Set-Location $v19}
function cdmod {Set-Location $mod}
function cdvm {Set-Location $vm}
function openprof {code $prof}