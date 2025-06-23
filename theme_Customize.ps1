Add-Type -AssemblyName System.Windows.Forms
Add-Type -AssemblyName System.Drawing

# Create the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "Windows 11 Theme Customizer"
$form.Size = New-Object System.Drawing.Size(400,400)
$form.StartPosition = "CenterScreen"

# Color dialog
$colorDialog = New-Object System.Windows.Forms.ColorDialog

# Button to choose accent color
$btnColor = New-Object System.Windows.Forms.Button
$btnColor.Text = "Choose Accent Color"
$btnColor.Location = New-Object System.Drawing.Point(30,30)
$btnColor.Add_Click({
    if ($colorDialog.ShowDialog() -eq "OK") {
        $color = $colorDialog.Color
        $argb = ($color.R -shl 16) -bor ($color.G -shl 8) -bor $color.B
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\DWM" -Name "AccentColor" -Value $argb
        Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Accent" -Name "StartColorMenu" -Value $argb
        Write-Host "Accent color updated to R:$($color.R) G:$($color.G) B:$($color.B)"
    }
})

# Dropdown for theme mode
$lblTheme = New-Object System.Windows.Forms.Label
$lblTheme.Text = "Choose Theme Mode:"
$lblTheme.Location = New-Object System.Drawing.Point(30,80)
$lblTheme.Size = New-Object System.Drawing.Size(120,20)

$themeDropdown = New-Object System.Windows.Forms.ComboBox
$themeDropdown.Items.AddRange(@("Light","Dark"))
$themeDropdown.Location = New-Object System.Drawing.Point(160,80)
$themeDropdown.SelectedIndex = 0

# Button to apply theme
$btnTheme = New-Object System.Windows.Forms.Button
$btnTheme.Text = "Apply Theme Mode"
$btnTheme.Location = New-Object System.Drawing.Point(30,110)
$btnTheme.Add_Click({
    $theme = $themeDropdown.SelectedItem
    $val = if ($theme -eq "Dark") { 0 } else { 1 }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value $val
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value $val
    Write-Host "$theme mode applied."
})

# Checkbox for transparency effects
$chkTransparency = New-Object System.Windows.Forms.CheckBox
$chkTransparency.Text = "Enable Transparency Effects"
$chkTransparency.Location = New-Object System.Drawing.Point(30,160)
$chkTransparency.Checked = $true

# Button to apply transparency setting
$btnTransparency = New-Object System.Windows.Forms.Button
$btnTransparency.Text = "Apply Transparency"
$btnTransparency.Location = New-Object System.Drawing.Point(30,190)
$btnTransparency.Add_Click({
    $val = if ($chkTransparency.Checked) { 1 } else { 0 }
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value $val
    Write-Host "Transparency set to: $($chkTransparency.Checked)"
})

# Slider to control animation speed (simulated by toggling animation)
$lblAnim = New-Object System.Windows.Forms.Label
$lblAnim.Text = "Toggle Animations (system-wide):"
$lblAnim.Location = New-Object System.Drawing.Point(30,240)
$lblAnim.Size = New-Object System.Drawing.Size(200,20)

$chkAnim = New-Object System.Windows.Forms.CheckBox
$chkAnim.Text = "Enable Animations"
$chkAnim.Location = New-Object System.Drawing.Point(30,270)
$chkAnim.Checked = $true

$btnAnim = New-Object System.Windows.Forms.Button
$btnAnim.Text = "Apply Animation Setting"
$btnAnim.Location = New-Object System.Drawing.Point(30,300)
$btnAnim.Add_Click({
    $val = if ($chkAnim.Checked) { 0 } else { 1 }
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects" -Name "VisualFXSetting" -Value $val
    rundll32.exe user32.dll,UpdatePerUserSystemParameters
    Write-Host "Animations enabled: $($chkAnim.Checked)"
})

# Add controls to the form
$form.Controls.Add($btnColor)
$form.Controls.Add($lblTheme)
$form.Controls.Add($themeDropdown)
$form.Controls.Add($btnTheme)
$form.Controls.Add($chkTransparency)
$form.Controls.Add($btnTransparency)
$form.Controls.Add($lblAnim)
$form.Controls.Add($chkAnim)
$form.Controls.Add($btnAnim)

# Run the form
$form.Topmost = $true
[void]$form.ShowDialog()
