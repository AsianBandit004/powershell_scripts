function WriteLog
{
Param ([string]$LogString)
$Stamp = (Get-Date).toString("yyyy/MM/dd HH:mm:ss")
$LogMessage = "$Stamp $LogString"
Add-content $LogFile -value $LogMessage
}
$Logfile = "C:\Windows\posh_font_install.log"
$SourceFolder = "\\dc\WP\New Brand Fonts 2024\New Brand Fonts 2024\ZigZag"
Add-Type -AssemblyName System.Drawing
$WindowsFonts = [System.Drawing.Text.PrivateFontCollection]::new()
Get-ChildItem -Path $SourceFolder -Include *.ttf, *.otf -Recurse -File |
Copy-Item -Destination "$env:SystemRoot\Fonts" -Force -Confirm:$false -PassThru |
ForEach-Object {
WriteLog "Installing font file $_.name"
$WindowsFonts.AddFontFile($_.fullname)
$RegistryValue = @{
Path = 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts'
Name = $WindowsFonts.Families[-1].Name
Value = $_.Fullname
}
$RemoveRegistry = "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts"
Remove-ItemProperty -name $($WindowsFonts.Families[-1].Name) -path $RemoveRegistry
New-ItemProperty @RegistryValue
}