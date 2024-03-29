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
function Convert-Degree {
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
function Get-IPLocation {
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
function Thesaur-Ox {
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
		if ($_.Exception.Message.ToLower() -like '*forbidden*') {
			Status "You must either hardcode credentials or pass them to the cmdlet to use this API. " "WebException" "Red"
		} else { 
			Status "Web request failed. $($_.Exception.Message)" "WebException" "Red"
		}
	} catch [Exception] {
		Status "An unknown exception occured." "Exception" "Red"
	}
}
<#
  .SYNOPSIS
    Get a random inspirational quote
  .DESCRIPTION
    Uses the forismatic api to find a random quote and log it to console output
  .EXAMPLE
	  Get-Quote
  .NOTES
    Author: Reese Krome 
	  1/27/2019
#>
function Get-Quote {
	[CmdletBinding()]
	param (
	)  
	begin {
	}
	process { 
		$rand = Get-Random -Maximum 400000;

		$myparameters=@{ uri="http://api.forismatic.com/api/1.0/?method=getQuote&key=$rand&format=json&lang=en"}

		$response = (Invoke-WebRequest @myparameters -UseBasicParsing).Content | Convertto-xml # Creates an object we can parse

		$resp = ConvertFrom-JSON $response.Objects.Object.'#text'
		Log "$($resp.'quoteText')" $true $true -Color "Green"
		Log "~$($resp.'quoteAuthor')" $false $true -Color "Green"
	}
	end {
	}
}
<#
  .SYNOPSIS
	  Creates an empty file of a given size
  .DESCRIPTION
	  Uses the System.IO.FileStream library to create a new file of a specified size
  .PARAMETER Size
	  Size of file in bytes
  .PARAMETER FileName
	  Absolute path to file
  .EXAMPLE
	  New-File 1048576 "test.txt" 
  .NOTES
	  1MB = 1048576 Bytes
	  1GB = 1048576000 Bytes

    Author: Reese Krome
		1/23/2019
#>
function New-File {
	[CmdletBinding()]
	param (
		[int64] $Size,
		[string] $FileName
	)
	begin {
	
	}
	process {
		"Creating new file of size $Size B"
		$f = [io.file]::Create($FileName)
		$f.SetLength($Size)
	}
	end {
		$f.Close()
	}
}
<#
	.SYNOPSIS
		Create new log file
	.DESCRIPTION
		This cmdlet creates a new log file in a specific location with a specified extension and preface. Accepts pipeline input.
	.PARAMETER <Folder>
		Location to store the new log file
	.PARAMETER <Preface>
		Preceding name of the log file
	.PARAMETER <Extension>
		File extension of the log file
	.EXAMPLE
		Add-Log "C:\temp" "mylogfile" ".log"
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function Add-Log {
	[CmdletBinding(
		DefaultParameterSetName="Preface",
		SupportsShouldProcess=$True
	)]
	param(
		[string] $Folder="C:\temp",
		[string] $Preface="Logfile",
		[string] $Extension=".log"
	)
	begin { # static variables that never change, runs once for each instance of cmdlet

	}
	process { # executes once for each piped input
		$Today = Get-Date
		$Date=$today.toshortdatestring().Replace("/","")
		$Time=$Today.tostring("HH:mm:ss").Replace(":","")
		$Logfilename=$Folder+"\"+$Preface+"-"+$Date+"-"+$Time+$Extension
		if (TEST-PATH -path $Logfilename)
		{ 
			WRITE-ERROR "Error: $Logfilename exists."
			RETURN $Logfilename,$FALSE 
		} ELSE {
			NEW-ITEM -Type File -Path $Logfilename -Force | OUT-NULL
			RETURN $Logfilename,$TRUE
		}
	}
	end { # runs once for each instance of cmdlet

	}
}
<#
	.SYNOPSIS
		Prints the message.
	.DESCRIPTION
		Prints with Write-Host with the specified settings.
	.PARAMETER Message
		The string message or object to write. 
	.PARAMETER NoNewline
		A boolean to signal whether to print new lines before or after the message. 
	.PARAMETER Continuation
		A boolean to indicate the current message is a continuation of an existing line.
	.PARAMETER Color
		A string color to print	
	.EXAMPLE
		Log $message [nonewline bool] [continuation bool] [color string]
		Log -Message "Hello World"
		Log -Message "Uploading ... " $true
		Log "OK" $false $true -Color "Green"

	.NOTES
		If the message is a continuation of a previous call to 'Log', set the continuation parameter to withhold the date
#>
function Log {
	[CmdletBinding()]
	param(
		[Parameter(ValueFromPipeline)]
		$message, 
		[bool] $nonewline, 
		[bool] $continuation, 
		[string] $color
	) 
		process
	{
		$myDate = Get-Date -Format "[MM/dd/yyyy HH:mm:ss]"

		if(!$continuation) { Write-Host "$myDate " -NoNewline}
		if($color -ne $null -and $color -ne "") {
				Write-Host "$message" -NoNewline:$nonewline -ForegroundColor $color
		} else {
				Write-Host "$message" -NoNewline:$nonewline
		}
	}
}
<#
	.SYNOPSIS
		Prints a status message using Log
	.DESCRIPTION
		Prints a status message to standard out with the specified settings.
	.PARAMETER Message
		The status message
	.PARAMETER Warning
		The short warning printed in the brackets
	.PARAMETER Color
		A string color to print the warning.
	.EXAMPLE
		Status -Warning "OK" -Message "Finished doing something" -Color "Green"
		Status -Message "File in use" -Warning "Warning" -Color "Yellow"
		Status "Finished doing something"
#>
function Status {
	[CmdletBinding()]
	param (
		[Parameter(ValueFromPipeline)]
		[string] $message,
		[string] $warning = "OK",
		[string] $color
	)
	Log "[" $true $true
	Log "$warning" $true $true -Color $color
	Log "] " $true $true
	Log "$message..." $false $true 
}
<#
	.SYNOPSIS
		Converts a username/password pair into a PS Credential object.
	.EXAMPLE
		$cred = ConvertTo-Credential -User "support@rssbus.com" -Password "p@$$w0rd"
#>
function ConvertTo-Credential(
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
function Set-SMSCredentials {
	param(
		[string] $GMail=$smsemail,
		[string] $GMailPassword=$smspass
	)
	$Script:SMSCredentials = CONVERTTO-CREDENTIAL $GMail $GMailPassword
}
<#
	.SYNOPSIS
		This script sends a text to a phone over email using credentials from local storage
	.DESCRIPTION
		This cmdlet uses the NetCmdlets module to send an email with the Gmail credentials created in the Set-SmsCredentials function. 
		A string carrier is specified to index into a dictionary of carrier endpoints used to send the email. Cell phones can receive 
		messages by sending an email to PHONENUMBER@carrier.endpoint.com. An image attachment can be specified with the -File parameter.
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
		Verizon is the default carrier. smtp.gmail.com is the default email server. Make sure when using Gmail to turn ON less secure apps. 
	
		Author: Reese
		Creation Date: 6/19/2018
#>
function Send-SMS {
	param(
		$Message = "",
		$Number = $phone,
		$File = "",
		$LogFile = "c:\sendsms.log",
		$mycreds = "",
		$Server = "smtp.gmail.com", 
		$Port = 587,
		$SSL = "explicit",
		$Timeout = 20,
		$Carrier = $phonecarrier,
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

	Log "Sending message to $Number via $@$Server`:$Port... " $true $true
	if ($File){
		send-email -Credential $SMSCredentials -server $Server -port $Port -from $smsemail -to "$Number@$($CarrierDict[$Carrier])" -Message "$Message" -SSL "$SSL" -attachment "$File" > $null
	} else {
		send-email -Credential $SMSCredentials -server $Server -port $Port -from $smsemail -to "$Number@$($CarrierDict[$Carrier])" -Message "$Message" -SSL "$SSL" -logfile $LogFile -timeout $Timeout > $null
	}
	Log "DONE" $false $false "green"
}
