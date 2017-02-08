#   Adobe Create Cloud 2017 Upgrade Script for Print and Copy Centers
#   Created on January 31, 2017 by David Doyle
#   


function CheckVersion() 
    $computername = ($env:computername).ToUpper()
    $APV = Get-WmiObject -Name $computername -Namespace "root\cimv2\sms" -Query "SELECT * FROM SMS_InstalledSoftware" | Where-Object ARPDisplayName -Like "Adobe Photoshop*" | Select-Object -ExpandProperty ProductVersion
    $APV = $APV.ToString().Substring(0,2)
    If ($APV -eq "18")
        { 
        Write-host "`nThe latest verion is already installed. Window closing." -ForegroundColor Yellow
        Read-Host "`nPress Enter to quit" -ForegroundColor Yellow
        exit
        }
    elseif ($APV -ge "1" -and -le "17") 
        {
        UninstallSoftware
        }
    Else
        {
        InstallSoftware
        }

function UninstallSoftware()
    Write-Host "`nUninstalling old version of Adobe Creative Cloud...please be patient!" -ForegroundColor Green
    try {
        Start-Process ".\Uninstaller\AdobeCCUninstaller.exe" -Verb runAs -Wait -ErrorAction SilentlyContinue
        $TempPath = Get-ChildItem -Path Env:TEMP | Select-Object value | Format-Table -HideTableHeaders
        $Result = Select-String -Path $TempPath"\AdobeCCUninstaller.log"
        InstallSoftware
        }
    catch {
        
    }
    
function InstallSoftware()
    Write-Host "`nInstalling Adobe Creative Cloud 2017...please wait." -ForegroundColor Green
    try {
        Start-Process ".\Installer\AdobeDesignStandard2017PCC\Build\Setup.exe" -Verb runAs -Wait -ErrorAction SilentlyContinue
    }

CheckVersion