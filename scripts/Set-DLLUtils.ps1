. $toolspath\common.ps1
$v10releasepath = "C:\dev\branches\v10\Release"
$v20releasepath = "C:\dev\branches\v20\Release"
$v10path = "C:\dev\branches\v10";
$v20path = "C:\dev\branches\v20";
Function Get-FileMetaData { 
  <# 
   .Synopsis 
    This function gets file metadata and returns it as a custom PS Object  
   .Description 
    This function gets file metadata using the Shell.Application object and 
    returns a custom PSObject object that can be sorted, filtered or otherwise 
    manipulated. 
   .Example 
    Get-FileMetaData -folder "e:\music" 
    Gets file metadata for all files in the e:\music directory 
   .Example 
    Get-FileMetaData -folder (gci e:\music -Recurse -Directory).FullName 
    This example uses the Get-ChildItem cmdlet to do a recursive lookup of  
    all directories in the e:\music folder and then it goes through and gets 
    all of the file metada for all the files in the directories and in the  
    subdirectories.   
   .Example 
    Get-FileMetaData -folder "c:\fso","E:\music\Big Boi" 
    Gets file metadata from files in both the c:\fso directory and the 
    e:\music\big boi directory. 
   .Example 
    $meta = Get-FileMetaData -folder "E:\music" 
    This example gets file metadata from all files in the root of the 
    e:\music directory and stores the returned custom objects in a $meta  
    variable for later processing and manipulation. 
   .Parameter Folder 
    The folder that is parsed for files  
   .Notes 
    NAME:  Get-FileMetaData 
    AUTHOR: ed wilson, msft 
    LASTEDIT: 01/24/2014 14:08:24 
    KEYWORDS: Storage, Files, Metadata 
    HSG: HSG-2-5-14 
   .Link 
     Http://www.ScriptingGuys.com 
 #Requires -Version 2.0 
 #> 
 Param([string[]]$folder) 
 foreach($sFolder in $folder) 
  { 
   $a = 0 
   $objShell = New-Object -ComObject Shell.Application 
   $objFolder = $objShell.namespace($sFolder) 
 
   foreach ($File in $objFolder.items()) 
    {  
     $FileMetaData = New-Object PSOBJECT 
      for ($a ; $a  -le 266; $a++) 
       {  
         if($objFolder.getDetailsOf($File, $a)) 
           { 
             $hash += @{$($objFolder.getDetailsOf($objFolder.items, $a))  = 
                   $($objFolder.getDetailsOf($File, $a)) } 
            $FileMetaData | Add-Member $hash 
            $hash.clear()  
           } #end if 
       } #end for  
     $a=0 
     $FileMetaData 
    } #end foreach $file 
  } #end foreach $sfolder 
} 
# gets the last modified time of the DLLs in the release folder
function Get-DLLModifiedTime ([string] $query) {
	
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
function Get-DLLBuildNumbers ([string] $query) {
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
# gets the last modified time of the DLLs in the release folder
function Get-DLLModifiedTime ([string] $query) {
	
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