#
# Script Module file for AutomatePS module.
#
# Copyright (c) 2017 Reese Krome
#

. "$PSScriptRoot\Module\Fields.ps1"
. "$PSScriptRoot\Module\Remote.ps1"
. "$PSScriptRoot\Module\Functions.ps1"
. "$PSScriptRoot\Module\Aliases.ps1"
. "$PSScriptRoot\Module\Cmdlets.ps1"

Export-ModuleMember -Alias * -Function * -Cmdlet * -Variable desktop, mod, v10, v19, prg, prg86, prof, vm, myscripts, mllp, rudp, rudptestapp, nsoftwareBuildsEmailList