#Search for the users and export report

get-aduser -filter * -properties Name, PasswordNeverExpires | where {
$_.passwordNeverExpires -eq "true" } |  Select-Object DistinguishedName,Name,Enabled | Sort-Object -Property Name | Out-GridView