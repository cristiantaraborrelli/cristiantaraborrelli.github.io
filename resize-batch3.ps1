Add-Type -AssemblyName System.Drawing
$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$dstBase = "C:\Users\vitto\cristiantaraborrelli.github.io\images"

$pairs = @(
    # === ANGELICA CUNTA (6 photos) ===
    @{ Src="$basePath\ANGELICA CUNTA\19935_ca_object_representations_media_4512_large.jpg"; Dst="$dstBase\angelica-cunta-01.jpg" },
    @{ Src="$basePath\ANGELICA CUNTA\30936_ca_object_representations_media_4513_large.jpg"; Dst="$dstBase\angelica-cunta-02.jpg" },
    @{ Src="$basePath\ANGELICA CUNTA\33856_ca_object_representations_media_4509_large.jpg"; Dst="$dstBase\angelica-cunta-03.jpg" },
    @{ Src="$basePath\ANGELICA CUNTA\55221_ca_object_representations_media_4508_large.jpg"; Dst="$dstBase\angelica-cunta-04.jpg" },
    @{ Src="$basePath\ANGELICA CUNTA\72807_ca_object_representations_media_4511_large.jpg"; Dst="$dstBase\angelica-cunta-05.jpg" },
    @{ Src="$basePath\ANGELICA CUNTA\89140_ca_object_representations_media_4510_large.jpg"; Dst="$dstBase\angelica-cunta-06.jpg" },

    # === MUNCHHAUSEN (4 photos) ===
    @{ Src="$basePath\MUNCHAUSEN FOTO\AMSTRAMGRAM\09-23Mu0851.jpg"; Dst="$dstBase\munchhausen-01.jpg" },
    @{ Src="$basePath\MUNCHAUSEN FOTO\AMSTRAMGRAM\09-23Mu2591.jpg"; Dst="$dstBase\munchhausen-02.jpg" },
    @{ Src="$basePath\MUNCHAUSEN FOTO\AMSTRAMGRAM\09-24Mu119.jpg"; Dst="$dstBase\munchhausen-03.jpg" },
    @{ Src="$basePath\MUNCHAUSEN FOTO\AMSTRAMGRAM\09-24Mu319.jpg"; Dst="$dstBase\munchhausen-04.jpg" },

    # === PIETRA DEL PARAGONE (8 photos) ===
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8403.jpg"; Dst="$dstBase\pietra-paragone-01.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8513.jpg"; Dst="$dstBase\pietra-paragone-02.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8588.jpg"; Dst="$dstBase\pietra-paragone-03.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8613.jpg"; Dst="$dstBase\pietra-paragone-04.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8661.jpg"; Dst="$dstBase\pietra-paragone-05.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8798.jpg"; Dst="$dstBase\pietra-paragone-06.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\wetransfer-af075c\_G5B8833.jpg"; Dst="$dstBase\pietra-paragone-07.jpg" },
    @{ Src="$basePath\PIETRA DEL PARAGONE\LA PIETRA DEL PARGONE\lirica.jpg"; Dst="$dstBase\pietra-paragone-08.jpg" }
)

foreach ($p in $pairs) {
    if (-not (Test-Path $p.Src)) {
        Write-Host "SKIP (not found): $($p.Src | Split-Path -Leaf)"
        continue
    }
    $img = [System.Drawing.Image]::FromFile($p.Src)
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
    $bmp.Save($p.Dst, $enc, $ep)
    $bmp.Dispose()
    $newSize = (Get-Item $p.Dst).Length
    Write-Host "Created $($p.Dst | Split-Path -Leaf) ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
}
