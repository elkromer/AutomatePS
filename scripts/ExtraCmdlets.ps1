<#
  .SYNOPSIS
    Gets the most significant earthquakes of the past month
  .DESCRIPTION
    Uses the USGS Earthquake Explorer ATOM Syndication API to display the most significant earthquakes of the past month.
  .EXAMPLE
	  Get-SignificantQuakes
  .NOTES
	No credentials needed!
  
    Author: Reese Krome 
	1/19/2019
#>
function global:Get-SignificantQuakes {
	$myparameters=@{ uri="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.atom"}
	$response = (Invoke-WebRequest @myparameters -UseBasicParsing).Content | ConvertTo-XML # Creates an object we can parse
	$ob = ($response.Objects.Object."`#text") # Special naming conventions for a level of the response
	
	$xml=[xml]$ob # Creates an object we can parse
	$xml.feed.entry | % {
		Log "[$($_.updated)] " $true $true -Color "Green"
		Log "$($_.title) " $true $true -Color "Green"
		$depth = ($_.elev/100).ToString() + " km"
		Log "Elev $depth " $true $true -Color "Green"
		Log "<$($_.point)>" $false $true
	}
}
<#
  .SYNOPSIS
    All earthquakes of the past month
  .DESCRIPTION
    Uses the USGS Earthquake Explorer ATOM Syndication API to display all earthquakes in the past month.
  .EXAMPLE
	  Get-MonthlyQuakes
  .NOTES
    Author: Reese Krome 
	1/19/2019
#>
function global:Get-MonthlyQuakes {
    [CmdletBinding()]
    param (
    )  
    begin {
    
    }
    process { 
        $myparameters=@{ uri="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_month.atom"}
    
        $response = (Invoke-WebRequest @myparameters -UseBasicParsing).Content | Convertto-xml # Creates an object we can parse
				
				$ob = ($response.Objects.Object."`#text") # Special naming conventions for a level of the response

				$xml=[xml]$ob # Creates an object we can parse

				$xml.feed.entry | % {
					Log "[$($_.updated)] " $true $true -Color "Blue"
					Log "$($_.title) " $true $true -Color "Green"
					$depth = ($_.elev/100).ToString() + " km"
					Log "Elev $depth " $true $true -Color "Red"
					Log "<$($_.point)>" $false $true
				}
    }
    end {
    }
}
<#
  .SYNOPSIS
    All earthquakes in the past hour
  .DESCRIPTION
    Uses the USGS Earthquake Explorer ATOM Syndication API to display all earthquakes in the past hour.
  .EXAMPLE
	  Get-HourlyQuakes
  .NOTES
    Author: Reese Krome 
	1/19/2019
#>
function global:Get-HourlyQuakes {
    [CmdletBinding()]
    param (
    )  
    begin {
    
    }
    process { 
        $myparameters=@{ uri="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_hour.atom"}
    
        $response = (Invoke-WebRequest @myparameters -UseBasicParsing).Content | Convertto-xml # Creates an object we can parse
		
		$ob = ($response.Objects.Object."`#text") # Special naming conventions for a level of the response

		$xml=[xml]$ob # Creates an object we can parse

		$xml.feed.entry | % {
			Log "[$($_.updated)] " $true $true -Color "Blue"
			Log "$($_.title) " $true $true -Color "Green"
			$depth = ($_.elev/100).ToString() + " km"
			Log "Elev $depth " $true $true -Color "Red"
			Log "<$($_.point)>" $false $true
		}
    }
    end {
    }
}
<#
  .SYNOPSIS
    Fetches synonyms
  .DESCRIPTION
    Uses the oxford dictionary API to fetch synonyms
  .PARAMETER Word
    The search term
  .EXAMPLE
    Thesaur-Ox "ace"
  .NOTES
	Credentials obtained from https://developer.oxforddictionaries.com/
  
    Author: Reese Krome
	1/19/2019
#>
function global:Thesaur-Ox {
    [CmdletBinding()]
    param (
        [string] $Word,
        [switch] $p = $false,
		[string] $app_id = "abc065da",
		[string] $app_key = "4900d99da86add0fac5b9bcfe6cb6352"
    )  
	$myparameters=@{ uri="https://od-api.oxforddictionaries.com/api/v1/entries/en/$Word/synonyms";
		ContentType = "application/json"}
	
	try {
		$Response = (Invoke-WebRequest @myparameters -UseBasicParsing -Headers @{ app_id=$app_id; app_key=$app_key}).Content | ConvertFrom-Json		
		
		$Response.results[0].lexicalEntries | ForEach-Object {
			$_.Entries[0].senses.synonyms | % {
				Log "$($_.Text)" $false $true -Color "Green"
			}
		}
	} catch [System.Net.WebException]{
		Status "Web request failed. $($_.Exception.Message)" "WebException" "Red"
	} catch [Exception] {
		Status "An unknown exception occured." "Exception" "Red"
	}
}
function sshh ([Parameter(ValueFromRemainingArguments=$true)][string[]] $cmd){ 
	#HOME DESKTOP
	$command = (($cmd -Join " ").replace("#", ";").replace("*", "$"))
	$resp = Invoke-SSH -Server 45.37.168.162 -User kouey -Password sfd4JK8466321 -Command $command -Force -Port 3596;
	$resp.Text 
}
function sshk ([Parameter(ValueFromRemainingArguments=$true)][string[]] $cmd){ 
	#KADEV
	$command = (($cmd -Join " ").replace("#", ";").replace("*", "$"))
	Log "Command: $command"
	$resp = Invoke-SSH -Server 10.0.1.67 -User joe -Password joe -Command $command -Force; 
	$resp.Text 
}
function sftph ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#HOME DESKTOP
	if ($args[0] -eq "get") {	
		Get-SFTP -Server 45.37.168.162 -Port 3596 -User kouey -Password sfd4JK8466321 -RemoteFile $args[1] -Localfile (".\" -Join (Split-Path $args[1] -leaf)) -Force 
	} elseif ($args[0] -eq "push") {
		Send-SFTP -Server 45.37.168.162 -Port 3596 -User kouey -Password sfd4JK8466321 -RemoteFile (".\" -Join (Split-Path $args[1] -leaf)) -LocalFile $args[1] -Force -Overwrite
	} else {
		Log "Incorrect Usage" $false $true "red"
	}
} 
function sftpk ([Parameter(ValueFromRemainingArguments=$true)][string[]] $args){
	#KADEV
	if ($args[0] -eq "get") {	
		Get-SFTP -Server 10.0.1.67 -User joe -Password joe -RemoteFile $args[1] -Localfile (".\" -Join (Split-Path $args[1] -leaf)) -Force 
	} elseif ($args[0] -eq "push") {
		Send-SFTP -Server 10.0.1.67 -User joe -Password joe -RemoteFile (".\" -Join (Split-Path $args[1] -leaf)) -LocalFile $args[1] -Force -Overwrite
	} else {
		Log "Incorrect Usage" $false $true "red"
	}
} 	