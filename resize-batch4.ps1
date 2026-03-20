Add-Type -AssemblyName System.Drawing
$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$dstBase = "C:\Users\vitto\cristiantaraborrelli.github.io\images"

# LA JURA - select 8 from 35 photos
$juraPath = "$basePath\LA JURA"
$juraFiles = Get-ChildItem $juraPath -Filter *.jpg | Sort-Object Name
$juraSelected = @($juraFiles[0], $juraFiles[2], $juraFiles[5], $juraFiles[8], $juraFiles[15], $juraFiles[20], $juraFiles[25], $juraFiles[30])
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

# AMWAY - select 8 from SELEZIONE folder
$amwayPath = "$basePath\AMWEY\FOTO\FOTO_FINAL\FOTO_FINAL\SELEZIONE"
$amwayFiles = Get-ChildItem $amwayPath -Filter *.jpg -File | Sort-Object Name
Write-Host "`nAmway SELEZIONE files: $($amwayFiles.Count)"
$amwaySelected = @($amwayFiles[0], $amwayFiles[1], $amwayFiles[2], $amwayFiles[3], $amwayFiles[5], $amwayFiles[7], $amwayFiles[9], $amwayFiles[11])
$idx = 1
foreach ($f in $amwaySelected) {
    if ($f -eq $null) { continue }
    $dst = "$dstBase\amway-0$idx.jpg"
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
    Write-Host "Created amway-0$idx.jpg ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
    $idx++
}

# IVECO - select 8 from different sections
$ivecoBase = "$basePath\IVECO\Foto - Fotosintesi Guido Suardi"
$ivecoPairs = @(
    @{ Src="$ivecoBase\1_ Show Room Walk In\IVECO-sc23__0048.jpg"; Dst="$dstBase\iveco-01.jpg" },
    @{ Src="$ivecoBase\1_ Show Room Walk In\IVECO-sc23__0253.jpg"; Dst="$dstBase\iveco-02.jpg" },
    @{ Src="$ivecoBase\1_ Show Room Walk In\IVECO-sc23__0293.jpg"; Dst="$dstBase\iveco-03.jpg" },
    @{ Src="$ivecoBase\2_ Plenary Session\Part 1\IVECO-sc23__0553.jpg"; Dst="$dstBase\iveco-04.jpg" },
    @{ Src="$ivecoBase\2_ Plenary Session\Part 1\IVECO-sc23__0720.jpg"; Dst="$dstBase\iveco-05.jpg" },
    @{ Src="$ivecoBase\2_ Plenary Session\Part 2\IVECO-sc23__1291.jpg"; Dst="$dstBase\iveco-06.jpg" },
    @{ Src="$ivecoBase\3_Gala Dinner\IVECO-sc23__1469.jpg"; Dst="$dstBase\iveco-07.jpg" },
    @{ Src="$ivecoBase\3_Gala Dinner\IVECO-sc23__1630.jpg"; Dst="$dstBase\iveco-08.jpg" }
)
foreach ($p in $ivecoPairs) {
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

# NIDO (6 photos)
$nidoPath = "$basePath\NIDUS"
$nidoFiles = Get-ChildItem $nidoPath -Filter *.jpg | Sort-Object Name
$nidoSelected = $nidoFiles | Select-Object -First 6
$idx = 1
foreach ($f in $nidoSelected) {
    $dst = "$dstBase\nido-0$idx.jpg"
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
    Write-Host "Created nido-0$idx.jpg ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
    $idx++
}

# MODA E MODI (8 photos)
$modaPath = "$basePath\MODA E MODI"
$modaFiles = Get-ChildItem $modaPath -Filter *.jpg | Sort-Object Name
$modaSelected = $modaFiles | Select-Object -First 8
$idx = 1
foreach ($f in $modaSelected) {
    $dst = "$dstBase\moda-modi-0$idx.jpg"
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
    Write-Host "Created moda-modi-0$idx.jpg ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
    $idx++
}

# OPERA NATALE (8 photos)
$operaNatalePath = "$basePath\OPERA NATALE"
$operaFiles = Get-ChildItem $operaNatalePath -Recurse -Filter *.jpg | Sort-Object Length -Descending
$operaSelected = $operaFiles | Select-Object -First 8
$idx = 1
foreach ($f in $operaSelected) {
    $dst = "$dstBase\opera-natale-0$idx.jpg"
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
    Write-Host "Created opera-natale-0$idx.jpg ${newW}x${newH} - $([math]::Round($newSize/1024))KB"
    $idx++
}
