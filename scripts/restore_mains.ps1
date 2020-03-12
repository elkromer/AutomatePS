Push-Location C:\dev\branches\v10

Get-ChildItem | % {
	if (Test-Path "$_\tests") {
    Push-Location "$_\tests"
    if (Test-Path "C:\temp\mainbackups\$_-v10.cs") {
      Copy-Item "C:\temp\mainbackups\$_-v10.cs" "main.cs"
    }
		Pop-Location
	}	
}

Pop-Location

Push-Location C:\dev\branches\v20

Get-ChildItem | % {
	if (Test-Path "$_\tests") {
    Push-Location "$_\tests"
    if (Test-Path "C:\temp\mainbackups\$_-v20.cs"){
      Copy-Item "C:\temp\mainbackups\$_-v20.cs" "main.cs"
    }
		Pop-Location
	}	
}

Pop-Location
