# Prosty skrypt do budowania instalatora APK dla Androida (nOpenRA / Red Tide RTS)
param(
	[string]$Configuration = "Release",
	[switch]$Install,
	[switch]$SkipAssetPackaging
)

$ErrorActionPreference = "Stop"

$scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if ([string]::IsNullOrWhiteSpace($scriptDir)) { $scriptDir = $PWD.Path }
[System.IO.Directory]::SetCurrentDirectory($scriptDir)

Write-Host "=== Budowanie instalatora Android APK ($Configuration) ===" -ForegroundColor Cyan

# 1. Pakowanie zasobow gry (openra-data.zip) jesli brakuje lub na zadanie
$assetZip = Join-Path $scriptDir "OpenRA.Android\assets\openra-data.zip"
if (-not $SkipAssetPackaging -or -not (Test-Path $assetZip)) {
	Write-Host "`n1. Weryfikacja/pakowanie zasobow gry (openra-data.zip)..." -ForegroundColor Cyan
	$packageScript = Join-Path $scriptDir "OpenRA.Android\package-assets.ps1"
	& $packageScript
} else {
	Write-Host "`n1. Pomijanie pakowania zasobow (uzyto istniejacego openra-data.zip)..." -ForegroundColor Gray
}

# 2. Kompilacja do APK
Write-Host "`n2. Kompilacja projektu OpenRA.Android do pliku APK..." -ForegroundColor Cyan
$projectPath = Join-Path $scriptDir "OpenRA.Android\OpenRA.Android.csproj"

# Usuniecie atrybutow read-only z katalogu obj przed kompilacja
$objDir = Join-Path $scriptDir "OpenRA.Android\obj"
if (Test-Path $objDir) {
	cmd /c "attrib -r -s -h /s /d `"$objDir\*.*`" 2>nul"
}

dotnet publish "$projectPath" -f net10.0-android -c $Configuration `
	-p:AndroidPackageFormat=apk `
	/nr:false

if ($LASTEXITCODE -ne 0) {
	Write-Host "`nBLAD: Kompilacja APK nie powiodla sie!" -ForegroundColor Red
	exit $LASTEXITCODE
}

# 3. Wyszukanie wygenerowanego pliku APK
$searchPatterns = @(
	(Join-Path $scriptDir "bin\net10.0-android\publish\*.apk"),
	(Join-Path $scriptDir "bin\$Configuration\net10.0-android\publish\*.apk"),
	(Join-Path $scriptDir "bin\net10.0-android\*.apk"),
	(Join-Path $scriptDir "OpenRA.Android\bin\$Configuration\net10.0-android\*.apk")
)

$outputApk = $null
foreach ($pattern in $searchPatterns) {
	$found = Get-ChildItem -Path $pattern -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
	if ($found) {
		$outputApk = $found
		break
	}
}

if (-not $outputApk) {
	Write-Host "`nOstrzezenie: Nie odnaleziono wygenerowanego pliku APK w standardowych folderach bin." -ForegroundColor Yellow
	exit 1
}

$fileSizeMb = [math]::Round($outputApk.Length / (1024 * 1024), 2)
Write-Host "`n========================================================" -ForegroundColor Green
Write-Host "SUKCES! Gotowy plik APK:" -ForegroundColor Green
Write-Host "Sciezka: $($outputApk.FullName)" -ForegroundColor White
Write-Host "Rozmiar: $fileSizeMb MB" -ForegroundColor White
Write-Host "========================================================" -ForegroundColor Green

# 4. Opcjonalna automatyczna instalacja na urzadzeniu lub emulatorze
if ($Install) {
	Write-Host "`nInstalowanie APK na podlaczonym urzadzeniu Android..." -ForegroundColor Cyan
	$adbCandidates = @(
		"C:\Program Files\Google\Play Games Developer Emulator\current\emulator\adb.exe",
		"adb.exe"
	)
	$adbPath = $null
	foreach ($cand in $adbCandidates) {
		$c = Get-Command $cand -ErrorAction SilentlyContinue
		if ($c) { $adbPath = $c.Source; break }
		if (Test-Path $cand) { $adbPath = $cand; break }
	}

	if ($adbPath) {
		& $adbPath install -r $outputApk.FullName
		if ($LASTEXITCODE -eq 0) {
			Write-Host "Zainstalowano pomyslnie na urzadzeniu!" -ForegroundColor Green
		} else {
			Write-Host "Blad instalacji przez adb." -ForegroundColor Red
		}
	} else {
		Write-Host "Nie odnaleziono narzedzia adb do automatycznej instalacji." -ForegroundColor Yellow
	}
}
