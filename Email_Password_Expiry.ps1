# Query AD for users with expiring passwords
$Users = Get-ADUser -Filter {Enabled -eq $true -and PasswordNeverExpires -eq $false -and PasswordExpired -eq $false} -Properties "Name", "EmailAddress", "msDS-UserPasswordExpiryTimeComputed" |
    Where-Object { $_."msDS-UserPasswordExpiryTimeComputed" -ne 0 } |
    Select-Object -Property "Name", "EmailAddress", @{
        Name = "PasswordExpiry"
        Expression = { [datetime]::FromFileTime($_."msDS-UserPasswordExpiryTimeComputed") }
    } |
    Where-Object { $_.PasswordExpiry -ge (Get-Date).Date -and $_.PasswordExpiry -le (Get-Date).Date.AddDays(7) }

# Get Outlook signature
$Outlook = New-Object -ComObject Outlook.Application
$Signature = $Outlook.EmailOptions.EmailSignature
$SignatureHTML = $Signature.HtmlBody

# Prepare the email body with BCC recipients
$EmailSubject = "Password Expiry Notification"
$EmailBody = @"
Hi,

IT would like to inform you that your account password is scheduled to expire soon.

As part of our commitment to maintaining the security and integrity of Truth Initiative's systems, we kindly request that you change your password promptly.

Ensuring strong password hygiene is crucial in safeguarding sensitive data and preventing unauthorized access to your account.

Please do not hesitate to reach out to our dedicated support team by opening a ticket on our Helpdesk. You can initiate this process by emailing servicedesk@truthinitiative.org.

You may also refer to the FAQ section on our Sharepoint site, accessible through the following link: https://truthinitiative.sharepoint.com/sites/ITtipsandtricks/SitePages/FAQ.aspx

$SignatureHTML

Thanks,
IT Team
"@

# Collect BCC recipients
$BCCRecipients = $Users.EmailAddress -join ","

# Create and display the email
$Outlook = New-Object -ComObject Outlook.Application
$Mail = $Outlook.CreateItem(0)
$Mail.Subject = $EmailSubject
$Mail.HTMLBody = "<p style='font-family:Calibri;font-size:11pt;'>$EmailBody</p>"
$Mail.BCC = $BCCRecipients
$Mail.Display()
