$path = "P:\FOTO SPETTACOLI\FOTO LAVORI\ON NE PAIE PAS"
$dstBase = "C:\Users\vitto\cristiantaraborrelli.github.io\images"

Add-Type -AssemblyName System.Drawing

$files = Get-ChildItem $path -Filter *.jpg | Sort-Object Name
Write-Host "Found $($files.Count) files:"
$i = 1
foreach ($f in $files) {
    Write-Host "  $($f.Name)"
}

# Select 6 files (all we have minus 1 to keep even)
$selected = $files | Select-Object -First 6
$idx = 1
foreach ($f in $selected) {
    $dst = "$dstBase\on-ne-paie-pas-0$idx.jpg"
    $img = [System.Drawing.Image]::FromFile($f.FullName)
    $ratio = [Math]::Min(1600 / $img.Width, 1600 / $img.Height)
    if ($ratio -ge 1) { $ratio = 1 }
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
    $bmp.Save($dst, $enc, $ep)
    $bmp.Dispose()
    $newSize = (Get-Item $dst).Length
    Write-Host "Created on-ne-paie-pas-0$idx.jpg ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
    $idx++
}
