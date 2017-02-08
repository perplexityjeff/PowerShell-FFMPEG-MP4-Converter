$QualityOptions = 0..51
$PresetOptions = "ultrafast","superfast", "veryfast", "faster", "fast", "medium", "slow", "slower", "veryslow"

$FFMPEGLocation = $PSScriptRoot + "\ffmpeg.exe"

Add-Type -AssemblyName System.Windows.Forms

$FFMPEG_MP4_Converter = New-Object system.Windows.Forms.Form
[System.Windows.Forms.Application]::EnableVisualStyles()
$FFMPEG_MP4_Converter.Text = "FFMPEG MP4 Converter"
$FFMPEG_MP4_Converter.FormBorderStyle = 'FixedSingle'
$FFMPEG_MP4_Converter.MaximizeBox = $false
$FFMPEG_MP4_Converter.MinimizeBox = $false
$FFMPEG_MP4_Converter.TopMost = $true
$FFMPEG_MP4_Converter.Width = 275
$FFMPEG_MP4_Converter.Height = 308

$btnConvert = New-Object system.windows.Forms.Button
$btnConvert.Text = "Convert"
$btnConvert.Width = 85
$btnConvert.Height = 24
$btnConvert.Add_Click({
if(Test-Path $txtVideo.Text)
    {
        $lblStatus.Text = "Status: Converting Video..."
        $convertedVideoPath = $txtVideo.Text.Substring(0, $txtVideo.Text.LastIndexOf('.')) + "_CONVERTED_" + $(get-date -f yyyy-MM-dd-mm-ss-ms) + ".mp4"
        $audioArgument = "-b:a 192k"
        if ($chkAudio.Checked)
        {
          $audioArgument = "-an"
        }

        $Argument = "-i $($txtVideo.Text) -c:v libx264 -crf $($cmbQuality.Text) -preset $($cmbPreset.Text) -strict experimental $audioArgument $convertedVideoPath"

        Start-Process $FFMPEGLocation -ArgumentList $Argument -Wait

        [System.Windows.Forms.MessageBox]::Show("Video has been converted and saved at $convertedVideoPath!" , "FFMPEG MP4 Converter") 
    }
    else 
    {
        [System.Windows.Forms.MessageBox]::Show("Video file was not found or selected!" , "FFMPEG MP4 Converter") 
    }
    $lblStatus.Text = "Status: Standby"
})
$btnConvert.location = new-object system.drawing.point(15,232)
$btnConvert.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($btnConvert)

$txtVideo = New-Object system.windows.Forms.TextBox
$txtVideo.Width = 227
$txtVideo.Height = 20
$txtVideo.location = new-object system.drawing.point(15,28)
$txtVideo.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($txtVideo)

$btnBrowse = New-Object system.windows.Forms.Button
$btnBrowse.Text = "Browse"
$btnBrowse.Width = 85
$btnBrowse.Height = 24
$btnBrowse.Add_Click({
    $OpenFileDialog = New-Object System.Windows.Forms.OpenFileDialog
    $OpenFileDialog.initialDirectory = $initialDirectory
    $OpenFileDialog.CheckFileExists = $true
    $OpenFileDialog.ShowDialog() | Out-Null
    $txtVideo.Text = $OpenFileDialog.FileName
})
$btnBrowse.location = new-object system.drawing.point(158,233)
$btnBrowse.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($btnBrowse)

$lblStatus = New-Object system.windows.Forms.Label
$lblStatus.Text = "Status: Standby"
$lblStatus.AutoSize = $true
$lblStatus.Width = 25
$lblStatus.Height = 10
$lblStatus.location = new-object system.drawing.point(15,206)
$lblStatus.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($lblStatus)

$cmbQuality = New-Object system.windows.Forms.ComboBox
$cmbQuality.Width = 229
$cmbQuality.Height = 20
$cmbQuality.FlatStyle = "Standard"
$cmbQuality.location = new-object system.drawing.point(15,84)
$cmbQuality.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList;
Foreach($Quality in $QualityOptions)
{
    $cmbQuality.Items.Add($Quality)
}
$cmbQuality.Text = "20"
$cmbQuality.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($cmbQuality)

$lblQuality = New-Object system.windows.Forms.Label
$lblQuality.Text = "Quality (Lower is better):"
$lblQuality.AutoSize = $true
$lblQuality.Width = 25
$lblQuality.Height = 10
$lblQuality.location = new-object system.drawing.point(15,61)
$lblQuality.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($lblQuality)

$lblVideo = New-Object system.windows.Forms.Label
$lblVideo.Text = "Video:"
$lblVideo.AutoSize = $true
$lblVideo.Width = 25
$lblVideo.Height = 10
$lblVideo.location = new-object system.drawing.point(15,8)
$lblVideo.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($lblVideo)

$chkAudio = New-Object system.windows.Forms.CheckBox
$chkAudio.Text = "Exclude Audio"
$chkAudio.AutoSize = $true
$chkAudio.Width = 95
$chkAudio.Height = 20
$chkAudio.location = new-object system.drawing.point(15,170)
$chkAudio.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($chkAudio)

$cmbPreset = New-Object system.windows.Forms.ComboBox
$cmbPreset.Width = 229
$cmbPreset.Height = 20
$cmbQuality.FlatStyle = "Standard"
$cmbPreset.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList;
$cmbPreset.location = new-object system.drawing.point(15,139)
Foreach($Preset in $PresetOptions)
{
    $cmbPreset.Items.Add($Preset)
}
$cmbPreset.Text = "slower"
$cmbPreset.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($cmbPreset)

$lblPreset = New-Object system.windows.Forms.Label
$lblPreset.Text = "Preset:"
$lblPreset.AutoSize = $true
$lblPreset.Width = 25
$lblPreset.Height = 10
$lblPreset.location = new-object system.drawing.point(15,118)
$lblPreset.Font = "Segoe UI,10"
$FFMPEG_MP4_Converter.controls.Add($lblPreset)

[void]$FFMPEG_MP4_Converter.ShowDialog()
$FFMPEG_MP4_Converter.Dispose()
