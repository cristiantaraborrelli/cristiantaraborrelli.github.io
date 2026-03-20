Add-Type -AssemblyName System.Drawing

$destDir = "C:\Users\vitto\cristiantaraborrelli.github.io\images"
$maxDim = 1600
$quality = 80

function Resize-Image {
    param([string]$srcPath, [string]$destName)

    try {
        $img = [System.Drawing.Image]::FromFile($srcPath)
        $w = $img.Width
        $h = $img.Height

        if ($w -gt $maxDim -or $h -gt $maxDim) {
            if ($w -ge $h) {
                $newW = $maxDim
                $newH = [math]::Round($h * $maxDim / $w)
            } else {
                $newH = $maxDim
                $newW = [math]::Round($w * $maxDim / $h)
            }
        } else {
            $newW = $w
            $newH = $h
        }

        $bmp = New-Object System.Drawing.Bitmap($newW, $newH)
        $g = [System.Drawing.Graphics]::FromImage($bmp)
        $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
        $g.SmoothingMode = [System.Drawing.Drawing2D.SmoothingMode]::HighQuality
        $g.DrawImage($img, 0, 0, $newW, $newH)

        $codec = [System.Drawing.Imaging.ImageCodecInfo]::GetImageEncoders() | Where-Object { $_.MimeType -eq 'image/jpeg' }
        $encParams = New-Object System.Drawing.Imaging.EncoderParameters(1)
        $encParams.Param[0] = New-Object System.Drawing.Imaging.EncoderParameter([System.Drawing.Imaging.Encoder]::Quality, [long]$quality)

        $destPath = Join-Path $destDir $destName
        $bmp.Save($destPath, $codec, $encParams)

        $g.Dispose()
        $bmp.Dispose()
        $img.Dispose()

        $finalSize = [math]::Round((Get-Item $destPath).Length / 1024)
        Write-Host "OK: $destName ($newW x $newH, ${finalSize}KB)"
    } catch {
        Write-Host "FAIL: $destName - $($_.Exception.Message)"
    }
}

$src = 'P:\FOTO SPETTACOLI\FOTO LAVORI\EXPO2030\ROME\NEW SITE'
$srcParent = 'P:\FOTO SPETTACOLI\FOTO LAVORI\EXPO2030\ROME'

Resize-Image "$src\_O2I2885.jpg" "expo-roma-2030-malika.jpg"
Resize-Image "$src\_O2I2451.jpg" "expo-roma-2030-abbagnato.jpg"
Resize-Image "$src\Expo Roma 2030 (4) - Credits foto_ Luca Parisse per Filmmaster.jpeg" "expo-roma-2030-durdust.jpg"
Resize-Image "$src\Expo Roma 2030 (3) - Credits foto_ Luca Parisse per Filmmaster.jpeg" "expo-roma-2030-colosseum-drones.jpg"
Resize-Image "$src\IMG_2741.jpg" "expo-roma-2030-musicians-globe.jpg"
Resize-Image "$src\HUMANLAND_KEYART[1].jpg" "expo-roma-2030-keyart.jpg"
Resize-Image "$src\Unknown.png" "expo-roma-2030-aerial.jpg"
Resize-Image "$src\Unknown-3.png" "expo-roma-2030-blue-moon.jpg"
Resize-Image "$srcParent\Palco Expo 2030 Roma - Reduced.jpeg" "expo-roma-2030-stage.jpg"
Resize-Image "$src\WhatsApp Image 2023-04-27 at 20.30.06.jpeg" "expo-roma-2030-stage-day.jpg"
