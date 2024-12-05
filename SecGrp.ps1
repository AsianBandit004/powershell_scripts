# NOTE PLEASE REPLACE NETWORKPATH && GROUPNAME WITH YOUR VALUES FOR SEC GRP INFORMATION
# RUN IN AN ADMIN SESSION
# Define the network path and the security group name
$networkPath = "\\t3fs\SIData"  # Replace with your network path
$groupName = "Innovations Security"  # Replace with your security group name

# Get a list of all directories (folders) in the network path
$folders = Get-ChildItem -Path $networkPath -Directory

# Loop through each folder to check permissions
foreach ($folder in $folders) {
    # Get the ACL (Access Control List) of the folder
    $acl = Get-Acl -Path $folder.FullName

    # Loop through each access rule in the ACL
    foreach ($rule in $acl.Access) {
        # Check if the rule applies to the specified security group
        if ($rule.IdentityReference.Value -eq "LEGACY\$groupName" -and $rule.FileSystemRights -ne "0") {
            Write-Output "$groupName has permissions on $($folder.FullName)"
        }
    }
}
