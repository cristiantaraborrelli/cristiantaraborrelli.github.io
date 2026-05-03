Add-Type -AssemblyName System.Drawing
$ErrorActionPreference = "Continue"

$dl = @(
    @{ url = "https://upload.wikimedia.org/wikipedia/commons/a/a5/Vittoria_Puccini_at_81st_Venice_International_Film_Festival_%28cropped%29.jpg"; out = "puccini.jpg" },
    @{ url = "https://upload.wikimedia.org/wikipedia/commons/6/61/Stefano_Mancuso_Laterza.png"; out = "mancuso.jpg" },
    @{ url = "https://upload.wikimedia.org/wikipedia/commons/3/30/Ludovica_Martino_D%C3%A9luge.png"; out = "martino.jpg" }
)

$tmp = "$env:TEMP\cast2024"
New-Item -ItemType Directory -Force -Path $tmp | Out-Null
$dest = "C:\Users\vitto\cristiantaraborrelli.github.io\images\protagonists"
$maxDim = 1200; $quality = 85
$jpegEncoder = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq "image/jpeg" }
$encoderParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
$encoderParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [int64]$quality)
$ua = "CTSStudioBot/1.0 (https://www.cristiantaraborrellistudio.net)"

foreach ($item in $dl) {
    $tmpFile = Join-Path $tmp $item.out
    try {
        Invoke-WebRequest -Uri $item.url -OutFile $tmpFile -UseBasicParsing -UserAgent $ua -ErrorAction Stop
        Write-Host ("Downloaded: " + $item.out)
    } catch {
        Write-Host ("FAILED: " + $item.url + " - " + $_)
        continue
    }
    $out = Join-Path $dest $item.out
    try {
        $img = [System.Drawing.Image]::FromFile($tmpFile)
        $w = $img.Width; $h = $img.Height
        if ($w -gt $h) { if ($w -gt $maxDim) { $newW = $maxDim; $newH = [int]($h * $maxDim / $w) } else { $newW = $w; $newH = $h } } else { if ($h -gt $maxDim) { $newH = $maxDim; $newW = [int]($w * $maxDim / $h) } else { $newW = $w; $newH = $h } }
        $bmp = New-Object System.Drawing.Bitmap $newW, $newH
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.DrawImage($img, 0, 0, $newW, $newH)
        $bmp.Save($out, $jpegEncoder, $encoderParams)
        $g.Dispose(); $bmp.Dispose(); $img.Dispose()
        $sz = (Get-Item $out).Length / 1KB
        Write-Host ("OK: " + $item.out + " " + $newW + "x" + $newH + ("  {0:N0} KB" -f $sz))
    } catch {
        Write-Host ("RESIZE FAILED: " + $item.out + " - " + $_)
    }
}
