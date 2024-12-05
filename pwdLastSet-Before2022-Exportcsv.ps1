# Import the Active Directory module if it's not already loaded
Import-Module ActiveDirectory

# Define the date you want to filter against (January 1, 2022)
$startDate = Get-Date "2022-01-01"

# Get all users in the domain whose password was last set before 2022-01-01 and include their Description
Get-ADUser -Filter * -Properties pwdLastSet, Description |
    Where-Object { $_.pwdLastSet -lt ($startDate.ToFileTime()) } |
    Select-Object SamAccountName, Name, Description, @{Name="PasswordLastSet";Expression={[datetime]::FromFileTime($_.pwdLastSet)}} |
    Export-Csv -Path "C:\Temp\AD_Passwords_Before_2022.csv" -NoTypeInformation -Force
