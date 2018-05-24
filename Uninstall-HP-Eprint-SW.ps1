#$DownloadPath = 'C:\temp\HPEPrintAppSetup.exe'
$SoftwareName = 'HP ePrint SW'

#$SourceInput = 'https://github.com/DividedCode/Nable/blob/master/Software%20Resp/HPEPrintAppSetup.exe?raw=true'
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

#check installed-----------
$32bit = $null
$64bit = $null
$32bit = get-itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "HP ePrint SW"}
$64bit = get-itemproperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "HP ePrint SW"}
 
if (($32bit -eq $null) -and ($64bit -eq $null)) {
    Write-Host $SoftwareName not installed ([System.Net.DNS]::GetHostByName('').HostName)
    exit 0
} else {
    Write-Host $SoftwareName found on ([System.Net.DNS]::GetHostByName('').HostName)
}

<# #Download-----------
if (Test-Path $DownloadPath) {
    Write-Host "$DownloadPath already present"
} else {    
    Write-Host "Start downloading files"
    (New-Object System.Net.WebClient).DownloadFile($SourceInput, $DownloadPath)
} #>

Write-Host "Start uninstall"

foreach ($item in $32bit) {
    $CmdCommand = "MsiExec.exe /X" + $item.PSChildName + " /quiet"
    cmd /C $CmdCommand
}
foreach ($item in $64bit) {
    $CmdCommand = $item.UninstallString + " /quiet"
    cmd /C $CmdCommand
}

$32bit = $null
$64bit = $null
$32bit = get-itemproperty 'HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "HP ePrint SW"}
$64bit = get-itemproperty 'HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall\*' | Select-Object DisplayName, DisplayVersion, UninstallString, PSChildName | Where-Object { $_.DisplayName -match "HP ePrint SW"}
if (($32bit -eq $null) -and ($64bit -eq $null))  {
    Write-Host "HP e-Print removed sucessvol"
} else {
    Write-Host "HP e-Print uninstall failed"
    exit 1
}


                                                                                                                                                                                                                                                                                                                                              
