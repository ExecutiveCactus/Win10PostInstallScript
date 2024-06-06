
# Not gonna lie... I dont know what im doing.
# This may or may not work


# Set Execution Policy
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force

# Function to Install winget
function Install-Winget {
    if (-Not (Get-Command winget -ErrorAction SilentlyContinue)) {
        Write-Host "winget is not installed. Installing winget..."
        Start-Process -FilePath "ms-windows-store://pdp/?productid=9nblggh4nns1" -Wait
        Write-Host "Please install App Installer from the Microsoft Store, which includes winget, then rerun the script."
        exit
    } else {
        Write-Host "winget is already installed."
    }
}

# Function to Install Chocolatey
function Install-Choco {
    if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
        Write-Host "Chocolatey is not installed. Installing Chocolatey..."
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        Write-Host "Chocolatey installation complete."
    } else {
        Write-Host "Chocolatey is already installed."
    }
}

# Function to Install Pip
function Install-Pip {
    if (-Not (Get-Command pip -ErrorAction SilentlyContinue)) {
        Write-Host "pip is not installed. Installing pip..."
        # Download get-pip.py
        Invoke-WebRequest -Uri "https://bootstrap.pypa.io/get-pip.py" -OutFile "$env:TEMP\get-pip.py"
        # Run get-pip.py
        python.exe "$env:TEMP\get-pip.py"
        # Check if pip installation succeeded
        if ($LASTEXITCODE -eq 0) {
            Write-Host "pip installation complete."
        } else {
            Write-Host "pip installation failed."
        }
    } else {
        Write-Host "pip is already installed."
    }
}

# Function to Install Software using winget, choco, or pip
function Install-Software {
    param (
        [string]$packageName,
        [string]$packageManager = "winget"  # Default to winget, can be "choco" or "pip"
    )

    if ($packageManager -eq "winget") {
        Install-Winget
        Write-Host "Installing $packageName using winget..."
        winget install --id $packageName --accept-package-agreements --accept-source-agreements -e --silent
    } elseif ($packageManager -eq "choco") {
        Install-Choco
        Write-Host "Installing $packageName using choco..."
        choco install $packageName -y
    } elseif ($packageManager -eq "pip") {
        Install-Pip
        Write-Host "Installing $packageName using pip..."
        pip install $packageName
    } else {
        Write-Host "Unsupported package manager: $packageManager. Please use 'winget', 'choco', or 'pip'."
    }
}

# Function to Upgrade to Windows 10 Enterprise
function Upgrade-Windows10Enterprise {
    Write-Host "Upgrading to Windows 10 Enterprise..."
    # Assuming valid enterprise key, replace YOUR_WINDOWS_10_ENTERPRISE_KEY with the actual key
    $enterpriseKey = "YOUR_WINDOWS_10_ENTERPRISE_KEY"
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -Name "BackupProductKeyDefault" -Value $enterpriseKey
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ipk $enterpriseKey
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /skms kms8.msguides.com
    cscript.exe "$env:SystemRoot\System32\slmgr.vbs" /ato
}

# Function to Run MassGravel Microsoft Activation Script from GitHub with HWID
function Activate-WindowsHWID {
    $scriptUrl = "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/main/HWID_Activation/HWID_Activation.cmd"
    $scriptContent = (Invoke-WebRequest -Uri $scriptUrl).Content
    $tempScriptPath = "$env:TEMP\HWID_Activation.cmd"

    Write-Host "Downloading and running MassGravel Microsoft Activation Script..."
    $scriptContent | Out-File -FilePath $tempScriptPath -Encoding ASCII

    # Run the downloaded script with HWID option
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c $tempScriptPath /hwid" -Wait -NoNewWindow

    # Check Activation Status
    $activationStatus = (Get-CimInstance -ClassName SoftwareLicensingProduct | Where-Object { $_.PartialProductKey } | Select-Object -ExpandProperty LicenseStatus)
    if ($activationStatus -eq 1) {
        Write-Host "Windows is activated."
    } else {
        Write-Host "Windows activation failed."
    }
}

# Installers
#
# Winget
Install-Software -packageName "Microsoft.AppInstaller" -packageManager "winget"
Install-Software -packageName "Microsoft.AppInstallerFileBuilder" -packageManager "winget"
Install-Software -packageName "Microsoft.DotNet.Runtime.Preview" -packageManager "winget"
Install-Software -packageName "Microsoft.DotNet.SDK.8" -packageManager "winget"
Install-Software -packageName "Microsoft.DotNet.Framework.DeveloperPack_4" -packageManager "winget"
Install-Software -packageName "Microsoft.VCRedist.2010.x64" -packageManager "winget"
Install-Software -packageName "Microsoft.VCRedist.2012.x64" -packageManager "winget"
Install-Software -packageName "Microsoft.VCRedist.2013.x64" -packageManager "winget"
Install-Software -packageName "Microsoft.VCRedist.2015+.x64" -packageManager "winget"
Install-Software -packageName "Microsoft.PerfView" -packageManager "winget"
Install-Software -packageName "Microsoft.PowerToys" -packageManager "winget"
Install-Software -packageName "Microsoft.VisualStudioCode" -packageManager "winget"
Install-Software -packageName "Microsoft.WindowsTerminal" -packageManager "winget"

Install-Software -packageName "Mozilla.Firefox" -packageManager "winget"
Install-Software -packageName "7zip.7zip" -packageManager "winget"
Install-Software -packageName "Mythicsoft.AgentRansack" -packageManager "winget"
Install-Software -packageName "Audacity.Audacity" -packageManager "winget"
Install-Software -packageName "AutoHotkey.AutoHotkey" -packageManager "winget"
Install-Software -packageName "Bitwarden.Bitwarden" -packageManager "winget"
Install-Software -packageName "CPUID.HWMonitor" -packageManager "winget"
Install-Software -packageName "Discord.Discord" -packageManager "winget"
Install-Software -packageName "Plex.Plex" -packageManager "winget"
Install-Software -packageName "ProtonTechnologies.ProtonVPN" -packageManager "winget"
Install-Software -packageName "Python.Python.3.12" -packageManager "winget"
Install-Software -packageName "Python.Python.3.11" -packageManager "winget"
Install-Software -packageName "VideoLAN.VLC" -packageManager "winget"
Install-Software -packageName "AntibodySoftware.WizTree" -packageManager "winget"
Install-Software -packageName "Valve.Steam" -packageManager "winget"
Install-Software -packageName "REALiX.HWiNFO" -packageManager "winget"
Install-Software -packageName "Valve.Steam" -packageManager "winget"
Install-Software -packageName "Spotify.Spotify" -packageManager "winget"
Install-Software -packageName "EpicGames.EpicGamesLauncher" -packageManager "winget"
Install-Software -packageName "SomePythonThings.WingetUIStore" -packageManager "winget"
Install-Software -packageName "Oracle.JavaRuntimeEnvironment" -packageManager "winget"
Install-Software -packageName "Nvidia.GeForceExperience" -packageManager "winget"
Install-Software -packageName "Nvidia.PhysX" -packageManager "winget"
Install-Software -packageName "HandBrake.HandBrake" -packageManager "winget"
Install-Software -packageName "c0re100.qBittorrent-Enhanced-Edition" -packageManager "winget"
Install-Software -packageName "ElectronicArts.EADesktop" -packageManager "winget"
Install-Software -packageName "yt-dlp.yt-dlp" -packageManager "winget"
# Choco
Install-Software -packageName "winaero-tweaker" -packageManager "choco"
Install-Software -packageName "multimc" -packageManager "choco"


# Registry Modifications
#
# Function to Apply Registry Changes
function Apply-RegistryChanges {
    Write-Host "Applying registry changes..."

    # Set icon cache size to 5096 KB
    Set-ItemProperty -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "Max Cached Icons" -Value 5096

    # Disable telemetry and data collection
    New-Item -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Force
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0

    # Disable power throttling
    New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power" -Name "PowerThrottling" -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Power\PowerThrottling" -Name "PowerThrottlingOff" -Value 1

    # Disable Windows Ink Workspace
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowWindowsInkWorkspace" -Value 0

    # Disable Cortana
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0

    # Disable online and video tips in settings
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "AllowOnlineTips" -Value 0

    # Disable Edge updates
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "DisableEdgeUpdate" -Value 1

    # Disable Edge sidebar
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "HubsSidebarEnabled" -Value 0

    # Disable Edge personalize web experience
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "PersonalizationReportingEnabled" -Value 0

    # Disable Edge follow creators
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "FollowCreatorsEnabled" -Value 0

    # Disable Edge enhance images
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Edge" -Name "EnhanceImagesEnabled" -Value 0

    # Disable Edge desktop shortcut creation after updates
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\EdgeUpdate" -Name "CreateDesktopShortcutDefault" -Value 0

    # Set task button grouping to switch to last active window in group
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LastActiveClick" -Value 1

    # Hide Windows Insider page from settings
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "SettingsPageVisibility" -Value "hide:windowsinsider"

    # Set File Explorer starting folder to This PC
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Value 1

    # Set default drag n drop action to move
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DefaultDropEffect" -Value 2

    # Disable taskbar web search in taskbar and Cortana
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Value 0

    # Disable quick action button
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Value 0

    # Disable login screen background image
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DisableLogonBackgroundImage" -Value 1

    # Disable blur on sign-in screen
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "DisableAcrylicBackgroundOnLogon" -Value 1

    # Disable the lock screen
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Value 1

    # Disable user folder backup to OneDrive
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\OneDrive" -Name "DisableTutorial" -Value 1

    # Disable error reporting
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Error Reporting" -Name "Disabled" -Value 1

    # Disable timeline
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Value 0
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Value 0

    # Disable download blocking in File Explorer
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Policies\Attachments" -Name "SaveZoneInformation" -Value 1

    # Disable "you have new apps that can open this type of file" notifications
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowNewAppAlert" -Value 0

    # Keep thumbnail cache after restart/shutdown
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbnailCache" -Value 0

    # Set apps and system to use dark theme
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0

    # Disable ads in Windows, tips, tailored experiences, spotlight and lock screen ads, welcome experience, and start menu suggestions
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SoftLandingEnabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Value 0

    # Enable automatic registry backup
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SoftwareProtectionPlatform" -Name "EnableBackupRestore" -Value 1

    # Disable Aero Shake
    New-Item -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Force
    Set-ItemProperty -Path "HKCU:\Software\Policies\Microsoft\Windows\Explorer" -Name "NoWindowMinimizingShortcuts" -Value 1

    # Set show menu delay to 350ms
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "MenuShowDelay" -Value 350

    # Set screensaver grace period to 5 seconds
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "ScreenSaverGracePeriod" -Value 5

    # Show hidden files
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Hidden" -Value 1

    # Show file extensions
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Value 0

    # Disable lock screen
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows" -Name "Personalization" -Force
    Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Personalization" -Name "NoLockScreen" -Value 1

    # Additional registry tweaks
    # Enable dark mode
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0

    #  Disable Windows 10 telemetry
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Value 0

    #  Disable Cortana
    Set-ItemProperty -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Value 0

} 


# Function to Uninstall UWP Apps
function Uninstall-UWPApp {
    param (
        [string]$appName
    )
    
    $app = Get-AppxPackage -Name $appName -ErrorAction SilentlyContinue
    if ($app) {
        Write-Host "Uninstalling $appName..."
        Remove-AppxPackage -Package $app.PackageFullName
    } else {
        Write-Host "$appName is not installed."
    }
}

# Function to Uninstall Desktop Apps
function Uninstall-DesktopApp {
    param (
        [string]$appName
    )
    
    $app = Get-WmiObject -Query "SELECT * FROM Win32_Product WHERE Name = '$appName'" -ErrorAction SilentlyContinue
    if ($app) {
        Write-Host "Uninstalling $appName..."
        $app.Uninstall()
    } else {
        Write-Host "$appName is not installed."
    }
}

# Function to Uninstall Apps using winget, choco, or directly
function Uninstall-Apps {
    param (
        [string[]]$appNames,
        [string]$packageManager = "direct"  # Default to direct, can be "winget", "choco", or "direct"
    )

    if ($packageManager -eq "winget") {
        Install-Winget
        foreach ($appName in $appNames) {
            Write-Host "Uninstalling $appName using winget..."
            winget uninstall --id $appName --accept-package-agreements --accept-source-agreements -e --silent
        }
    } elseif ($packageManager -eq "choco") {
        Install-Choco
        foreach ($appName in $appNames) {
            Write-Host "Uninstalling $appName using choco..."
            choco uninstall $appName -y
        }
    } elseif ($packageManager -eq "direct") {
        foreach ($appName in $appNames) {
            Write-Host "Attempting to uninstall $appName directly..."
            Uninstall-UWPApp -appName $appName
            Uninstall-DesktopApp -appName $appName
        }
    } else {
        Write-Host "Unsupported package manager: $packageManager. Please use 'winget', 'choco', or 'direct'."
    }
}


# Uninstall Microsoft Sticky Notes, Microsoft Tips (Get Help), and Microsoft Paint 3D directly
Uninstall-Apps -appNames @("Microsoft.MicrosoftStickyNotes", "Microsoft.GetHelp", "Microsoft.MSPaint", "Microsoft.3DBuilder", "Microsoft.BingWeather", "Microsoft.OneDrive") -packageManager "direct"

# Upgrade to Windows 10 Enterprise
Upgrade-Windows10Enterprise

# Activate Windows with HWID
Activate-WindowsHWID

Write-Host "Script execution completed."

# Prompt for reboot
$response = Read-Host "Would you like to reboot now? (y/n)"
if ($response -eq 'y') {
    Restart-Computer -Force
}

