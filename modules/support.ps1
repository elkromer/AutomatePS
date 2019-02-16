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
	abc065da
	4900d99da86add0fac5b9bcfe6cb6352
    Author: Reese Krome
	1/19/2019
#>
function global:Thesaur-Ox {
    [CmdletBinding()]
    param (
        [string] $Word,
        [switch] $p = $false,
		[string] $app_id = "",
		[string] $app_key = ""
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
		if ($_.Exception.Message.ToLower() -like '*forbidden*') {
			Status "You must either hardcode credentials or pass them to the cmdlet to use this API. " "WebException" "Red"
		} else { 
			Status "Web request failed. $($_.Exception.Message)" "WebException" "Red"
		}
	} catch [Exception] {
		Status "An unknown exception occured." "Exception" "Red"
	}
}