Add-Type -AssemblyName System.Drawing
$files = @('turandot-costume-04.jpg','turandot-costume-05.jpg')
foreach ($f in $files) {
  $path = "C:\Users\vitto\cristiantaraborrelli.github.io\images\$f"
  $img = [System.Drawing.Image]::FromFile($path)
  $ratio = [Math]::Min(1600 / $img.Width, 1600 / $img.Height)
  $newW = [int]($img.Width * $ratio)
  $newH = [int]($img.Height * $ratio)
  $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
  $g = [System.Drawing.Graphics]::FromImage($bmp)
  $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
  $g.DrawImage($img, 0, 0, $newW, $newH)
  $g.Dispose()
  $img.Dispose()
  $enc = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
  $ep = New-Object System.Drawing.Imaging.EncoderParameters(1)
  $ep.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, 80L)
  $tmpPath = $path + ".tmp"
  $bmp.Save($tmpPath, $enc, $ep)
  $bmp.Dispose()
  Remove-Item $path
  Rename-Item $tmpPath $f
  $newSize = (Get-Item $path).Length
  Write-Host "Resized $f to ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
}
