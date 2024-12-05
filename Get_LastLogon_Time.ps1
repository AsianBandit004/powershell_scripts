# Export the list of inactive users to a CSV file
$inactiveUsers | Export-Csv -Path "C:\temp\users.csv" -NoTypeInformation

# Define the number of days for which a user should be considered inactive
$inactiveDays = 720

# Get the current date and subtract the number of days for which a user should be considered inactive
$inactiveDate = (Get-Date).AddDays(-$inactiveDays)

# Get a list of all Active Directory user accounts in the current domain
$users = Get-ADUser -Filter { Enabled -eq $true } -Properties LastLogonDate, DisplayName, SamAccountName, EmailAddress

# Create an array to store the inactive users
$inactiveUsers = @()

# Loop through each user account and check if they have logged in within the specified timeframe
foreach ($user in $users) {
    $lastLogonDate = $user.LastLogonDate
    if ($lastLogonDate -lt $inactiveDate) {
        # If the user has not logged in within the specified timeframe, add them to the array of inactive users
        $inactiveUsers += $user
    }
}

# Export the list of inactive users to a CSV file
$inactiveUsers | Select-Object DisplayName, SamAccountName, EmailAddress | Export-Csv -Path "C:\Path\To\InactiveUsers.csv" -NoTypeInformation