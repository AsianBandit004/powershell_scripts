# Ensure the necessary .NET assembly is loaded
Add-Type -AssemblyName "System.Windows.Forms"

# Create a MessageBox to display success message
[System.Windows.Forms.MessageBox]::Show('Success', 'Logon', [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
