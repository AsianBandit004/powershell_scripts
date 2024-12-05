#Connect To Exchange Online
Connect-ExchangeOnline
#Import Management Module
Install-Module -Name ExchangeOnlineManagement
Import-Module -Name ExchangeOnlineManagement

# Prompt for the user's email address
$UserEmail = Read-Host "Enter the user's email address"

# Define an array of distribution lists with their corresponding numbers
$DistributionLists = @(
    @{ Number = 1; Name = "Staff" },
    @{ Number = 2; Name = "PhishAlertMember" },
    @{ Number = 3; Name = "T3RoomAccess" },
    @{ Number = 4; Name = "Signature-Enabled-Users" },
    @{ Number = 5; Name = "PhishAlertGroup-ABC" },
    @{ Number = 6; Name = "PhishAlertGroup-DEF" },
    @{ Number = 7; Name = "PhishAlertGroup-GHI" },
    @{ Number = 8; Name = "PhishAlertGroup-JKL" },
    @{ Number = 9; Name = "PhishAlertGroup-MNO" },
    @{ Number = 10; Name = "PhishAlertGroup-PQR" },
    @{ Number = 11; Name = "PhishAlertGroup-STU" },
    @{ Number = 12; Name = "PhishAlertGroup-VWXYZ" },
    @{ Number = 13; Name = "Veeam-O365-Bkp2-FirstName_A-D" },
    @{ Number = 14; Name = "Veeam-O365-Bkp3-FirstName_E-L" },
    @{ Number = 15; Name = "Veeam-O365-Bkp4-FirstName_M-Q" },
    @{ Number = 16; Name = "Veeam-O365-Bkp5-FirstName_R-Z" }
)

# Display the available distribution lists with their numbers
Write-Host "Available Distribution Lists:"
$DistributionLists | ForEach-Object { Write-Host "$($_.Number). $($_.Name)" }

# Prompt for the distribution list selection by number
$SelectedNumbers = Read-Host "Enter the numbers of the distribution lists to add the user to, separated by commas (e.g., 1, 3, 5)"

# Convert the comma-separated numbers to an array
$SelectedNumbersArray = $SelectedNumbers -split '\s*,\s*'

# Find the selected distribution lists by numbers
$SelectedDistributionLists = $DistributionLists | Where-Object { $SelectedNumbersArray -contains $_.Number.ToString() }

if ($SelectedDistributionLists) {
    foreach ($SelectedDistributionList in $SelectedDistributionLists) {
        # Add the user to each selected distribution list
        Add-DistributionGroupMember -Identity $SelectedDistributionList.Name -Member $UserEmail
        Write-Host "User added to $($SelectedDistributionList.Name) successfully."
    }
}
