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
    Most significant earthquakes of the past month
  .DESCRIPTION
    Uses the USGS Earthquake Explorer ATOM Syndication API to display the most significant earthquakes of the past month.
  .EXAMPLE
	  Get-SignificantQuakes
  .NOTES
    Author: Reese Krome 
	1/19/2019
#>
function global:Get-SignificantQuakes {
    [CmdletBinding()]
    param (
    )  
    begin {
    }
    process { 
        $myparameters=@{ uri="https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/significant_month.atom"}
    
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
    Author: Reese Krome
	1/19/2019
#>
function global:Thesaur-Ox {
    [CmdletBinding()]
    param (
        [string] $Word,
        [switch] $p = $false
    )  
    begin {
    
    }
    process { 
        $myparameters=@{ uri="https://od-api.oxforddictionaries.com/api/v1/entries/en/$Word/synonyms";
            ContentType = "application/json"}
    
        $Response = (Invoke-WebRequest @myparameters -UseBasicParsing -Headers @{ app_id="abc065da"; app_key="4900d99da86add0fac5b9bcfe6cb6352"}).Content | ConvertFrom-Json
		
		$Response.results[0].lexicalEntries | ForEach-Object {
			$_.Entries[0].senses.synonyms | % {
				Log "$($_.Text)" $false $true -Color "Green"
			}
		}
    }
    end {
		#return $Response.results
    }
}
<#
  .SYNOPSIS
    Searches words
  .DESCRIPTION
    Uses the oxford dictionary API to search for words
  .PARAMETER Word
    The search term
  .PARAMETER p
    A switch parameter that indicates whether the search term is a prefix
  .EXAMPLE
    Search-Ox "fuc" -p
  .NOTES
    Author: Reese Krome
	1/19/2019
#>
function global:Search-Ox {
    [CmdletBinding()]
    param (
        [string] $Word,
        [switch] $p = $false
    )  
    begin {
    
    }
    process { 
        $myparameters=@{ uri="https://od-api.oxforddictionaries.com/api/v1/search/en?q=$Word&prefix=true";
            ContentType = "application/json"}
    
        $Response = (Invoke-WebRequest @myparameters -UseBasicParsing -Headers @{ app_id="abc065da"; app_key="4900d99da86add0fac5b9bcfe6cb6352"}).Content | ConvertFrom-Json
        $Response.results | % {
            Log "$($_.word)" $false  $true -Color "Green"
        }    
    }
    end {
		#return $Response.results
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
		ADD-LOG "C:\temp" "mylogfile" ".log"
	.INPUTS
		
	.OUTPUTS
		The string name of the newly created log file
		The success or failure of the cmdlet
	.LINK
		https://goo.gl/DQG6RA
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function global:ADD-LOG {
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
Returns $true if the given value is present in the script's storage, or $false
otherwise.

.EXAMPLE
if (Test-LocalStorage -Key "credential") {
    # Key present
} else {
    # Key not present
}

.NOTES
The method used for detecting the current script doesn't work from within
PSOutlook, so you'll need to explicitly pass a -Script parameter or assign
the $defaultLocalStorageScript variable.

Test-LocalStorage -Script "mytool" -Key "credential"
#>
function global:TEST-LOCALSTORAGE {
	[CmdletBinding()]
	param (
		[string] $script = $defaultLocalStorageScript,
		[Parameter(Mandatory=$true)]
		[string] $key,
		[string] $settingsDir = "$env:USERPROFILE\.psscripts"
	) 
	If (($script -eq "") -or ($key -eq "") -or ($settingsDir -eq "")) {
			Throw "Test-LocalStorage requires non-empty -Script, -Key and -SettingsDir"
	}

	$scriptPath = "$settingsDir\$script.conf"
	If (!(Test-Path $scriptPath -Type Leaf)) {
			return $false
	}

	(Import-CliXml $scriptPath).Containskey($key)
}

<#
.SYNOPSIS
Retrieves a value from the script's local storage, returning $null if none is
found.

.EXAMPLE
$cred = Get-LocalStorage -Key "credential"

.NOTES
The method used for detecting the current script doesn't work from within
PSOutlook, so you'll need to explicitly pass a -Script parameter or assign
the $defaultLocalStorageScript variable.

Get-LocalStorage -Script "mytool" -Key "credential"
#>
function global:GET-LOCALSTORAGE {
	[CmdletBinding()]
	param (
    [string] $script = $defaultLocalStorageScript,
    [Parameter(Mandatory=$true)]
    [string] $key,
    [string] $settingsDir = "$env:USERPROFILE\.psscripts"
	) 
    If (($script -eq "") -or ($key -eq "") -or ($settingsDir -eq "")) {
        Throw "Get-LocalStorage requires non-empty -Script, -Key and -SettingsDir"
    }

    If (!(Test-Path $settingsDir -Type Container)) {
        mkdir $settingsDir > $null
    }

    $scriptPath = "$settingsDir\$script.conf"
    if (!(Test-LocalStorage -Script $script -Key $key -SettingsDir $settingsDir)) {
        return $null;
    }

    $scriptHash = Import-CliXml $scriptPath
    If (!($scriptHash.ContainsKey($key))) {
        return $null;
    }

    return $scriptHash[$key];
}

<#
.SYNOPSIS
Puts a value into the script's local storage.

.EXAMPLE
Set-LocalStorage -Key "credential" -Value (Get-Credential)

.NOTES
The method used for detecting the current script doesn't work from within
PSOutlook, so you'll need to explicitly pass a -Script parameter or assign
the $defaultLocalStorageScript variable.

Set-LocalStorage -Script "mytool" -Key "credential" -Value (Get-Credential)
#>
function global:SET-LOCALSTORAGE {
	[CmdletBinding()]
	param (
			[string] $script = $defaultLocalStorageScript,
			[Parameter(Mandatory=$true)]
			[string] $key,
			[Parameter(Mandatory=$true)]
			[PSObject] $value,
			[string] $settingsDir = "$env:USERPROFILE\.psscripts"
	) 
	If (($script -eq "") -or ($key -eq "") -or ($settingsDir -eq "")) {
			Throw "Set-LocalStorage requires non-empty -Script, -Key and -SettingsDir"
	}

	$scriptPath = "$settingsDir\$script.conf"
	If (Test-Path $scriptPath -Type Leaf) {
			$scriptHash = Import-CliXml $scriptPath
	} Else {
			$scriptHash = @{}
	}

	If (!(Test-Path $settingsDir -Type Container)) {
			mkdir $settingsDir > $null
	}

	$scriptHash[$key] = $value
	$scriptHash | Export-CliXml $scriptPath
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
function global:LOG {
	[CmdletBinding()]
	param(
		[Parameter(Position=0)]
		$message, 
		[Parameter(Position=1)]
		[bool]$nonewline, 
		[Parameter(Position=2)]
		[bool]$continuation, 
		[Parameter(Position=3)]
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
function global:SET-SMSCREDENTIALS {
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

function global:SEND-SMS {
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
function global:MAKE-SYMLINK ($link, $target) {
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

function global:MAKE-JUNCTION ($link, $target) {
    New-Item -Path $link -ItemType Junction -Value $target
}
<#
	.SYNOPSIS
		Build visual studio project in current directory
	.DESCRIPTION
		This cmdlet uses the dev console to rebuild the visual studio project in the current directory and pushes the location to the directory with the executable
	.PARAMETER <proj>
		The project name to build
	.PARAMETER <mode>
		The mode to build. either Debug or Release
	.EXAMPLE
		Build-CS
		Build-CS myproject.csproj Release
	.NOTES
		Author: Reese Krome
		Email: reesek@cdata.com
#>
function global:BUILD-CS($proj, $mode) {
	if ($proj -eq $null -or $proj -eq "") {
		$proj = "tests.csproj"
	}
	if ($mode -eq $null -or $mode -eq "") {
		$mode = "Debug"
	}
	$mypath = (Get-Item -Path ".\").FullName
	Log "Building $proj..." $true $false
	if (test-path $proj) {
		Get-ChildItem -Path ".\bin" -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force
		#Log "`nRun-Process $vs17path $mypath\$proj /Rebuild $mode" $false $true "yellow"
		$retcode = Run-Process $vs17path "$mypath\$proj /Rebuild $mode" 
		if ($retcode) {Log "Failed!" $false $true "red"} else 
		{
			Log "OK" $false $true "green"
			Push-Location bin\$mode
		}
	} 
	else 
	{
		Log "No project file found." $false $true "Red"
	}
}