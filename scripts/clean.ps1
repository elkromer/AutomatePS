#Requires -RunAsAdministrator
param (

)
function Clean-Path {
    param (
    [string] $basepath,
    [switch] $verbose
    )
    Push-Location $basepath
    $sum = Get-Sum
    Log "Removing $($sum/1000) KB from $basepath" $false $true
    Clean
    Pop-Location
}
function Get-Sum {
    param(

    )
    $sum = 0
    Get-ChildItem | % {
        $sum += $_.Length
    }
    return $sum
}
function Clean {
    param (

    )
    $sum = 0
    Get-ChildItem | % {
        try { Remove-Item $_ -Recurse -Force -ErrorAction Stop }
        catch  { WriteWarning -Message "Failed to remove file." -Color "Yellow" }
    }
}
function WriteWarning {
    param (
        [string] $warning,
        [string] $message,
        [string] $color
    )
    Log "[" $true $true
    Log "Warning" $true $true -Color $color
    Log "] " $true $true
    Log $message $false $true 
}

$systemp = "C:\Windows\Temp"
$usrtemp = "C:\Users\$env:UserName\AppData\Local\Temp"

Clean-Path $systemp
Clean-Path $usrtemp




