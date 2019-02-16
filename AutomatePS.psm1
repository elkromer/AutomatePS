#
# Script Module file for AutomatePS module.
#
# Copyright (c) 2017 Reese Krome
#

. "$PSScriptRoot\Fnf\fields.ps1"
. "$PSScriptRoot\Fnf\functions.ps1"
. "$PSScriptRoot\Module\optimize.ps1"
. "$PSScriptRoot\Module\cmdlets.ps1"
. "$PSScriptRoot\Module\location.ps1"
. "$PSScriptRoot\Module\support.ps1"

Export-ModuleMember -Alias * -Function * -Cmdlet * -Variable desktop, mod, prg, prg86, prof, sysprof, profdir, myscripts, emailaddress