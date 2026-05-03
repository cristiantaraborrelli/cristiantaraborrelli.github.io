Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = "Continue"

$dl = @(
    @{ url = "https://upload.wikimedia.org/wikipedia/commons/a/a9/Abbagnato_pech.jpg"; out = "expo-roma-2030-cast-abbagnato.jpg" },
    @{ url = "https://upload.wikimedia.org/wikipedia/commons/1/16/Dardust_live_at_Auditorium_di_Milano%2C_Milan_-_March_13th%2C_2023_%28230027%29.jpg"; out = "expo-roma-2030-cast-dardust.jpg" },
    @{ url = "https://upload.wikimedia.org/wikipedia/commons/a/ab/Malika_Ayane_al_Festival_di_Sanremo_2026_%28headshot%29.jpg"; out = "expo-roma-2030-cast-malika.jpg" }
)

$tmp = "$env:TEMP\expo-cast"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$dest = "C:\Users\vitto\cristiantaraborrelli.github.io\images"
$maxDim = 1200; $quality = 85

$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)

# Wikipedia richiede User-Agent
$ua = "CTSStudioBot/1.0 (https://www.cristiantaraborrellistudio.net; contact@cristiantaraborrellistudio.net)"

foreach ($item in $dl) {
    $u = $item.url
    $name = $item.out
    $tmpFile = Join-Path $tmp $name
    try {
        Invoke-WebRequest -Uri $u -OutFile $tmpFile -UseBasicParsing -UserAgent $ua -ErrorAction Stop
        Write-Host "Downloaded: $name"
    } catch {
        Write-Host "FAILED: $u - $_"
        continue
    }

    $out = Join-Path $dest $name
    try {
        $img = [System.Drawing.Image]::FromFile($tmpFile)
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
        Write-Host ("OK: {0}  {1}x{2}  {3:N0} KB" -f $name, $newW, $newH, $sz)
    } catch {
        Write-Host "RESIZE FAILED: $name - $_"
    }
}
Write-Host "Done."
