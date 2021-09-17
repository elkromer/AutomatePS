<#
SYNOPSIS 
  Sends an email with any new changes over the last day
#>

param(
    [string] $prod,
    [string] $version = "v20",
    [string] $company = "nsoftware",
    [switch] $ui,
    [string[]] $include = @("SFTPDrive", "AESDrive", "SFTPDrive", "SFTPDrive20", "SFTPServer", "PowerShellServer"),
    [int] $days = -3
)

$nsoftwaredev = "C:\dev\branches"
$callbackdev = "C:\dev\CBT"

$today = "{0:yyyy-MM-dd}" -f (get-date)
$yesterday = "{0:yyyy-MM-dd}" -f (get-date).AddDays($days)

if ($company -eq "nsoftware") {
  $dev = $nsoftwaredev
} elseif ($company -eq "callback") {
  $dev = $callbackdev
}

Push-Location $dev\$version
if ($ui) {
    $include | ForEach-Object {
        Push-Location $_
        Start-Process TortoiseProc.exe -ArgumentList "/command:log", "/path:.", "/datemin:{$yesterday}", "/datemax={$today}"
        Pop-Location
    }
} else {
    # Figure out the changes to prod over the past day
    $content = svn log -v -r "{$yesterday}:{$today}" $prod
    $lines = $content | select-string -pattern "r\d\d\d\d\d\d"
    $lines
    # Add the revision numbers to a collection
    foreach ($match in $lines.Matches) {
        $revisionno = $match.Value.Substring(1)
        $revision = svn log -v -r $revisionno $prod
        "Revision: $revision"
        $changedFiles = $revision | select-string -pattern "   \w \S+"
        "Changed Files: $changedFiles"
        Log "revisionno = $revisionno"
        $file = Set-Content -Path C:\temp\temp.out -Value (svn log -v -r "$revisionno" $prod)
        foreach ($change in $changedFiles.Matches) {
          $changeFile = $change.Value.Substring(5)
          $changeFilePath = "/dev/$changeFile"
          $file = Add-Content -Path C:\temp\temp.out -Value (svn diff -c $revisionno $changedFilePath) 
        }
        Send-Email -server smtp.gmail.com -Port 587 -SSL automatic -User "hkrome26@gmail.com" -Password "4P5@fpKT5r" -From SVNChk -To "reesek@nsoftware.com" -Subject "Product Changed [$prod]" -Message (Get-Content -Path C:\temp\temp.out -Raw)
    }

    # Send details about each one to an email address
}
Pop-Location

