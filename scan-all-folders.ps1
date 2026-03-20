$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$folders = @(
    "MACBETH FOTO",
    "DON CARLOS",
    "ELISIR",
    "I DUE FOSCARI",
    "LA BELLE HELENE",
    "IL COLORE DEL SOLE",
    "LA SONNAMBULA",
    "FIGARO",
    "ON NE PAIE PAS",
    "KURTAG",
    "ANGELICA CUNTA",
    "LA JURA",
    "MUNCHAUSEN FOTO",
    "PIETRA DEL PARAGONE",
    "AMWEY",
    "IVECO",
    "NIDUS",
    "MODA E MODI",
    "OPERA NATALE",
    "BALANCE",
    "EXPO2030",
    "VIDEOMAPPING OPERA ROMA"
)

foreach ($folder in $folders) {
    $path = Join-Path $basePath $folder
    if (Test-Path $path) {
        Write-Host "=== $folder ==="
        $images = Get-ChildItem $path -Recurse -Include *.jpg,*.jpeg,*.png -File | Sort-Object Name
        foreach ($img in $images) {
            $relPath = $img.FullName.Replace($path, "").TrimStart("\")
            $sizeKB = [math]::Round($img.Length / 1KB)
            Write-Host "  $relPath - ${sizeKB}KB"
        }
        Write-Host ""
    } else {
        Write-Host "=== $folder === NOT FOUND"
        Write-Host ""
    }
}
