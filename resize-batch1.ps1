Add-Type -AssemblyName System.Drawing
$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$dstBase = "C:\Users\vitto\cristiantaraborrelli.github.io\images"

$pairs = @(
    # === MACBETH (4 photos) ===
    @{ Src="$basePath\MACBETH FOTO\macbeth-2-1400x574.jpg"; Dst="$dstBase\macbeth-01.jpg" },
    @{ Src="$basePath\MACBETH FOTO\macbeth-3-1400x574.jpg"; Dst="$dstBase\macbeth-02.jpg" },
    @{ Src="$basePath\MACBETH FOTO\macbeth-sc4.jpg"; Dst="$dstBase\macbeth-03.jpg" },
    @{ Src="$basePath\MACBETH FOTO\securedownload.jpg"; Dst="$dstBase\macbeth-04.jpg" },

    # === DON CARLOS (6 photos) ===
    @{ Src="$basePath\DON CARLOS\1494060333_975e9242b23b062283265bbfcbd70117_1.jpg"; Dst="$dstBase\don-carlos-01.jpg" },
    @{ Src="$basePath\DON CARLOS\5.jpg"; Dst="$dstBase\don-carlos-02.jpg" },
    @{ Src="$basePath\DON CARLOS\6.jpg"; Dst="$dstBase\don-carlos-03.jpg" },
    @{ Src="$basePath\DON CARLOS\7.jpg"; Dst="$dstBase\don-carlos-04.jpg" },
    @{ Src="$basePath\DON CARLOS\don_carlo3.jpg"; Dst="$dstBase\don-carlos-05.jpg" },
    @{ Src="$basePath\DON CARLOS\3.jpg"; Dst="$dstBase\don-carlos-06.jpg" },

    # === ELISIR D'AMORE (8 photos) ===
    @{ Src="$basePath\ELISIR\Elixir-_1146_08.jpg"; Dst="$dstBase\elisir-01.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_1357_copie.jpg"; Dst="$dstBase\elisir-02.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_1522_copie.jpg"; Dst="$dstBase\elisir-03.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_7739.jpg"; Dst="$dstBase\elisir-04.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_8211_copie.jpg"; Dst="$dstBase\elisir-05.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_8284_12.jpg"; Dst="$dstBase\elisir-06.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_8322.jpg"; Dst="$dstBase\elisir-07.jpg" },
    @{ Src="$basePath\ELISIR\Elixir-_8345_copie.jpg"; Dst="$dstBase\elisir-08.jpg" },

    # === LA BELLE HELENE (6 photos) ===
    @{ Src="$basePath\LA BELLE HELENE\14069767.jpg"; Dst="$dstBase\belle-helene-01.jpg" },
    @{ Src="$basePath\LA BELLE HELENE\bellehelene0.jpg"; Dst="$dstBase\belle-helene-02.jpg" },
    @{ Src="$basePath\LA BELLE HELENE\bellehelene1.jpg"; Dst="$dstBase\belle-helene-03.jpg" },
    @{ Src="$basePath\LA BELLE HELENE\bellehelene2.jpg"; Dst="$dstBase\belle-helene-04.jpg" },
    @{ Src="$basePath\LA BELLE HELENE\La-belle-Helene-Offenbach-paris-2015.jpg"; Dst="$dstBase\belle-helene-05.jpg" },
    @{ Src="$basePath\LA BELLE HELENE\600x337_fotorcreated_4.jpg"; Dst="$dstBase\belle-helene-06.jpg" },

    # === I DUE FOSCARI (6 photos) ===
    @{ Src="$basePath\I DUE FOSCARI\D59P9129N-1024x682.jpg"; Dst="$dstBase\due-foscari-01.jpg" },
    @{ Src="$basePath\I DUE FOSCARI\D59P9187N-1024x682.jpg"; Dst="$dstBase\due-foscari-02.jpg" },
    @{ Src="$basePath\I DUE FOSCARI\D59P9630N-1024x682.jpg"; Dst="$dstBase\due-foscari-03.jpg" },
    @{ Src="$basePath\I DUE FOSCARI\D59P9636N-1024x682.jpg"; Dst="$dstBase\due-foscari-04.jpg" },
    @{ Src="$basePath\I DUE FOSCARI\D59P9872N-1024x682.jpg"; Dst="$dstBase\due-foscari-05.jpg" },
    @{ Src="$basePath\I DUE FOSCARI\10304871_653103531438920_5896360469267400103_n.jpg"; Dst="$dstBase\due-foscari-06.jpg" }
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
