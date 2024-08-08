# Set error handling
$ErrorActionPreference = "Stop"

# Function to check for administrative privileges
function Check-Admin {
    if (-Not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
        Write-Host "This script must be run as an administrator. Exiting..."
        Start-Sleep -Seconds 5
        exit 1
    }
}

# Function to handle cleanup on exit
function Cleanup {
    Write-Host "Cleaning up..."
    Set-Location -Path "C:\Windows\Temp"
    try {
        Unmount-DiskImage -ImagePath "C:\Windows\Temp\rl9.iso"
    } catch {
        Write-Host "Failed to unmount ISO"
    }
    Remove-Item -Recurse -Force "C:\Windows\Temp\iso" -ErrorAction SilentlyContinue
    Remove-Item -Recurse -Force "C:\Windows\Temp\working_directory" -ErrorAction SilentlyContinue
    Remove-Item -Force "C:\Windows\Temp\rl9.iso" -ErrorAction SilentlyContinue
}
Register-EngineEvent PowerShell.Exiting -Action { Cleanup }

# Function to handle errors
function ErrorExit($message) {
    Write-Host "Error: $message"
    exit 1
}

# Function to check and install Chocolatey
function Install-Chocolatey {
    Write-Host "Chocolatey is not installed. Would you like to install it now? (Y/N)"
    $response = Read-Host
    if ($response -eq 'Y' -or $response -eq 'y') {
        Set-ExecutionPolicy Bypass -Scope Process -Force
        [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
        Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
        if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
            ErrorExit "Failed to install Chocolatey."
        }
    } else {
        ErrorExit "Chocolatey is required to install packages. Exiting."
    }
}

# Check if script is running as administrator
Check-Admin

# Check if Chocolatey is installed
if (-Not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Install-Chocolatey
}

# Check PowerShell version
if ($PSVersionTable.PSVersion.Major -lt 5 -or ($PSVersionTable.PSVersion.Major -eq 5 -and $PSVersionTable.PSVersion.Minor -lt 1)) {
    ErrorExit "This script requires PowerShell 5.1 or higher."
}

# Enter Main #
Write-Host ""
Write-Host ""


# Download the ISO file
Write-Host ""
Write-Host "Downloading ISO from rockylinux.org..."
Write-Host ""
try {
    Invoke-WebRequest -Uri "https://download.rockylinux.org/pub/rocky/9/isos/x86_64/Rocky-9.4-x86_64-minimal.iso" -OutFile "C:\Windows\Temp\rl9.iso"
} catch {
    ErrorExit "Failed to download ISO."
}
Write-Host ""

# Create directories
try {
    New-Item -ItemType Directory -Path "C:\Windows\Temp\iso" -ErrorAction Stop
    New-Item -ItemType Directory -Path "C:\Windows\Temp\working_directory" -ErrorAction Stop
} catch {
    ErrorExit "Failed to create required directories."
}

# Mount the ISO
try {
    Mount-DiskImage -ImagePath "C:\Windows\Temp\rl9.iso" -StorageType ISO
    $isoDrive = (Get-Volume -FileSystemLabel "Rocky-9.4-x86_64-minimal").DriveLetter
} catch {
    ErrorExit "Failed to mount ISO."
}

# Synchronize files
try {
    Robocopy "$($isoDrive):\" "C:\Windows\Temp\working_directory" /E
} catch {
    ErrorExit "Failed to synchronize files."
}

# Download the isolinux and grub configuration files
try {
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/iso-configs/isolinux.cfg" -OutFile "C:\Windows\Temp\working_directory\isolinux\isolinux.cfg"
    Invoke-WebRequest -Uri "https://raw.githubusercontent.com/CriticalWombat/KickScan/dev/iso-configs/grub.cfg" -OutFile "C:\Windows\Temp\working_directory\EFI\BOOT\grub.cfg"
} catch {
    ErrorExit "Failed to replace isolinux.cfg or grub.cfg."
}

# Check if oscdimg is available
if (-Not (Get-Command oscdimg -ErrorAction SilentlyContinue)) {
    ErrorExit "oscdimg is not available. Please install the Windows ADK to proceed."
}

# Create the new ISO using oscdimg
try {
    & oscdimg -n -m -o -b"C:\Windows\Temp\working_directory\isolinux\isolinux.bin" "C:\Windows\Temp\working_directory" "C:\Windows\Temp\Bilge.iso"
} catch {
    ErrorExit "Failed to create ISO."
}
Write-Host ""
Write-Host "ISO creation successful. File saved as C:\Windows\Temp\Bilge.iso"
Write-Host ""
