#   Adobe Create Cloud 2017 Upgrade Script for Print and Copy Centers
#   Created on January 31, 2017 by David Doyle
#   

$LOG_DIR = "C:\FLOGS\Adobe\Design_Standard_CC_x64\2017"
$ProductName = "Adobe Design Standard 2017 PCC"

# Create log folder
   New-Item -ItemType Directory -Force -Path $LOG_DIR

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
        $Result = Select-String -Path $LOG_DIR"\AdobeCCUninstaller.log"
        InstallSoftware
        }
    catch {
        
    }
    
function InstallSoftware()
    $InstallCMD = ".\"$ProductName"\Build\"$ProductName".msi"
    Write-Host "`nInstalling Adobe Creative Cloud 2017...please wait." -ForegroundColor Green
    try {
        Start-Process "MSIEXEC.EXE /QB! /I "$InstallCMD" /LV*+! "$LOG_DIR""$ProductName"_Inst.log" -Verb runAs -Wait -ErrorAction SilentlyContinue
    }

CheckVersion