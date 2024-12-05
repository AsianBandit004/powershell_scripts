Get-ADUser -Filter { Enabled -eq $True } -Properties LastLogonDate |
  #Tests whether LastLogonDate is older than 60 days or if it's $Null
  Where-Object { $_.LastLogonDate -lt (Get-Date).AddDays(-721) -or
                 -not $_.LastLogonDate } |
  Select-Object -Property SamAccountName |
  Format-Table