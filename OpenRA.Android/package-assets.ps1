$ErrorActionPreference = "Stop"
$dest = "OpenRA.Android/assets/openra-data.zip"
New-Item -ItemType Directory -Force -Path "OpenRA.Android/assets" | Out-Null
if (Test-Path $dest) { Remove-Item $dest }

# Ensure bundled Red Alert game content is present in assets
$raContentDest = "OpenRA.Android/assets/ra-content.zip"
if (-not (Test-Path $raContentDest)) {
    if (Test-Path "ra-quickinstall.zip") {
        Write-Host "Copying ra-quickinstall.zip to $raContentDest..."
        Copy-Item "ra-quickinstall.zip" $raContentDest
    } else {
        Write-Host "Downloading ra-quickinstall.zip for bundled content..."
        Invoke-WebRequest -Uri "https://openra.ppmsite.com/ra-quickinstall.zip" -OutFile $raContentDest
    }
}

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
