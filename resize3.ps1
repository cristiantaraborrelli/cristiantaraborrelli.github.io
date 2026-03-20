Add-Type -AssemblyName System.Drawing
$pairs = @(
    @{ Src='P:\FOTO SPETTACOLI\FOTO LAVORI\TURANDOT\TallaScala_Turandot2010_01aa.jpg'; Dst='C:\Users\vitto\cristiantaraborrelli.github.io\images\turandot-scene-06.jpg' },
    @{ Src='P:\FOTO SPETTACOLI\FOTO LAVORI\TURANDOT\TallaScala_Turandot2010_03aa.jpg'; Dst='C:\Users\vitto\cristiantaraborrelli.github.io\images\turandot-costume-06.jpg' }
)
foreach ($p in $pairs) {
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
