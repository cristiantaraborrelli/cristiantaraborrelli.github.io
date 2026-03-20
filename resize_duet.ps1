Add-Type -AssemblyName System.Drawing

$srcPath = 'P:\FOTO SPETTACOLI\FOTO LAVORI\EXPO2030\ROME\NEW SITE\2G5A1177-scaled.jpg.webp'
$destPath = 'C:\Users\vitto\cristiantaraborrelli.github.io\images\expo-roma-2030-malika-durdust.jpg'
$maxDim = 1600
$quality = 80

try {
    $img = [System.Drawing.Image]::FromFile($srcPath)
    Write-Host "Original: $($img.Width) x $($img.Height)"

    $w = $img.Width
    $h = $img.Height
    if ($w -ge $h) {
        $newW = [math]::Min($w, $maxDim)
        $newH = [math]::Max(1, [math]::Round($h * $newW / $w))
    } else {
        $newH = [math]::Min($h, $maxDim)
        $newW = [math]::Max(1, [math]::Round($w * $newH / $h))
    }

    $bmp = New-Object System.Drawing.Bitmap($newW, $newH, [System.Drawing.Imaging.PixelFormat]::Format24bppRgb)
    $g = [System.Drawing.Graphics]::FromImage($bmp)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $g.DrawImage($img, 0, 0, $newW, $newH)

    $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
    $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
    $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)

    $bmp.Save($destPath, $codec, $encParams)
    $g.Dispose()
    $bmp.Dispose()
    $img.Dispose()

    $finalSize = [math]::Round((Get-Item $destPath).Length / 1024)
    Write-Host "OK: expo-roma-2030-malika-durdust.jpg ($newW x $newH, ${finalSize}KB)"
} catch {
    Write-Host "FAIL: $($_.Exception.Message)"
}
