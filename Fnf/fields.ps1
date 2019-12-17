<#
	.DESCRIPTION
		Public Module fields. In order to be visible when module is loaded, variable must be added to the list in the script module file.
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>

$desktop = "C:\Users\$env:UserName\Desktop"
$mod = "C:\Users\$env:UserName\Documents\WindowsPowerShell\Modules\AutomatePS"
$prg = "C:\Program Files"
$prg86 = "C:\Program Files (x86)"
$prof = "C:\Users\$env:UserName\Documents\WindowsPowerShell\Microsoft.PowerShell_profile.ps1"
$sysprof = "C:\Windows\System32\WindowsPowerShell\v1.0\Microsoft.PowerShell_profile.ps1"
$profdir = "C:\Users\$env:UserName\Documents\WindowsPowerShell\"
$emailaddress = "reesek@cdata.com"

<#
	.DESCRIPTION
		Aliases that help with getting around and doing tasks
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>

#Aliases
Set-Alias -Name prg -Value cdprogramfiles
Set-Alias -Name p86 -Value cdprogramfiles86
Set-Alias -Name mod -Value cdmod
Set-Alias -Name dsk -Value cddesktop
Set-Alias -Name z -Value Stop-Computer
Set-Alias -Name s -Value sendsms
Set-Alias -Name thesaur -Value callthesaurox