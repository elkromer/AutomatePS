<#
  .SYNOPSIS
	Converts latitude and longitude in decimal form to degree-minute-second form. 
  .DESCRIPTION
	Uses a well-published method to determine degree-minute-second from decimal
  .PARAMETER lat
	latitude
  .PARAMETER lon
	longitude
  .EXAMPLE
	Convert-Degree 32.112 64.558
  .EXAMPLE
	Convert-Degree -google 32.112 64.558
  .NOTES
    Author: Reese Krome
		1/19/2019
#>
function global:Convert-Degree {
	[CmdletBinding()]
	param (
	  [decimal] $lat,
	  [decimal] $lon,
	  [switch] $google
	)  
		process 
	{ 
		$latdegrees = [math]::floor($lat)
		$latminutes = ($lat - $latdegrees) * 60
		$latseconds = [math]::round(($latminutes - [math]::floor($latminutes)) * 60,1)
		
		$londegrees = [math]::floor([math]::abs($lon))
		$lonminutes = ([math]::abs($lon) - $londegrees) * 60
		$lonseconds = [math]::round(($lonminutes - [math]::floor($lonminutes)) * 60, 1)
		
		#exact google form. do not touch
		if ($google) { start "https://www.google.com/maps/place/$latdegrees$([char]176)$([math]::floor($latminutes))`'$latseconds`"N+$londegrees$([char]176)$([math]::floor($lonminutes))`'$lonseconds`"W" }
		log "$latdegrees$([char]176)$([math]::floor($latminutes))`'$latseconds`"N $londegrees$([char]176)$([math]::floor($lonminutes))`'$lonseconds`"W" $false $true
	}
}
<#
  .SYNOPSIS
    Gets location information about an IP Address
  .DESCRIPTION
    Uses the ipapi to get location information about the ip parameter
  .PARAMETER ip
    The ip address
  .EXAMPLE
	Get-IPLocation "25.77.74.11"
	"51.23.66.32", "99.65.32.11" | Get-IPLocation
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
		process 
	{ 
        $myparameters=@{ uri="https://ipapi.co/$ip/json/ "}
        
		try {
			$Response = (Invoke-WebRequest @myparameters -UseBasicParsing -ErrorAction Stop).Content | ConvertFrom-Json
			$locationobj = @{
				"LATLON" = "$($Response.latitude) $($Response.longitude)";
				"ADDRESS" = "$($Response.ip)";
				"CITY" = "$($Response.city)";
				"REGION" = "$($Response.region)";
				"POSTAL" = "$($Response.postal)";
				"COUNTRY" = "$($Response.country_name)";
				"CURRENCY" = "$($Response.currecny)";
			}
			return $locationobj
			Set-Clipboard -Value $locationobj.LATLON
		} catch { 
			Write-Error "Web request failed: $($_.Message)"
		} 
	}
}
<#
.SYNOPSIS
	Converts a username/password pair into a PS Credential object.

.EXAMPLE
	$cred = ConvertTo-Credential -User "support@rssbus.com" -Password "p@$$w0rd"
#>
function global:CONVERTTO-CREDENTIAL(
    [Parameter(Mandatory=$true)]
    [string] $user,
    [Parameter(Mandatory=$true)]
    [string] $password
) {
    $secure = ConvertTo-SecureString -AsPlainText $password -Force
    Return New-Object System.Management.Automation.PSCredential($user, $secure)
}
<#
	.SYNOPSIS
		Sets credentials for the SEND-SMS cmdlet to local storage. 
	.DESCRIPTION
		This function uses the ConvertTo-Credential function to convert the specified GMail email and password to a PSCredential. It then sets the credential to a global variable that may be used throughout the powershell session.
	.PARAMETER <GMail>
		A GMail email account from which the SMS should be sent.
	.PARAMETER <GMailPassword>
		A plaintext GMailPassword for the specified account
	.EXAMPLE
		Set-SmsCredentials -Gmail "reesek@cdata.com" -GmailPassword "pass"
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function global:Set-SMSCredentials {
	param(
		[string] $GMail="hkrome26@gmail.com",
		[string] $GMailPassword="4P5@fpKT5r"
	)
	$Script:SMSCredentials = CONVERTTO-CREDENTIAL $GMail $GMailPassword
}
<#
	.SYNOPSIS
		This script sends a text to a phone over email using credentials from local storage
	.DESCRIPTION
		This cmdlet uses the NetCmdlets module to send an email with the Gmail credentials created in the Set-SmsCredentials function. A string carrier is specified to index into a dictionary of carrier endpoints used to send the email. Cell phones can receive messages by sending an email to PHONENUMBER@carrier.endpoint.com. An image attachment can be specified with the -File parameter.
	.PARAMETER Message
		SMS Message text
	.PARAMETER File	
		File attachment
	.PARAMETER Number
		Phone number to send to
	.PARAMETER Carrier
		Phone carrier, each has a different email endpoint
	.PARAMETER From
		Where the message should appear to originate
	.EXAMPLE
		.\send-sms -Message "test" -Number 123456789 -Carrier ATT -Server smtp.gmail.com -MyCreds $PSCredential
		.\send-sms -File c:\temp\file.png -Number 123456789 -Carrier Verizon -Server smtp.gmail.com
	.NOTES	
		Verizon is the default carrier. smtp.gmail.com is the default email server. 
	
		Author: Reese
		Creation Date: 6/19/2018
#>
function global:Send-SMS {
	#[CmdletBinding()]
	param(
		$Message = "",
		$Number = "9196217286",
		$File = "",
		$LogFile = "c:\sendsms.log",
		$mycreds = "",
		$Server = "smtp.gmail.com", 
		$Port = 587,
		$SSL = "explicit",
		$Timeout = 20,
		$Carrier = "Verizon",
		$CarrierDict = @{
			ATT = "mms.att.net";
			TMobile = "tmomail.net";
			Verizon = "vzwpix.com";
			Sprint = "pm.sprint.com";
			VirginMobile = "vmpix.com";
			Tracfone = "mmst5.tracfone.com";
			MetroPCS = "mymetropcs.com";
			BoostMobile = "myboostmobile.com";
			Cricket = "mms.cricketwireless.com";
			GoogleFi = "msg.fi.google.com";
			USCellular = "mms.uscc.net";
			Ting = "message.ting.com";
			ConsumerCellular = "mailmymobile.net";
			CSpire = "cspire1.com";
			PagePlus = "vtext.com"
		}

	)
	if (!$SMSCredentials){
			Throw "Please set your sms credentials before using this script"
	}

	Log "Sending message to $Number via $Server`:$Port... " $true $true
	if ($File){
		send-email -Credential $SMSCredentials -server $Server -port $Port -from $emailaddress -to "$Number@$($CarrierDict[$Carrier])" -Message "$Message" -SSL "$SSL" -attachment "$File" > $null
	} else {
		send-email -Credential $SMSCredentials -server $Server -port $Port -from $emailaddress -to "$Number@$($CarrierDict[$Carrier])" -Message "$Message" -SSL "$SSL" -logfile $LogFile -timeout $Timeout > $null
	}
	Log "DONE" $false $false "green"

}