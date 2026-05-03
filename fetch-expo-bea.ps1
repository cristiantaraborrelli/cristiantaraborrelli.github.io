Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = "Continue"

$urls = @(
    "https://besteventawards.it/wp-content/uploads/2023/11/CandidaturaperRomaExpo2030-Humanlands_eventoImgEvento1-5.jpg",
    "https://besteventawards.it/wp-content/uploads/2023/11/CandidaturaperRomaExpo2030-Humanlands_eventoImgEvento2-3.jpg",
    "https://besteventawards.it/wp-content/uploads/2023/11/CandidaturaperRomaExpo2030-Humanlands_eventoImgEvento3-3.jpg",
    "https://besteventawards.it/wp-content/uploads/2023/11/CandidaturaperRomaExpo2030-Humanlands_eventoImgEvento4-2.jpg",
    "https://besteventawards.it/wp-content/uploads/2023/11/CandidaturaperRomaExpo2030-Humanlands_eventoImgEvento5-3.jpg"
)

$tmp = "$env:TEMP\bea-expo"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$dest = "C:\Users\vitto\cristiantaraborrelli.github.io\images"
$maxDim = 1920; $quality = 82

$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

for ($i = 0; $i -lt $urls.Count; $i++) {
    $url = $urls[$i]
    $n = "{0:D2}" -f ($i + 1)
    $dl = Join-Path $tmp "src-$n.jpg"
    try {
        Invoke-WebRequest -Uri $url -OutFile $dl -UseBasicParsing -ErrorAction Stop
        Write-Host "Downloaded: $url"
    } catch {
        Write-Host "FAILED: $url - $_"
        continue
    }

    $out = Join-Path $dest "expo-roma-2030-bea-$n.jpg"
    $img = [System.Drawing.Image]::FromFile($dl)
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
    $g.DrawImage($img, 0, 0, $newW, $newH)
    $bmp.Save($out, $jpegEncoder, $encoderParams)
    $g.Dispose(); $bmp.Dispose(); $img.Dispose()
    $sz = (Get-Item $out).Length / 1KB
    Write-Host ("OK: expo-roma-2030-bea-{0}.jpg  {1}x{2}  {3:N0} KB" -f $n, $newW, $newH, $sz)
}
Write-Host "Done."
