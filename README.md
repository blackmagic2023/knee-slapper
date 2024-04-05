# knee-slapper

This PowerShell script is designed as ransomware for testing analysis. It performs various tasks on a Windows operating system, such as encrypting files, establishing remote connections, and executing commands remotely.

## Functions:

-Encrypt-Directories: Encrypts directories recursively using AES encryption.

-Send-DeviceInformation: Establishes a remote connection to a specified DNS address and sends device information, decryption password, and random ID over DNS.

-Stop-Processes: Stops all running processes except for the current script.

-Visit-SiteInBackground: Visits a website in the background without opening a visible browser window.

-Get-NetworkInfo: Retrieves network information such as IP address and interface details.

-Get-PublicIP: Retrieves the public IP address of the target machine.

-Start-ProcessInBackground: Starts a specified process in the background without opening a visible window.

-Show-MessageOverBlackScreen: Displays a message popup over a black screen, preventing user interaction.

## Usage:

-Clone the repository to your local machine.

```
git clone 
```

-Open the PowerShell script in a text editor.

-Modify the script as needed, change values such as DNS addresses and encryption passwords to suit your testing environment.

-Run the script using PowerShell with administrator permissions.

## Modification Options:

-DNS Address: Change the DNS address in the `Send-DeviceInformation` function to establish connections with a different command and control server.

-Encryption Password: Modify the encryption password in the `Encrypt-Directories` function to change the password used for file encryption.

-Website URL: Update the website URL in the `Visit-SiteInBackground` function to visit a different website in the background.

-Process Name: Change the process name in the script to a different random name to avoid detection in process analyzers.

## Disclaimer:

This script is provided for educational and ethical purposes only. Misuse of this script for malicious intent is strictly prohibited. The author takes no responsibility for any damage caused by the use or misuse of this script.
