$basePath = "P:\FOTO SPETTACOLI\FOTO LAVORI"
$folders = @("MACBETH FOTO","DON CARLOS","ELISIR","LUISA MILLER","I DUE FOSCARI","LA BELLE HELENE","IL COLORE DEL SOLE","LA SONNAMBULA","FIGARO","ON NE PAIE PAS","KURTAG","PAGLIACCI","ANGELICA CUNTA","LA JURA","MUNCHAUSEN FOTO","PIETRA DEL PARAGONE","AMWEY","IVECO","NIDUS","MODA E MODI","BALANCE","EXPO2030","ITALIA IN MINIATURA","OPERA NATALE","VIDEOMAPPING OPERA ROMA")

foreach ($folder in $folders) {
    $path = Join-Path $basePath $folder
    if (Test-Path $path) {
        $images = Get-ChildItem $path -Recurse -Include *.jpg,*.jpeg,*.png -File
        $subfolders = Get-ChildItem $path -Directory -Recurse | Select-Object -ExpandProperty Name
        Write-Host "=== $folder ==="
        Write-Host "  Images: $($images.Count)"
        Write-Host "  Total size: $([math]::Round(($images | Measure-Object Length -Sum).Sum / 1MB, 1)) MB"
        if ($subfolders) { Write-Host "  Subfolders: $($subfolders -join ', ')" }
        Write-Host ""
    } else {
        Write-Host "=== $folder === NOT FOUND"
        Write-Host ""
    }
}
