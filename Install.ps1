#   Adobe Create Cloud Upgrade Script for Print and Copy Centers
#   Created on January 31, 2017 by David Doyle
#   

# Change $ProductName to reflect current version of CC.  Make sure that the folder and filenames match.
$ProductName = "Adobe Design Standard 2017 PCC"
$LOG_DIR = "C:\FLOGS\Adobe\$ProductName"
$ScriptLOG = "\_validateInst.log"
$InstallLOG = "$LOG_DIR\Install.log"

# Create log folder
   New-Item -ItemType Directory -Force -Path $LOG_DIR | Out-Null

# Check for Photoshop version to determine if (un)install is necessary
function CheckVersion {
    $computername = ($env:computername).ToUpper()
    $APV = Get-WmiObject -Namespace "root\cimv2\sms" -Query "SELECT * FROM SMS_InstalledSoftware" | Where-Object ARPDisplayName -Like "Adobe Photoshop*" | Select-Object -ExpandProperty ProductVersion
    If ($APV -eq $null)
        {
            InstallSoftware
            Exit
        }
    else {
        $APV = $APV.ToString().Substring(0,2)
    }
    If ($APV -eq "18")
        { 
        Write-host "`nThe latest verion is already installed. Window closing." -ForegroundColor Red
        Read-Host "`nPress Enter to quit"
        exit
        }
    elseif ($APV -ge "1" -and $APV -le "17") 
        {
        Write-Host "`nFound Photoshop Version $APV" -ForegroundColor Yellow
        UninstallSoftware
        }
    Else
        {
        Write-Host "`nPhotoshop not Found." -ForegroundColor Yellow
        InstallSoftware
        }
}

# Uninstall the current version of Adobe CC
function UninstallSoftware {
    Write-Host "`nUninstalling old version of Adobe Creative Cloud...please be patient!" -ForegroundColor Green
    try {
        Start-Process ".\Adobe Uninstaller\Uninstaller\AdobeCCUninstaller.exe" -Verb runAs -Wait -ErrorAction Stop
        # $TempPath = Get-ChildItem -Path Env:TEMP | Select-Object value | Format-Table -HideTableHeaders
        $Result = "$LOG_DIR\AdobeCCUninstaller.log"
        "$(Get-Date) Adobe CC Photoshop Version $APV uninstalled." | Out-File $Result -Append
        Write-Host "`nUninstall successful." -ForegroundColor Green
        InstallSoftware
        }
    catch {
        Write-Host "There was an error while uninstalling. Stopping.  Please contact support." -ForegroundColor Red
        Read-Host "Please press Enter to exit"
        Exit
    }
}

# Install current version of Creative Cloud
function InstallSoftware {
    $CurrentPath = (Get-Item -Path ".\" -Verbose).FullName
    $InstallCMD = "$CurrentPath\$ProductName\Build\$ProductName.msi"
    Write-Host $InstallCMD
   $MSIArguments = @(
       "/i `"$InstallCMD`""
       "/qb"
  #     "/lv*+ $InstallLOG"
   )
    Write-Host "`nInstalling $ProductName...please wait." -ForegroundColor Green
    try {
       $EC = (Start-Process MSIEXEC.EXE -ArgumentList $MSIArguments -Verb runAs -Wait).ExitCode
        "`n$(Get-Date) Installing $ProductName." | Out-File -FilePath $LOG_DIR$ScriptLOG -Append
        "`n$(Get-Date) $InstallCMD" | Out-File -FilePath $LOG_DIR$ScriptLOG -Append
        If ($EC -eq $null)
            {
                "`n$(Get-Date) Install Successful" | Out-File -FilePath $LOG_DIR$ScriptLOG -Append
            }
        else {
                    "`n$(Get-Date) Install finished with exitcode $EC" | Out-File -FilePath $LOG_DIR$ScriptLOG -Append
                    Write-Host "`nInstall finished with exitcode $EC"
        }
               
    }
    catch {
        Write-Host "There was an error while installing. Error code:$EC"
    }
}
CheckVersion
#UninstallSoftware