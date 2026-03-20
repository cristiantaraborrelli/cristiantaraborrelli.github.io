Add-Type -AssemblyName System.Drawing
$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$dstBase = "C:\Users\vitto\cristiantaraborrelli.github.io\images"

$pairs = @(
    # === LA SONNAMBULA (8 photos - mix Roma press + Bari) ===
    @{ Src="$basePath\LA SONNAMBULA\PRESS ROMA\s1_1.jpg"; Dst="$dstBase\sonnambula-01.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\PRESS ROMA\e9db40b3f044f0554a8bd4a6fa542ee7_XL - Copia.jpg"; Dst="$dstBase\sonnambula-02.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\PRESS ROMA\Sonnambula_Jessica Pratt (Amina), Juam Francisco Gatell (Elvino)_ph Yasuko Kageyama-Opera Roma 2017-18_5104 WEB.jpg"; Dst="$dstBase\sonnambula-03.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\PRESS ROMA\Sonnambula_2017-18_2400x1350-3-1024x577.jpg"; Dst="$dstBase\sonnambula-04.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\PRESS ROMA\teatro_dellopera_di_roma_la_sonnambula_3.jpg"; Dst="$dstBase\sonnambula-05.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\PRESS ROMA\Sonnambula-ph-Yasuko-Kageyama-Opera-Roma-2017-18_5521-low.jpg"; Dst="$dstBase\sonnambula-06.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\BARI\DSC_1334.jpg"; Dst="$dstBase\sonnambula-07.jpg" },
    @{ Src="$basePath\LA SONNAMBULA\BARI\DSC_1442.jpg"; Dst="$dstBase\sonnambula-08.jpg" },

    # === IL COLORE DEL SOLE (8 photos - press/stampa) ===
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\2017-10-27_IlColoreDelSole_xPress, MODENA\IlColoreDelSole_019.jpg"; Dst="$dstBase\colore-sole-01.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\2017-10-27_IlColoreDelSole_xPress, MODENA\IlColoreDelSole_098.jpg"; Dst="$dstBase\colore-sole-02.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\2017-10-27_IlColoreDelSole_xPress, MODENA\IlColoreDelSole_159.jpg"; Dst="$dstBase\colore-sole-03.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\2017-10-27_IlColoreDelSole_xPress, MODENA\IlColoreDelSole_200.jpg"; Dst="$dstBase\colore-sole-04.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\2017-10-27_IlColoreDelSole_xPress, MODENA\IlColoreDelSole_273.jpg"; Dst="$dstBase\colore-sole-05.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\2017-10-27_IlColoreDelSole_xPress, MODENA\IlColoreDelSole_327.jpg"; Dst="$dstBase\colore-sole-06.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\foto INVITO ALL'OPERA\ColoreDelSole_InvitoOpera_004.jpg"; Dst="$dstBase\colore-sole-07.jpg" },
    @{ Src="$basePath\IL COLORE DEL SOLE\rassegna stampa\Modena, IL COLORE DEL SOLE\Modena, IL COLORE DEL SOLE\foto INVITO ALL'OPERA\ColoreDelSole_InvitoOpera_017.jpg"; Dst="$dstBase\colore-sole-08.jpg" },

    # === LE MARIAGE DE FIGARO (8 photos - selected from FOTO STAMPA) ===
    @{ Src="$basePath\FIGARO\149181-figaro-13-8894.jpg"; Dst="$dstBase\figaro-01.jpg" },
    @{ Src="$basePath\FIGARO\149181-figaro-fil-1-0285.jpg"; Dst="$dstBase\figaro-02.jpg" },
    @{ Src="$basePath\FIGARO\149181-figaro-fil-1-0351.jpg"; Dst="$dstBase\figaro-03.jpg" },
    @{ Src="$basePath\FIGARO\149181-figaro-fil-1-0646.jpg"; Dst="$dstBase\figaro-04.jpg" },
    @{ Src="$basePath\FIGARO\FIGARO_GINEVRA\FOTO STAMPA\Figaro fil1 selec A4\Figaro fil 1-0064.jpg"; Dst="$dstBase\figaro-05.jpg" },
    @{ Src="$basePath\FIGARO\FIGARO_GINEVRA\FOTO STAMPA\Figaro fil1 selec A4\Figaro fil 1-0129.jpg"; Dst="$dstBase\figaro-06.jpg" },
    @{ Src="$basePath\FIGARO\FIGARO_GINEVRA\FOTO STAMPA\Figaro fil1 selec A4\Figaro fil 1-0325.jpg"; Dst="$dstBase\figaro-07.jpg" },
    @{ Src="$basePath\FIGARO\FIGARO_GINEVRA\FOTO STAMPA\Figaro fil1 selec A4\Figaro fil 1-0559.jpg"; Dst="$dstBase\figaro-08.jpg" },

    # === KURTAG (8 photos) ===
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0002.jpg"; Dst="$dstBase\kurtag-01.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0008.jpg"; Dst="$dstBase\kurtag-02.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0018.jpg"; Dst="$dstBase\kurtag-03.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0030.jpg"; Dst="$dstBase\kurtag-04.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0040.jpg"; Dst="$dstBase\kurtag-05.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0046.jpg"; Dst="$dstBase\kurtag-06.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0067.jpg"; Dst="$dstBase\kurtag-07.jpg" },
    @{ Src="$basePath\KURTAG\foto spettacolo\MAC_0072.jpg"; Dst="$dstBase\kurtag-08.jpg" },

    # === ON NE PAIE PAS (6 photos) ===
    @{ Src="$basePath\ON NE PAIE PAS\©CaroleParodi-6565-X2.jpg"; Dst="$dstBase\on-ne-paie-pas-01.jpg" },
    @{ Src="$basePath\ON NE PAIE PAS\©CaroleParodi-6657-X2.jpg"; Dst="$dstBase\on-ne-paie-pas-02.jpg" },
    @{ Src="$basePath\ON NE PAIE PAS\©CaroleParodi-6678-X2.jpg"; Dst="$dstBase\on-ne-paie-pas-03.jpg" },
    @{ Src="$basePath\ON NE PAIE PAS\©CaroleParodi-7923-XL.jpg"; Dst="$dstBase\on-ne-paie-pas-04.jpg" },
    @{ Src="$basePath\ON NE PAIE PAS\©CaroleParodi-7929-X2.jpg"; Dst="$dstBase\on-ne-paie-pas-05.jpg" },
    @{ Src="$basePath\ON NE PAIE PAS\©CaroleParodi-8010-X2.jpg"; Dst="$dstBase\on-ne-paie-pas-06.jpg" }
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
