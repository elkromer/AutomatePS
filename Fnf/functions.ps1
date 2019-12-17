<#
	.SYNOPSIS
		Send an SMS to the default number
	.DESCRIPTION
		Uses cmdlets from this module to set credentials and send an SMS.
	.PARAMETER <msg>
		The message to send
	.EXAMPLE
		sendsms "remember to go to the store"
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function sendsms ([string] $msg) { SET-SMSCREDENTIALS; SEND-SMS $msg;}
<#
	.SYNOPSIS
		Starts a remote desktop connection to the specified IP or domain name
	.DESCRIPTION
		Starts the mstsc service
	.PARAMETER <domain>
		The IP address or domain name to connect to
	.EXAMPLE
		rdp kadev
		rdp 10.0.1.67
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function rdp ([string] $domain) { mstsc /v:$domain}
<#
	.SYNOPSIS
		Open powershell profile
	.DESCRIPTION
		Opens the powershell profile for editing in visual studio code in Documents/WindowsPowerShell
	.EXAMPLE
		openprof
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function openprof {notepad $prof}
<#
	.DESCRIPTION
		Alias functions that are not typically used from the command line. 
#>
function Convert-b64([string] $message){
	$Bytes = ([System.Text.Encoding]::Unicode.GetBytes($message))
	return [Convert]::ToBase64String($Bytes)
}
function ConvertFrom-b64([string] $message){
	return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($message))
}

<#
.DESCRIPTION
	Alias functions
#>
function cdprogramfiles {Set-Location $prg}
function cdprogramfiles86 {Set-Location $prg86}
function cddesktop {Set-Location $desktop}
function cdmod {Set-Location $mod}
function callthesaurox ([string] $query) {Thesaur-Ox $query}