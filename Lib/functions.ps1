<#
	.DESCRIPTION
		Alias functions that are not typically used from the command line. 
#>
function rdp ([string] $domain) { 
	mstsc /v:$domain
}
function Do-ThesaurusLookup ([string] $query) {
	Thesaur-Ox $query
}
function Do-OpenProfile {
	notepad $prof
}
function Copy-PSWindow {
	Start-Process powershell -ArgumentList "-NoExit cd $($(Get-Location).Path)"
}
function Get-VMIPAddresses(){
  Invoke-Command -ScriptBlock {.\get-vmipaddresses.ps1} -ComputerName 10.0.1.177 -Credential $JokerCredential
}
function Get-DLLs() {
	Push-Location $tools
	. ./updatedlls.ps1
	. ./updatecppdlls.ps1
	. ./updatecpptestdlls.ps1
	Pop-Location
}
function Do-SendSMS ([string] $msg) { 
	Set-SMSCredentials; 
	Send-SMS $msg;
}
function Clear-Containers(){ 
	docker rmi $(docker images -q) 
}
function Remove-Containers(){ 
	docker rm $(docker ps -aq) 
}
function Stop-Containers(){ 
	docker stop $(docker ps -aq) 
}

function Convert-b64([string] $message) {
	$Bytes = ([System.Text.Encoding]::Unicode.GetBytes($message))
	return [Convert]::ToBase64String($Bytes)
}
function ConvertFrom-b64([string] $message) {
	return [System.Text.Encoding]::Unicode.GetString([System.Convert]::FromBase64String($message))
}
function Get-TestMaps() {
	# For Debugging Purposes
	Log "=== V10 ===" $false $true
	Log $v10NameMap.Keys $false $true
	Log "=== V20 ===" $false $true
	Log $v20NameMap.Keys $false $true
}
function Find-SKU ([string] $prod) {
	try {
		$testpath = $v10NameMap.$prod 
		if (!($testpath)) { $testpath = $v20NameMap.$prod   }
		$parentpath = $testpath | Split-Path -Parent
		$prodsgm = Join-Path $parentpath "prod.sgm"
		Log "$(Get-Content $prodsgm | Select-String -Pattern 'partpref')" $false $true
	} catch {
		Status "Product not found in v10 or v20" "Fail" "Red"
	}
}
function Do-TclSearch([string] $path, [string] $glob) {
	Push-Location $mod/scripts
	tcl search.tcl $path $glob
	Pop-Location
}
function Open-Bugz($number){
  $url = "https://b.cdata.com/bugz-ns/show_bug.cgi?id=$number"
  if ($number -lt 20000 -AND $number -gt 600){
    Start-Process "firefox.exe" $url
  }
}
function Get-NodeId {
  Start-Process -filepath "$tools\nodeid.exe" -ArgumentList "/s"
  Get-Clipboard
}
function Get-SupportInfo([string] $query) {
	$query = $query.Replace('"', '\"').Replace(' ', '+')
	$mailurl = "https://mail.google.com/mail/u/2/?pli=1#search/$query "
	$bugzurl = "https://b.cdata.com/bugz-ns/buglist.cgi?quicksearch=ALL+$query "
	$kburl = "https://www.nsoftware.com/kb/?text=$query"
	$url = $mailurl + $bugzurl + $kburl
	Start-Process -FilePath $mozillapath -ArgumentList $url
}
function Search-Bugz([string] $query) {
	$query = $query.Replace('"', '\"').Replace(' ', '+')
	$bugzurl = "https://b.cdata.com/bugz-ns/buglist.cgi?quicksearch=$query&order=bug_id+DESC"
	Start-Process -FilePath $mozillapath -ArgumentList $bugzurl
}
function Get-DockerTags($repo) {
	$separator = $repo.IndexOf("/")
	$account = $repo.Substring(0, $separator)
	$reponame = $repo.Substring($separator + 1, $repo.Length - $account.Length -1)
	$request = Invoke-RestMethod "https://registry.hub.docker.com/v2/repositories/$account/$reponame/tags/"
	$request.results | ForEach-Object {
		$_.name
	}
}
function Get-DLLBuildNumbers ([string] $query) {
	# Gets the build number of the DLL in the release folder
	$v10productNames = $v10products.net
	$v20productNames = $v20products.net

	$v10dllpaths = @{}
	$v20dllpaths = @{}

	Foreach ($product in $v10productNames) {
		if ($query){
			if ($product -like $query) { $v10dllpaths.Add($product, (Join-Path $v10releasepath "$product\kits\cs\lib")) }
			else { continue }
		} else {
			$v10dllpaths.Add($product, (Join-Path $v10releasepath "$product\kits\cs\lib"))
		}
	}
	Foreach ($product in $v20productNames) {
		if ($query){
			if ($product -like $query) { $v20dllpaths.Add($product, (Join-Path $v20releasepath "$product\kits\cs\lib")) }
			else { continue }
		} else {
			$v20dllpaths.Add($product, (Join-Path $v20releasepath "$product\kits\cs\lib"))
		}
	}

	Foreach ($key in $v10dllpaths.KEYS) {
		(Get-FileMetaData -folder $v10dllpaths.$key) | ForEach-Object {
			if ($_.Name -like "*$key.dll"){
				Log "v10 $($_.Name) " $true $true
				Log "[$($_."File version")]" $false $true "Green"
			}
		}
	}
	Foreach ($key in $v20dllpaths.KEYS) {
		(Get-FileMetaData -folder $v20dllpaths.$key) | ForEach-Object {
			if ($_.Name -like "*$key.dll"){
				Log "v20 $($_.Name) " $true $true
				Log "[$($_."File version")]" $false $true "Green"
			}
		}
	}
}
function Get-DLLModifiedTime ([string] $query) {
	# gets the last modified time of the DLLs in the release folder

	$v10productNames = $v10products.net
	$v20productNames = $v20products.net

	$v10dllpaths = @{}
	$v20dllpaths = @{}

	Foreach ($product in $v10productNames) {
		if ($query){
			if ($product -like $query) { $v10dllpaths.Add($product, (Join-Path $v10releasepath "$product\kits\cs\lib")) }
			else { continue }
		} else {
			$v10dllpaths.Add($product, (Join-Path $v10releasepath "$product\kits\cs\lib"))
		}
	}
	Foreach ($product in $v20productNames) {
		if ($query){
			if ($product -like $query) { $v20dllpaths.Add($product, (Join-Path $v20releasepath "$product\kits\cs\lib")) }
			else { continue }
		} else {
			$v20dllpaths.Add($product, (Join-Path $v20releasepath "$product\kits\cs\lib"))
		}
	}

	Foreach ($key in $v10dllpaths.KEYS) {
		(Get-FileMetaData -folder $v10dllpaths.$key) | ForEach-Object {
			if ($_.Name -like "*$key.dll"){
				Log "v10 $($_.Name) " $true $true
				Log "[$($_."Date modified")]" $false $true "Green"
			}
		}
	}
	Foreach ($key in $v20dllpaths.KEYS) {
		(Get-FileMetaData -folder $v20dllpaths.$key) | ForEach-Object {
			if ($_.Name -like "*$key.dll"){
				Log "v20 $($_.Name) " $true $true
				Log "[$($_."Date modified")]" $false $true "Green"
			}
		}
	}
}
function Get-CodeModifiedTime([string] $query, [string] $version) {
	if ($query -like "sftpdrive"){
		# This will break eventually
		Push-Location "$v20/SFTPDrive"
		if (Test-Path "src") {
			svn log -v --limit 3 $v20/SFTPDrive/src | select-string -pattern "r[0-9]* \|" 
		} else {
			Status "Did not find sftpdrive source" "FAIL" "RED"
		}
		Pop-Location
		return
	}

	if ($version -eq "v10") {
		Push-Location "$v10\code"
		if (Test-Path $query) {
			svn log -v --limit 3 $query | select-string -pattern "r[0-9]* \|"
		} else {
			Status "Could not find $query in $v10releasepath" "FAIL" "RED"
		}
		Pop-Location
	} elseif ($version -eq "v20") {
		Push-Location "$v20\code"
		if (Test-Path $query) {
			svn log -v --limit 3 $query | select-string -pattern "r[0-9]* \|" 
		} else {
			Status "Could not find $query in $v20releasepath" "FAIL" "RED"
		}
		Pop-Location
	} else {
		Log "========== v10 ==========" $false $true
		Push-Location "$v10\code"
		if (Test-Path $query) {
			svn log -v --limit 3 $query | select-string -pattern "r[0-9]* \|"
		} else {
			Status "Could not find $query in $v10releasepath" "FAIL" "RED"
		}
		Pop-Location
		Log "========== v20 ==========" $false $true
		Push-Location "$v20\code"
		if (Test-Path $query) {
			svn log -v --limit 3 $query | select-string -pattern "r[0-9]* \|" 
		} else {
			Status "Could not find $query in $v20releasepath" "FAIL" "RED"
		}
		Pop-Location

	}
}
function Get-SVNLog([string] $query, [string] $version) {
	if ($version -eq "v10") {
		Push-Location "$v10\code"
		if (Test-Path $query) {
			TortoiseProc.exe /command:log /path:$query /closeonend:0
		} else {
			Status "Could not find $query in $v10releasepath" "FAIL" "RED"
		}
		Pop-Location
	} elseif ($version -eq "v20") {
		Push-Location "$v20\code"
		if (Test-Path $query) {
			TortoiseProc.exe /command:log /path:$query /closeonend:0
		} else {
			Status "Could not find $query in $v20releasepath" "FAIL" "RED"
		}
		Pop-Location
	} else {
		if ($query -like "sftpdrive"){
			# This will break eventually
			Push-Location "$v20"
			if (Test-Path "SFTPDrive") {
				TortoiseProc.exe /command:log /path:"SFTPDrive" /closeonend:0
			} else {
				Status "Did not find sftpdrive" "FAIL" "RED"
			}
			Pop-Location
		} else {
			Push-Location "$v10\code"
			if (Test-Path $query) {
				TortoiseProc.exe /command:log /path:$query /closeonend:0
			} else {
				Status "Could not find $query in $v10releasepath" "FAIL" "RED"
			}
			Pop-Location
			Push-Location "$v20\code"
			if (Test-Path $query) {
				TortoiseProc.exe /command:log /path:$query /closeonend:0
			} else {
				Status "Could not find $query in $v20releasepath" "FAIL" "RED"
			}
			Pop-Location
		}
	}
}
function Get-UserFromSID([string] $sid) {
	$objSID = New-Object System.Security.Principal.SecurityIdentifier($sid)
	$objUser = $objSID.Translate( [System.Security.Principal.NTAccount])
	$objUser.Value
}
function Get-SIDFromUser([string] $user) {
	$objUser = New-Object System.Security.Principal.NTAccount($user)
	$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
	$strSID.Value
}
<#
	.SYNOPSIS
		Makes a symbolic link to a file
	.DESCRIPTION
		Uses the New-Item cmdlet to create a new symbolic link to a file. 
	.PARAMETER <Link>
		The path of the new symbolic link to be created.
	.PARAMETER <Target>
		The path of the target of the symbolic link.
	.EXAMPLE
		Make-SymLink .\target.txt 'C:\temp\target.txt'
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function Make-Symlink ($link, $target) {
    New-Item -Path $link -ItemType SymbolicLink -Value $target
}
<#
	.SYNOPSIS
		Makes a junction to a directory
	.DESCRIPTION
		Uses the New-Item cmdlet to create a new folder juntion to a directory
	.PARAMETER <Link>
		The path of the new junction to be created
	.PARAMETER <Target>
		The path of the target directory
	.EXAMPLE
		Make-Junction .\junction 'C:\temp\junction'
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function Make-Junction ($link, $target) {
    New-Item -Path $link -ItemType Junction -Value $target
}
<# 
	.SYNOPSIS 
	This function sets a folder icon on specified folder. 
	.DESCRIPTION 
	This function sets a folder icon on specified folder. Needs the path to the icon file to be used and the path to the folder the icon is to be applied to. This function will create two files in the destination path, both set as Hidden files. DESKTOP.INI and FOLDER.ICO 
	.EXAMPLE 
	Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Users\Mark" 
	Changes the default folder icon to the custom one I donwloaded from Google Images. 
	.EXAMPLE 
	Set-FolderIcon -Icon "C:\Users\Mark\Downloads\wii_folder.ico" -Path "\\FAMILY\Media\Wii" 
	Changes the default folder icon to custom one for a UNC Path. 
	.EXAMPLE 
	Set-FolderIcon -Icon "C:\Users\Mark\Downloads\Radvisual-Holographic-Folder.ico" -Path "C:\Test" -Recurse 
	Changes the default folder icon to custom one for all folders in specified folder and that folder itself. 
	.NOTES 
	Created by Mark Ince on May 4th, 2014. Contact me at mrince@outlook.com if you have any questions. 
#> 
function Set-FolderIcon { 
    [CmdletBinding()] 
    param 
    (     
        [Parameter(Mandatory=$True, 
        Position=0)] 
        [string[]]$Icon, 
        [Parameter(Mandatory=$True, 
        Position=1)] 
        [string]$Path, 
        [Parameter(Mandatory=$False)] 
        [switch] 
        $Recurse     
    ) 
    BEGIN 
    { 
        $originallocale = $PWD 
        #Creating content of the DESKTOP.INI file. 
        $ini = '[.ShellClassInfo] 
                IconFile=folder.ico 
                IconIndex=0 
                ConfirmFileOp=0' 
        Set-Location $Path 
        Set-Location ..     
        Get-ChildItem | Where-Object {$_.FullName -eq "$Path"} | ForEach {$_.Attributes = 'Directory, System'} 
    }     
    PROCESS 
    { 
        $ini | Out-File $Path\DESKTOP.INI 
        If ($Recurse -eq $True) 
        { 
            Copy-Item -Path $Icon -Destination $Path\FOLDER.ICO     
            $recursepath = Get-ChildItem $Path -r | Where-Object {$_.Attributes -match "Directory"} 
            ForEach ($folder in $recursepath) 
            { 
                Set-FolderIcon -Icon $Icon -Path $folder.FullName 
            } 
         
        } 
        else 
        { 
            Copy-Item -Path $Icon -Destination $Path\FOLDER.ICO 
        }     
    }     
    END 
    { 
        $inifile = Get-Item $Path\DESKTOP.INI 
        $inifile.Attributes = 'Hidden' 
        $icofile = Get-Item $Path\FOLDER.ICO 
        $icofile.Attributes = 'Hidden' 
        Set-Location $originallocale         
    } 
} 
function Remove-SetIcon { 
    [CmdletBinding()] 
    param 
    (     
        [Parameter(Mandatory=$True, 
        Position=0)] 
        [string]$Path 
    ) 
    BEGIN 
    { 
        $originallocale = $PWD 
        $iconfiles = Get-ChildItem $Path -Recurse -Force | Where-Object {$_.Name -like "FOLDER.ICO"} 
        $iconfiles = $iconfiles.FullName 
        $inifiles = Get-ChildItem $Path -Recurse -Force | where-Object {$_.Name -like "DESKTOP.INI"} 
        $inifiles = $inifiles.FullName 
    } 
    PROCESS 
    { 
        Remove-Item $iconfiles -Force 
        Remove-Item $inifiles -Force 
        Set-Location $Path 
        Set-Location .. 
        Get-ChildItem | Where-Object {$_.FullName -eq "$Path"} | ForEach {$_.Attributes = 'Directory'}     
    } 
    END 
    { 
        Set-Location $originallocale 
    } 
}
function Format-GreenFolder([string]$RelativePath) {
	Set-FolderIcon -Icon "$res\folder_green.ico" -Path "$((Resolve-Path $RelativePath).Path)"
}
function Format-RedFolder([string]$RelativePath) {
	Set-FolderIcon -Icon "$res\folder_red.ico" -Path "$((Resolve-Path $RelativePath).Path)"
}
<# 
	.SYNOPSIS 
	Opens visual studio to the csproj file to the unit tests. 
	.DESCRIPTION 
	Alias functions for opening visual studio.   
#> 
function Start-Net([string] $testname, [switch] $v10, [switch] $d){
	try 
	{
		if ($d) { 
			Log "(debug)`$v10NameMap -> $($v10NameMap.KEYS)`r`n" $false $true "Yellow"
			Log "(debug)`$v20NameMap -> $($v20NameMap.KEYS)`r`n" $false $true "Yellow" 
		}
		if ($v10) { 
			if ($d) { Log "(debug) Join-Path $($v10NameMap.$testname) tests.csproj" $false $true "Yellow" }
			$fullpath = Join-Path $v10NameMap.$testname "tests.csproj"  
		}
		else { 
			if ($d) { Log "(debug) Join-Path $($v20NameMap.$testname) tests.csproj" $false $true "Yellow" }
			$fullpath = Join-Path $v20NameMap.$testname "tests.csproj" 
		}	
		devenv.exe $fullpath
	} 
	catch [System.Management.Automation.RuntimeException]
	{
		Status "There was an issue at runtime. Is the syntax correct? $($_.CategoryInfo)" "Fail" "Red"
	}
}
function Start-Cpp([string] $testname, [switch] $v10){
	try 
	{
		if ($v10) { 
			if ($d) { Log "(debug) Join-Path $($v10NameMap.$testname) tests.cpp.csproj" $false $true "Yellow" }
			$fullpath = Join-Path $v10NameMap.$testname "tests.cpp.csproj"  
		}
		else { 
			if ($d) { Log "(debug) Join-Path $($v20NameMap.$testname) tests.cpp.csproj" $false $true "Yellow" }
			$fullpath = Join-Path $v20NameMap.$testname "tests.cpp.csproj" 
		}	
		devenv.exe $fullpath
	} 
	catch [System.Management.Automation.RuntimeException]
	{
		Status "There was an issue at runtime. Is the syntax correct? $($_.CategoryInfo)" "Fail" "Red"
	}
}
function Start-CppDebug([string] $testname, [switch] $v10){
	try 
	{
		if ($v10) { 
			if ($d) { Log "(debug) Join-Path $($v10NameMap.$testname) tests-cpp.csproj" $false $true "Yellow" }
			$fullpath = Join-Path $v10NameMap.$testname "tests-cpp.csproj"  
		}
		else { 
			if ($d) { Log "(debug) Join-Path $($v20NameMap.$testname) tests-cpp.csproj" $false $true "Yellow" }
			$fullpath = Join-Path $v20NameMap.$testname "tests-cpp.csproj" 
		}	
		devenv.exe $fullpath
	} 
	catch [System.Management.Automation.RuntimeException]
	{
		Status "There was an issue at runtime. Is the syntax correct? $($_.CategoryInfo)" "Fail" "Red"
	}
}
