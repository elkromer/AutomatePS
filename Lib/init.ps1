if (-not (Test-Path "C:\Users\$env:UserName\source")) {
	Write-Host "C:\Users\$env:UserName\source does not exist. Creating it."
	mkdir "C:\Users\$env:UserName\source"
}

if (-not (Test-Path "C:\Users\$env:UserName\source\repos")) {
	Write-Host "C:\Users\$env:UserName\source\repos does not exist. Creating it."
	mkdir "C:\Users\$env:UserName\source\repos"
}

$v10productNames = $v10products.net
$v20productNames = $v20products.net
$v10NameMap = @{}
$v20NameMap = @{}

foreach ($prodname in $v10productNames){
	$v10NameMap.Add($prodname.ToLower(),(Join-Path "C:\dev\branches\v10" "$prodname\tests"))
}
foreach ($prodname in $v20productNames){
	$v20NameMap.Add($prodname.ToLower(), (Join-Path "C:\dev\branches\v20" "$prodname\tests"))
}
$v20NameMap.Add("sftpdrive", "C:\dev\branches\v20\SFTPDrive\tests")