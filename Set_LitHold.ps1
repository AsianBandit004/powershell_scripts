# Define the user's email address
$userEmail = "tfeldman@truthinitiative.org"

# Define the hold duration in days
$holdDuration = 365

# Calculate the hold end date
$holdEndDate = (Get-Date).AddDays($holdDuration)

# Enable litigation hold for the specified user
Set-Mailbox -Identity $userEmail -LitigationHoldEnabled $true -LitigationHoldDuration $holdDuration

# Add a note to the user's mailbox
$note = "Retention Order - Aug 2024"
Set-Mailbox -Identity $userEmail -RetentionComment $note

Write-Host "Litigation hold enabled and note added for $userEmail"