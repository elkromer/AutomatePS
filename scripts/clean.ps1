#Requires -RunAsAdministrator
param (
    [string] $basepath = ""
)
function Clean-Path {
    param (
    [string] $basepath,
    [switch] $verbose
    )
    Push-Location $basepath
    $sum = Get-Sum
    Log "Removing $($sum/1000) KB from $basepath" $false $true
    $actual = Clean
    Status -Warning "OK" -Message "Removed $($actual/1000) kB from $basepath" -Color "Green"
    Pop-Location
}
function Get-Sum {
    $sum = 0
    Get-ChildItem | % {
        $sum += $_.Length
    }
    return $sum
}
function Clean {
    $sum = 0
    Get-ChildItem | % {
        try { 
            Remove-Item $_ -Recurse -Force -ErrorAction Stop;
            $sum += $_.Length
        }
        catch  { Status "File in use." "Warning" -Color "Yellow" }
    }
    return $sum
}

$systemp = "C:\Windows\Temp"
$usrtemp = "C:\Users\$env:UserName\AppData\Local\Temp"

if ($basepath) {
    Clean-Path $basepath
} else {
    Clean-Path $systemp
    Clean-Path $usrtemp
}