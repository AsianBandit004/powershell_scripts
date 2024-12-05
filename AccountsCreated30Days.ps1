$startDate = (Get-Date).AddMonths(-1)
$users = Get-ADUser -Filter { Created -ge $startDate } -Properties Created

if ($users) {
    $users | Select-Object Name, SamAccountName, Created
} else {
    Write-Host "No users found."
}
