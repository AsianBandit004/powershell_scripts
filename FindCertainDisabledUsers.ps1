# Retrieve shared mailboxes
$sharedMailboxes = Get-Mailbox -RecipientTypeDetails SharedMailbox

# Connect to MSOnline
$msoSession = Connect-MsolService

# Initialize array to store results
$results = @()

foreach ($mailbox in $sharedMailboxes) {
    $userPrincipalName = $mailbox.PrimarySmtpAddress.ToString()
    
    # Check if user exists in MSOnline
    $user = Get-MsolUser -UserPrincipalName $userPrincipalName -ErrorAction SilentlyContinue

    if ($user) {
        # Check MFA status
        $mfaState = $user.StrongAuthenticationRequirements.Count -gt 0
        
        $results += [PSCustomObject]@{
            SharedMailbox = $userPrincipalName
            MFAEnabled    = $mfaState
        }
    } else {
        $results += [PSCustomObject]@{
            SharedMailbox = $userPrincipalName
            MFAEnabled    = $false
        }
    }
}

# Display results
$results | Format-Table -AutoSize