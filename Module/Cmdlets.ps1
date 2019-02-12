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
function global:Get-Quote {
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
	  1MB = 1,048,576 Bytes
	  1GB = 1,048,576,000 Bytes

    Author: Reese Krome
		1/23/2019
#>
function global:New-File {
	[CmdletBinding()]
	param (
		[int] $Size,
		[string] $FileName
	)
	begin {
	
	}
	process {
		$f = New-Object System.IO.FileStream $Filename, Create, ReadWrite
		$f.SetLength($Size)
	}
	end {
		$f.Close()
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
		[string] $ip
		 )  
    begin {
    
    }
    process { 
        $myparameters=@{ uri="https://ipapi.co/$ip/json/ "}
    
        $Response = (Invoke-WebRequest @myparameters -UseBasicParsing).Content | ConvertFrom-Json
				
				Log "$($Response.ip) <$($Response.latitude,$Response.longitude)>" $false $true -Color "Green"
				Log "$($Response.city)" $false $true -Color "Green"
				Log "$($Response.region)" $false $true -Color "Green"
				Log "$($Response.postal)" $false $true -Color "Green"
				Log "$($Response.country_name) ($($Response.currency))" $false $true -Color "Green"
    }
    end {
		#return $Response.results
    }
}
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
function global:Add-Log {
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
  Prints the message to standard out.
.DESCRIPTION
	Prints to standard out with specified settings. NoNewLine specifies that no newline character should be printed after the message. Continuation specifies that no timestamp should be printed before the message. Color specifies the text color. 
.PARAMETER NoNewline
	A boolean to signal whether to print an additional new line 
.PARAMETER Continuation
	A boolean to indicate the current message is a continuation of an existing line.
.PARAMETER Color
	A string color to print	
.EXAMPLE
      Log -Message "Hello World"
      Log -Message "Uploading ... " $true
      Log -Message "OK" $false $true -Color "Green"

.NOTES
    If the message is a continuation of a previous call to 'Log', set the continuation parameter to withhold the date
#>
function global:Log {
	[CmdletBinding()]
	param(
		$message, 
		[bool]$nonewline, 
		[bool]$continuation, 
		$color
	) 
	begin{}
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
	end{}
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
	Status "Failed to open resource" "Warn" "Yellow"
.NOTES
    Does not yet take pipeline input
#>
function global:Status {
	[CmdletBinding()]
	param (
		[string] $message,
		[string] $warning = "Warning",
		[string] $color
	)
	Log "[" $true $true
	Log "$warning" $true $true -Color $color
	Log "] " $true $true
	Log "$message..." $false $true 
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
		[string] $GMail="reesek@cdata.com",
		[string] $GMailPassword="82ozriozoo"
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
		$Number = @("9196217286"),
		$File = "",
		$mycreds = "",
		$Server = "smtp.gmail.com",
		$SSL = "explicit",
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

	foreach ($num in $Number){
		Log "Sending message to $($num)... " $true $true
		if ($File){
			send-email -Credential $SMSCredentials -server $Server -from $emailaddress -to "$num@$($CarrierDict[$Carrier])" -Message "$Message" -SSL "$SSL" -attachment "$File" > $null
		} else {
			send-email -Credential $SMSCredentials -server $Server -from $emailaddress -to "$num@$($CarrierDict[$Carrier])" -Message "$Message" -SSL "$SSL" > $null
		}
		Log "DONE" $false $false "green"
	}
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
function global:Make-Symlink ($link, $target) {
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
function global:Make-Junction ($link, $target) {
    New-Item -Path $link -ItemType Junction -Value $target
}