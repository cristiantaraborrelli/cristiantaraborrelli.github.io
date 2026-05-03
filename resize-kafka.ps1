Add-Type -AssemblyName System.Drawing

$source = "P:\FOTO SPETTACOLI\FOTO LAVORI\TEATRO CORSETTI\wetransfer-96f0d8"
$dest = "C:\Users\vitto\cristiantaraborrelli.github.io\images"
$maxDim = 1920
$quality = 82

$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

1..4 | ForEach-Object {
    $i = $_
    $n = "{0:D2}" -f $i
    $src = Join-Path $source ("{0}_ilprocesso.jpg" -f $i)
    if (-not (Test-Path $src)) { Write-Host "MISSING: $src"; return }

    $out = Join-Path $dest "processo-kafka-$n.jpg"
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
    Write-Host ("OK: processo-kafka-{0}.jpg  {1}x{2}  {3:N0} KB" -f $n, $newW, $newH, $sz)
}
Write-Host "Done."
