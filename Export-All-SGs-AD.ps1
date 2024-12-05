# Import the Active Directory module if not already imported
Import-Module ActiveDirectory

# Get all security groups in the domain
$groups = Get-ADGroup -Filter {GroupCategory -eq 'Security'} -Properties DistinguishedName, WhenChanged, MemberOf

# Create an array to store the results
$results = @()

foreach ($group in $groups) {
    # Get the OU from the Distinguished Name
    $ou = ($group.DistinguishedName -replace '^CN=.*?,', '') -replace '(?<=,)(.*?)(?=,DC=)', '' 

    # Get members of the group
    $members = Get-ADGroupMember -Identity $group -ErrorAction SilentlyContinue | Select-Object -ExpandProperty SamAccountName

    # Get the groups the current group is a member of
    $memberOf = $group.MemberOf | ForEach-Object { (Get-ADGroup $_ -ErrorAction SilentlyContinue).Name }

    # Create a custom object for the results
    $result = [PSCustomObject]@{
        GroupName      = $group.Name
        OU             = $ou
        Members        = ($members -join ', ')
        MemberOf       = ($memberOf -join ', ')
        LastModified   = $group.WhenChanged
    }

    # Add the result to the array
    $results += $result
}

# Specify the path for the CSV file
$csvPath = "C:\Temp\AD-SGGrps.csv"

# Export the results to a CSV file
$results | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8

# Output the path of the CSV file
Write-Host "Results exported to $csvPath"
