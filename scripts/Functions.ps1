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
function openprof {code $prof}
<#
	.DESCRIPTION
		Functions used by aliases	  
#>
<#
	.DESCRIPTION
		Alias functions that are not typically used from the command line. 
#>
function reloadprofile {Set-Location $profdir; . "Microsoft.PowerShell_profile.ps1" }
function cdprogramfiles {Set-Location $prg}
function cdprogramfiles86 {Set-Location $prg86}
function cddesktop {Set-Location $desktop}
function cdmyscripts {Set-Location $myscripts}
function cdmod {Set-Location $mod}
function cdvm {Set-Location $vm}
