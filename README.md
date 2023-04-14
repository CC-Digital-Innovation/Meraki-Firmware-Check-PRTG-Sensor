# Meraki Upgrade Status

## Overview

This PowerShell script retrieves firmware upgrade information from the Meraki API and checks if there is a new firmware version available for any devices in the network. If an upgrade is available, it outputs a PRTG sensor result with a warning status. It also checks if there is an upgrade scheduled for any devices in the network and outputs the time remaining until the upgrade in days, with a maximum error limit that can be configured in the PRTG sensor settings.

## Usage

To use this script, you'll need to provide your Meraki API key and network ID as parameters. Here's an example command:

./MerakiUpgradeStatus.ps1 -apiKey "YOUR_API_KEY" -networkId "YOUR_NETWORK_ID"

## Parameters

- `apiKey`: The API key for accessing the Meraki API.
- `networkId`: The ID of the network to retrieve firmware upgrade information for.

## Outputs

This script outputs PRTG sensor results with information on the status of firmware upgrades for Meraki APs.

## Notes

- Author: Richard Travellin
- Date: 4/14/2023
- Version: 1.0
- Link: https://github.com/CC-Digital-Innovation/Meraki-Firmware-Check-PRTG-Sensor/
