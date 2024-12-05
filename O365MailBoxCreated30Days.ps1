# Calculate the date range (last 30 days)
$startDate = (Get-Date).AddDays(-30)
$endDate = Get-Date

# Retrieve new mailboxes created within the specified date range
$mailboxes = Search-UnifiedAuditLog -StartDate $startDate -EndDate $endDate -Operations "New-Mailbox" -ResultSize 1000 | Select-Object -ExpandProperty MailboxOwnerUPN -Unique

if ($mailboxes) {
    Write-Host "New mailboxes created within the last 30 days:"
    $mailboxes
} else {
    Write-Host "No new mailboxes created within the last 30 days."
}
