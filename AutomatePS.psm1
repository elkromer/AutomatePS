#
# Script Module file for AutomatePS module.
#
# Copyright (c) 2017 Reese Krome
#

. "$PSScriptRoot\scripts\Fields.ps1"
. "$PSScriptRoot\scripts\Remote.ps1"
. "$PSScriptRoot\scripts\Functions.ps1"
. "$PSScriptRoot\scripts\Aliases.ps1"
. "$PSScriptRoot\scripts\Cmdlets.ps1"

Export-ModuleMember -Alias * -Function * -Cmdlet * -Variable desktop, mod, v10, v19, prg, prg86, prof, vm, myscripts, mllp, rudp, rudptestapp, nsoftwareBuildsEmailList