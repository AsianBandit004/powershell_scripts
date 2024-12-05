# Set the OU distinguished name (DN) where you want to search for users
$OU = "OU=IT,OU=Legacy Domain Users,DC=Americanlegacy,DC=org"

# Query AD for users within the specified OU with expiring passwords
$Users = Get-ADUser -Filter "Enabled -eq `$true -and PasswordNeverExpires -eq `$false -and PasswordExpired -eq `$false" -SearchBase $OU -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" |
    Where-Object { $_."msDS-UserPasswordExpiryTimeComputed" -ne 0 } |
    Select-Object -Property "Name", "EmailAddress", @{
        Name = "PasswordExpiry"
        Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") }
    }

# Check if users are found
if ($Users.Count -eq 0) {
    Write-Host "No users with expiring passwords found."
    exit
}

# Filter users with passwords expiring within the next 14 days
$ExpiringUsers = $Users | Where-Object { $_.PasswordExpiry -ge (Get-Date).Date -and $_.PasswordExpiry -le (Get-Date).Date.AddDays(14) }

# Check if expiring users are found
if ($ExpiringUsers.Count -eq 0) {
    Write-Host "No users with passwords expiring within the next 14 days found."
    exit
}

# Create an Outlook application object
$Outlook = New-Object -ComObject Outlook.Application

# Iterate through each expiring user to send notification emails
foreach ($User in $ExpiringUsers) {
    # Create a new mail item
    $Mail = $Outlook.CreateItem(0) # 0 is MailItem

    # Set mail properties
    $Mail.Subject = "Password Expiry Notification"
    $Mail.Body = "Dear $($User.Name),

IT would like to inform you that your account password is scheduled to expire on $($User.PasswordExpiry.ToShortDateString()).
As part of our commitment to maintaining the security and integrity of Truth Initiative's systems, we kindly request that you change your password promptly.

Ensuring strong password hygiene is crucial in safeguarding sensitive data and preventing unauthorized access to your account.
Please do not hesitate to reach out to our dedicated support team by opening a ticket on our Helpdesk. You can initiate this process by emailing servicedesk@truthinitiative.org.

You may also refer to the FAQ section on our Sharepoint site, accessible through the following link: https://truthinitiative.sharepoint.com/sites/ITtipsandtricks/SitePages/FAQ.aspx

Thanks,
IT Team.

Please consider updating it at your earliest convenience."
    $Mail.BCC = $User.EmailAddress  # BCC the user

    # Display the email in Outlook
    $Mail.Display()
}

# Clean up COM object
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($Outlook) | Out-Null
