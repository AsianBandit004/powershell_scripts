# Load Windows Forms
Add-Type -AssemblyName System.Windows.Forms

# Create a form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Installation"
$form.Size = New-Object System.Drawing.Size(300, 150)
$form.StartPosition = "CenterScreen"

# Create a label
$label = New-Object System.Windows.Forms.Label
$label.Text = "Installing Jecko and Zigzag fonts...."
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($label)

# Create a progress bar
$progressBar = New-Object System.Windows.Forms.ProgressBar
$progressBar.Location = New-Object System.Drawing.Point(20, 60)
$progressBar.Size = New-Object System.Drawing.Size(250, 30)
$progressBar.Style = [System.Windows.Forms.ProgressBarStyle]::Marquee
$form.Controls.Add($progressBar)

# Show the form
$form.Show()

# Simulate installation process (this is where you would put your installation logic)
Start-Sleep -Seconds 5  # Simulate a delay for the installation

# Close the form after the "installation" is done
$form.Close()

# Show a completion message
[System.Windows.Forms.MessageBox]::Show("Installation complete!")
