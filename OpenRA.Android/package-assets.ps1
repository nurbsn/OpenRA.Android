$ErrorActionPreference = "Stop"

$scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if ([string]::IsNullOrWhiteSpace($scriptDir)) { $scriptDir = $PWD.Path }

# Identify repo root (parent of OpenRA.Android directory, or current directory if already in repo root)
if (Test-Path (Join-Path $scriptDir "..\OpenRA.Android")) {
    $repoRoot = [System.IO.Path]::GetFullPath((Join-Path $scriptDir ".."))
} elseif (Test-Path (Join-Path $scriptDir "OpenRA.Android")) {
    $repoRoot = [System.IO.Path]::GetFullPath($scriptDir)
} else {
    $repoRoot = [System.IO.Path]::GetFullPath($PWD.Path)
}

# Crucial: synchronize .NET current directory with repoRoot so BCL methods use the right directory
[System.IO.Directory]::SetCurrentDirectory($repoRoot)

$assetsDir = Join-Path $repoRoot "OpenRA.Android\assets"
if (-not [System.IO.Directory]::Exists($assetsDir)) {
    [System.IO.Directory]::CreateDirectory($assetsDir) | Out-Null
}

$dest = Join-Path $assetsDir "openra-data.zip"
if (Test-Path $dest) { Remove-Item $dest -Force }

# Ensure bundled Red Alert game content is present in assets
$raContentDest = Join-Path $assetsDir "ra-content.zip"
$raQuickInstall = Join-Path $repoRoot "ra-quickinstall.zip"
if (-not (Test-Path $raContentDest)) {
    if (Test-Path $raQuickInstall) {
        Write-Host "Copying $raQuickInstall to $raContentDest..."
        Copy-Item $raQuickInstall $raContentDest
    } else {
        Write-Host "Downloading ra-quickinstall.zip for bundled content..."
        Invoke-WebRequest -Uri "https://openra.ppmsite.com/ra-quickinstall.zip" -OutFile $raContentDest
    }
}

Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

Write-Host "Creating $dest..."
$zip = [System.IO.Compression.ZipFile]::Open($dest, [System.IO.Compression.ZipArchiveMode]::Create)

$searchDirs = @("mods", "glsl") | ForEach-Object { Join-Path $repoRoot $_ } | Where-Object { Test-Path $_ }
$files = Get-ChildItem -Path $searchDirs -Recurse -File
$prefix = if ($repoRoot.EndsWith("\") -or $repoRoot.EndsWith("/")) { $repoRoot } else { $repoRoot + "\" }
$count = 0
foreach ($f in $files) {
    if ($f.FullName.StartsWith($prefix, [System.StringComparison]::OrdinalIgnoreCase)) {
        $entryName = $f.FullName.Substring($prefix.Length).Replace('\', '/')
    } else {
        $entryName = $f.Name
    }
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $f.FullName, $entryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    $count++
    if ($count % 500 -eq 0) {
        Write-Host "Compressed $count files..."
    }
}

$rootFiles = @("global mix database.dat", "VERSION", "AUTHORS")
foreach ($rf in $rootFiles) {
    $fullRf = Join-Path $repoRoot $rf
    if (Test-Path $fullRf) {
        [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $fullRf, $rf, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
    }
}

$zip.Dispose()
Write-Host "Done! Total compressed files: $count"
Get-Item $dest | Select-Object Name, Length
