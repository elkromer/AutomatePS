<#
.SYNOPSIS
  Removes unversioned files and folders from the specified major version. Optionally reverts all changes.
.NOTES
  Use with caution! This will delete files and undo any changes you have made locally in v10 or v20.
#>
param(
	[switch] $revert = $false,
	[switch] $v10 = $false,
	[switch] $v20 = $false
)
#requires -RunAs
function Revclean {
	param(
		[string] $path
	)
	if (Test-Path $path) { 
		if ($revert) {
			svn revert $path --depth=infinity
		}
		svn cleanup $path --remove-unversioned --remove-ignored
		svn update $path --depth=infinity --revision=HEAD
		Status "Cleaned up $($path | split-path -leaf)" "OK" "Green"
	} else {
		Status "The path was invalid." "Fail" "Red"
	}
}

if ($v10) { Revclean "C:\dev\branches\v10" }
elseif ($v20) { Revclean "C:\dev\branches\v20" }
else { 
	Revclean "C:\dev\branches\v10" 
	Revclean "C:\dev\branches\v20"
}
