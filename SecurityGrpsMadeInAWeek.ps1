# Get the current date and the date one week ago
$oneWeekAgo = (Get-Date).AddDays(-7)

# Retrieve all security groups created in the past week
$recentSecurityGroups = Get-ADGroup -Filter {GroupCategory -eq 'Security' -and WhenCreated -ge $oneWeekAgo} -Properties WhenCreated

# Output the groups and their creation date
$recentSecurityGroups | Select-Object Name, WhenCreated | Format-Table -AutoSize