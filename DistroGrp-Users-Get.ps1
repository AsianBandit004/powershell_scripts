# Get all distribution groups
$groups = Get-DistributionGroup

# Initialize an array to store results
$results = @()

# Loop through each group to get its members
foreach ($group in $groups) {
    Write-Output "Group: $($group.DisplayName)"
    $members = Get-DistributionGroupMember -Identity $group.Identity | Select-Object DisplayName, PrimarySmtpAddress
    foreach ($member in $members) {
        Write-Output "    Member: $($member.DisplayName) - Email: $($member.PrimarySmtpAddress)"
        
        # Add member details to results array
        $results += [PSCustomObject]@{
            GroupName           = $group.DisplayName
            MemberDisplayName   = $member.DisplayName
            MemberEmail         = $member.PrimarySmtpAddress
        }
    }
}

# Export results to CSV
$results | Export-Csv -Path "C:\Temp\DistributionGroupsMembers.csv" -NoTypeInformation
