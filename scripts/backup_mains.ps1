# copy mains

if (-not (Test-Path "C:\temp\mainbackups")){
	mkdir "C:\temp\mainbackups"
}

if (-not (Test-Path "C:\temp\backupbuilds")){
	mkdir "C:\temp\backupbuilds"
}

Push-Location C:\dev\branches\v10

Get-ChildItem | % {
	if (Test-Path "$_\tests") {
		Push-Location "$_\tests"
		if (Test-Path "main.cs"){ 
		
			Copy-Item "main.cs" "C:\temp\mainbackups\$_-v10.cs"
		
		}
		Pop-Location
	}	
}

Pop-Location

Push-Location C:\dev\branches\v20

Get-ChildItem | % {
	if (Test-Path "$_\tests") {
		Push-Location "$_\tests"
		if (Test-Path "main.cs"){ 
		
			Copy-Item "main.cs" "C:\temp\mainbackups\$_-v20.cs"
		
		}
		Pop-Location
	}	
}

Pop-Location

Status "Backed up mains." "OK" "Green"

Push-Location "C:\Program Files\nsoftware"

Get-ChildItem | % {
	Copy-Item "$_" "C:\temp\backupbuilds\$_" -Recurse -Force -ErrorAction Stop
	Status "Backed up $_ " "OK" "Green"
}

Pop-Location