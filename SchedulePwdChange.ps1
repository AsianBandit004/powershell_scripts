# Import the Active Directory module
Import-Module ActiveDirectory

# Specify the user's SamAccountName
$userSamAccountName = "T3MFA"

# Specify the new password
$newPassword = ConvertTo-SecureString -String "NewPassword123!" -AsPlainText -Force

# Get the user's current AD object
$user = Get-ADUser -Filter { SamAccountName -eq $userSamAccountName }

# Change the password silently
Set-ADAccountPassword -Identity $user -NewPassword $newPassword -Reset
