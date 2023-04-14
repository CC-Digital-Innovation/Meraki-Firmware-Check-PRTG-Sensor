<#
.SYNOPSIS
Checks the status of firmware upgrades for Meraki and outputs the results to PRTG.

.DESCRIPTION
This script retrieves firmware upgrade information from the Meraki API and checks if there is a new firmware version available for any devices in the network. If an upgrade is available, it outputs a PRTG sensor result with a warning status. It also checks if there is an upgrade scheduled for any devices in the network and outputs the time remaining until the upgrade in days, with a maximum error limit that can be configured in the PRTG sensor settings.

.PARAMETER apiKey
The API key for accessing the Meraki API.

.PARAMETER networkId
The ID of the network to retrieve firmware upgrade information for.

.INPUTS
None.

.OUTPUTS
Outputs PRTG sensor results with information on the status of firmware upgrades for Meraki APs.

.NOTES
Author: Richard Travellin
Date: 4/14/2023
Version: 1.0

.LINK
Link to the GitHub repository or other relevant documentation.

.EXAMPLE
./MerakiUpgradeStatus.ps1 -apiKey "YOUR_API_KEY" -networkId "YOUR_NETWORK_ID"

This example runs the script to check the firmware upgrade status for the specified Meraki network using the API key provided.

#>



# Define the Meraki API endpoint and authentication parameters
$apiEndpoint = "https://api.meraki.com/api/v1"
$apiKey = "YOUR_API_KEY"
$networkId = "YOUR_NETWORK_ID"

# Define the API request headers
$headers = @{
    "X-Cisco-Meraki-API-Key" = $apiKey
    "Content-Type" = "application/json"
}

# Define the API request URL for the network firmware upgrades
$urlFirmware = "$apiEndpoint/networks/$networkId/firmwareUpgrades"

# Send the API request to retrieve the network firmware upgrade information
$responseFirmware = Invoke-RestMethod -Uri $urlFirmware -Headers $headers -Method Get

# Check if there is a new firmware version available for any devices in the network
if ($responseFirmware.upgradeStatus -eq "available") {
    Write-Host "<prtg>"
    Write-Host "<result>"
    Write-Host "<channel>Firmware Upgrade Available</channel>"
    Write-Host "<value>1</value>"
    Write-Host "<warning>1</warning>"
    Write-Host "</result>"
} else {
    Write-Host "<prtg>"
    Write-Host "<result>"
    Write-Host "<channel>Firmware Upgrade Available</channel>"
    Write-Host "<value>0</value>"
    Write-Host "</result>"
}

# Send the API request to retrieve the network firmware upgrade schedule information
$urlSchedule = "$apiEndpoint/networks/$networkId/deviceUpgradeSchedule"
$responseSchedule = Invoke-RestMethod -Uri $urlSchedule -Headers $headers -Method Get

# Check if there is an upgrade scheduled for any devices in the network
if ($responseSchedule.upgrades) {
    $upgradeScheduled = $responseSchedule.upgrades | Select-Object -First 1
    $scheduledTime = Get-Date $upgradeScheduled.scheduledTime
    $timeRemaining = ($scheduledTime - (Get-Date)).Days

    Write-Host "<result>"
    Write-Host "<channel>Time Until Upgrade (Days)</channel>"
    Write-Host "<value>$timeRemaining</value>"
    Write-Host "<LimitMode>1</LimitMode>"
    Write-Host "<LimitMaxError>$upgradeLimitDays</LimitMaxError>"
    Write-Host "</result>"
} else {
    Write-Host "<result>"
    Write-Host "<channel>Time Until Upgrade (Days)</channel>"
    Write-Host "<value>0</value>"
    Write-Host "<LimitMode>1</LimitMode>"
    Write-Host "<LimitMaxError>$upgradeLimitDays</LimitMaxError>"
    Write-Host "</result>"
}

Write-Host "</prtg>"

