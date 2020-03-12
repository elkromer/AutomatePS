#
# Script Module file for AutomatePS v1.216 module.
#
# Copyright (c) 2017 Reese Krome
#

. "$PSScriptRoot\Lib\fields.ps1"
. "$PSScriptRoot\Lib\functions.ps1"
. "$PSScriptRoot\modules\cmdlets.ps1"
. "$PSScriptRoot\modules\location.ps1"
. "$PSScriptRoot\modules\support.ps1"

Export-ModuleMember -Alias * -Function * -Variable desktop, mod, prg, prg86, prof, sysprof, profdir, emailaddress
