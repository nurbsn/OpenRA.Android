$ErrorActionPreference = "Stop"
$dest = "OpenRA.Android/assets/openra-data.zip"
New-Item -ItemType Directory -Force -Path "OpenRA.Android/assets" | Out-Null
if (Test-Path $dest) { Remove-Item $dest }

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

Write-Host "Creating $dest..."
$zip = [System.IO.Compression.ZipFile]::Open($dest, [System.IO.Compression.ZipArchiveMode]::Create)

$files = Get-ChildItem -Path @("mods", "glsl") -Recurse -File
$count = 0
foreach ($f in $files) {
    $rel = Resolve-Path -Relative $f.FullName
    $entryName = $rel.TrimStart('.').TrimStart('\').TrimStart('/').Replace('\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $f.FullName, $entryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    $count++
    if ($count % 500 -eq 0) {
        Write-Host "Compressed $count files..."
    }
}

$rootFiles = @("global mix database.dat", "VERSION", "AUTHORS")
foreach ($rf in $rootFiles) {
    if (Test-Path $rf) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, (Resolve-Path $rf).Path, $rf, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
}

$zip.Dispose()
Write-Host "Done! Total compressed files: $count"
Get-Item $dest | Select-Object Name, Length
