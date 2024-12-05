# Prompt the user for the server name
$ServerName = Read-Host "Enter the server name"

# Set the number of logs to retrieve
$LogCount = 5

# Get the last 5 system logs from the specified server
$Logs = Get-WinEvent -LogName System -ComputerName $ServerName -MaxEvents $LogCount | Select-Object -Property TimeCreated, Id, Message

# Display the retrieved logs
$Logs | Format-Table -AutoSize
