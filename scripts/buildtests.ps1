<#
.SYNOPSIS
  Builds the test projects for NET, CPP and CPP-DEBUG. 
.NOTES
	- use subscription products and build paths
	- bring the aliases in here
#>
param(
		
)
$paths = New-Object System.Collections.Generic.List[System.Object]
$v10prodnames = $subscriptionproducts.v10
$v20prodnames = @(
	"IPWorks",
	"IPWorksAuth"
	"IPWorksCloud",
	"IPWorksEncrypt",
	"IPWorksMQ",
	"IPWorksOpenPGP",
	"IPWorksP2P",
	"IPWorksSFTP",
	"IPWorksSFTPServer",
	"IPWorksSMIME",
	"IPWorksSSH",
	"IPWorksWS",
	"IPWorksZip",
	"SFTPDrive"
)

foreach ($prod in $v10prodnames){
	$paths.Add("C:\dev\branches\v10\$prod\tests") 
}
foreach ($prod in $v20prodnames){
	$paths.Add("C:\dev\branches\v20\$prod\tests") 
}
function Build-Tests {
	param(
		[string] $path
	)
	if (Test-Path $path) { 
		Push-Location $path 
		try {
			tcl ".\csproj.tcl"
			tcl ".\cppproj.tcl"
			tcl ".\cppdebugproj.tcl"	
		} catch [Exception] { Log "caught exception $($_.Message)"}
		Status "Successfully built test projects in $($path | split-path -parent)" "OK" "green"
		Pop-Location
	} else {
		Status "The path was invalid." "Fail" "Red"
	}
}

Push-Location $tools
.\updatedlls.ps1
.\updatecppdlls.ps1
.\updatecpptestdlls.ps1
Pop-Location

foreach ($testpath in $paths) {
	Build-Tests $testpath
}
