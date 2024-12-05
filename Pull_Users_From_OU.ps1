# Specify the distinguished name (DN) of the OU you want to retrieve users from
$ou = "OU=Disabled User Accounts,DC=Americanlegacy,DC=org"

# Retrieve all users within the specified OU, and select only FirstName and LastName properties
$users = Get-ADUser -Filter * -SearchBase $ou -Properties GivenName, Surname |
         Select-Object @{Name="FirstName"; Expression={$_.GivenName}}, 
                       @{Name="LastName"; Expression={$_.Surname}}

# Display the list of users with FirstName and LastName
$users | Format-Table -AutoSize
