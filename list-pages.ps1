$root = 'C:\Users\vitto\cristiantaraborrelli.github.io'
$out = New-Object System.Collections.ArrayList
$items = Get-ChildItem -Path $root -Filter '*.html' -Recurse -ErrorAction SilentlyContinue
foreach ($item in $items) {
    $full = $item.FullName
    if (($full.IndexOf('worktrees') -eq -1) -and ($full.IndexOf('\.git\') -eq -1)) {
        $rel = $full.Substring($root.Length + 1)
        [void]$out.Add($rel)
    }
}
$sorted = $out | Sort-Object
$sorted | Out-File "$root\pages-list.txt" -Encoding UTF8
Write-Host "Done: $($sorted.Count) pages"
