Add-Type -AssemblyName System.Drawing

$source = "P:\FOTO SPETTACOLI\FOTO LAVORI\MARIA DI ROHAN"
$dest = "C:\Users\vitto\cristiantaraborrelli.github.io\images"
$maxDim = 1920
$quality = 82

$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

1..8 | ForEach-Object {
    $n = "{0:D2}" -f $_
    $src = Join-Path $source "$n.jpg"
    $out = Join-Path $dest "maria-di-rohan-$n.jpg"
    if (-not (Test-Path $src)) { Write-Host "MISSING: $src"; return }

    $img = [System.Drawing.Image]::FromFile($src)
    $w = $img.Width; $h = $img.Height
    if ($w -gt $h) {
        if ($w -gt $maxDim) { $newW = $maxDim; $newH = [int]($h * $maxDim / $w) } else { $newW = $w; $newH = $h }
    } else {
        if ($h -gt $maxDim) { $newH = $maxDim; $newW = [int]($w * $maxDim / $h) } else { $newW = $w; $newH = $h }
    }
    $bmp = New-Object System.Drawing.Bitmap $newW, $newH
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
    $g.PixelOffsetMode = [System.Drawing.Drawing2D.PixelOffsetMode]::HighQuality
    $g.DrawImage($img, 0, 0, $newW, $newH)
    $bmp.Save($out, $jpegEncoder, $encoderParams)
    $g.Dispose(); $bmp.Dispose(); $img.Dispose()

    $sz = (Get-Item $out).Length / 1KB
    Write-Host ("OK: maria-di-rohan-{0}.jpg  {1}x{2}  {3:N0} KB" -f $n, $newW, $newH, $sz)
}
Write-Host "Done."
