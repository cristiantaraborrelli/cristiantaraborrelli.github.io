Get-ChildItem 'P:\FOTO SPETTACOLI\FOTO LAVORI\EXPO2030\ROME\NEW SITE' | ForEach-Object {
    $sizeKB = [math]::Round($_.Length/1024)
    Write-Host "$($_.Name) — $sizeKB KB"
}
Write-Host "`n--- PARENT FOLDER ---"
Get-ChildItem 'P:\FOTO SPETTACOLI\FOTO LAVORI\EXPO2030\ROME' -File | ForEach-Object {
    $sizeKB = [math]::Round($_.Length/1024)
    Write-Host "$($_.Name) — $sizeKB KB"
}
