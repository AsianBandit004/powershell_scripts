# Query AD for users with expiring passwords
$Users = Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false -and PasswordExpired -eq $false} -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" |
    Where-Object { $_."msDS-UserPasswordExpiryTimeComputed" -ne 0 } |
    Select-Object -Property "Name", "EmailAddress", @{
        Name = "PasswordExpiry"
        Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") }
    } |
    Where-Object { $_.PasswordExpiry -ge (Get-Date).Date -and $_.PasswordExpiry -le (Get-Date).Date.AddDays(7) }

# Open Outlook with pre-filled emails for each user
foreach ($User in $Users) {
    $ExpiryDate = $User.PasswordExpiry.ToShortDateString()
    $EmailSubject = "Password Expiry Notification"
    $EmailBody = @"
Hi $($User.Name),

IT would like to inform you that your account password is scheduled to expire on $ExpiryDate.
As part of our commitment to maintaining the security and integrity of Truth Initiative's systems, we kindly request that you change your password promptly.

Ensuring strong password hygiene is crucial in safeguarding sensitive data and preventing unauthorized access to your account.
Please do not hesitate to reach out to our dedicated support team by opening a ticket on our Helpdesk. You can initiate this process by emailing servicedesk@truthinitiative.org.

You may also refer to the FAQ section on our Sharepoint site, accessible through the following link: https://truthinitiative.sharepoint.com/sites/ITtipsandtricks/SitePages/FAQ.aspx

Thanks,
IT Team
"@
    
    $Outlook = New-Object -ComObject Outlook.Application
    $Mail = $Outlook.CreateItem(0)
    $Mail.Subject = $EmailSubject
    $Mail.Body = $EmailBody
    $Mail.To = $User.EmailAddress
    $Mail.Display()
}
