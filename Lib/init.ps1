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