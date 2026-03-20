Add-Type -AssemblyName System.Drawing
$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$dstBase = "C:\Users\vitto\cristiantaraborrelli.github.io\images"

# LA JURA - recurse to find files
$juraPath = "$basePath\LA JURA"
$juraFiles = Get-ChildItem $juraPath -Recurse -Filter *.jpg | Sort-Object Name
Write-Host "La Jura files found: $($juraFiles.Count)"
# Select 8 evenly spaced
$step = [math]::Floor($juraFiles.Count / 8)
$juraSelected = @()
for ($i = 0; $i -lt 8; $i++) {
    $juraSelected += $juraFiles[$i * $step]
}
$idx = 1
foreach ($f in $juraSelected) {
    if ($f -eq $null) { continue }
    $dst = "$dstBase\la-jura-0$idx.jpg"
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
    Write-Host "Created la-jura-0$idx.jpg ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
    $idx++
}

# Fix missing Iveco photos - use different source files
$ivecoBase = "$basePath\IVECO\Foto - Fotosintesi Guido Suardi"
$ivecoPairs = @(
    @{ Src="$ivecoBase\2_ Plenary Session\Part 1\IVECO-sc23__0547.jpg"; Dst="$dstBase\iveco-04.jpg" },
    @{ Src="$ivecoBase\2_ Plenary Session\Part 1\IVECO-sc23__0714.jpg"; Dst="$dstBase\iveco-05.jpg" }
)
foreach ($p in $ivecoPairs) {
    if (-not (Test-Path $p.Src)) {
        # Try to find any file in that folder
        $folder = Split-Path $p.Src -Parent
        $fallback = Get-ChildItem $folder -Filter *.jpg | Select-Object -First 1
        if ($fallback) {
            $p.Src = $fallback.FullName
            Write-Host "Using fallback: $($fallback.Name)"
        } else {
            Write-Host "SKIP (not found): $($p.Src | Split-Path -Leaf)"
            continue
        }
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
