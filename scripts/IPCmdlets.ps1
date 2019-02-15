<#
  .SYNOPSIS
  .DESCRIPTION
  .PARAMETER 
  .INPUTS
  .OUTPUTS
  .EXAMPLE
  .EXAMPLE
  .EXAMPLE
  .NOTES
    https://www.google.com/maps/place/35%C2%B054'40.3%22N+78%C2%B055'04.1%22W/@35.9092329,-78.9330754,13.92z/data=!4m5!3m4!1s0x0:0x0!8m2!3d35.9112!4d-78.9178
	
#>
function global:Convert-Degree {
	[CmdletBinding()]
	param (
	  [decimal] $lat,
	  [decimal] $lon,
	  [switch] $google
	)  
	begin {
	}
	process { 
		$latdegrees = [math]::floor($lat)
		$latminutes = ($lat - $latdegrees) * 60
		$latseconds = [math]::round(($latminutes - [math]::floor($latminutes)) * 60,1)
		
		$londegrees = [math]::floor([math]::abs($lon))
		$lonminutes = ([math]::abs($lon) - $londegrees) * 60
		$lonseconds = [math]::round(($lonminutes - [math]::floor($lonminutes)) * 60, 1)
		
		#exact google form. do not touch
		if ($google) { start "https://www.google.com/maps/place/$latdegrees$([char]176)$([math]::floor($latminutes))`'$latseconds`"N+$londegrees$([char]176)$([math]::floor($lonminutes))`'$lonseconds`"W" }
		log "$latdegrees$([char]176)$([math]::floor($latminutes))```'$latseconds```"N+$londegrees$([char]176)$([math]::floor($lonminutes))```'$lonseconds```"W" $false $true
		}
	end {
	}
}
<#
  .SYNOPSIS
    Gets location information about an IP Address
  .DESCRIPTION
    Uses the ipapi to get location information
  .PARAMETER ip
    The ip address
  .EXAMPLE
		Get-IPLocation "25.77.74.11"
  .NOTES
    Author: Reese Krome
		1/19/2019
#>
function global:Get-IPLocation {
    [CmdletBinding()]
    param (
		[Parameter(ValueFromPipeline)]
		[string] $ip
		 )  
    begin {
    
    }
    process { 
        $myparameters=@{ uri="https://ipapi.co/$ip/json/ "}
    
        $Response = (Invoke-WebRequest @myparameters -UseBasicParsing).Content | ConvertFrom-Json
		
		$locationobj = @{
			"ADDRESS" = "$($Response.ip)";
			"LATLON" = "$($Response.latitude) $($Response.longitude)";
			"CITY" = "$($Response.city)";
			"REGION" = "$($Response.region)";
			"POSTAL" = "$($Response.postal)";
			"COUNTRY" = "$($Response.country_name)";
			"CURRENCY" = "$($Response.currecny)";
		}
    }
    end {
		Set-Clipboard -Value $locationobj.LATLON
		return $locationobj
    }
}
