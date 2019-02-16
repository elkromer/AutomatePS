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