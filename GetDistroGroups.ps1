# Replace <UserEmailAddress> with the actual email address of the user
$userEmailAddress = "mkugler@truthinitiative.org"

# Get all distribution groups that the user is a member of
$groups = Get-DistributionGroup -ResultSize Unlimited | Where-Object { (Get-DistributionGroupMember $_.Identity -ResultSize Unlimited).PrimarySmtpAddress -contains $userEmailAddress }

# Display the list of distribution groups
$groups | Select-Object DisplayName, PrimarySmtpAddress
