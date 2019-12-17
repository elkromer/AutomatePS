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
	  1MB = 1048576 Bytes
	  1GB = 1048576000 Bytes

    Author: Reese Krome
		1/23/2019
#>
function global:New-File {
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
function global:Log {
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
function global:Status {
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