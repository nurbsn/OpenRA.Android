# Skrypt do generowania produkcyjnej paczki Android App Bundle (.aab) dla Google Play Console (nOpenRA Mobile)
param(
	[string]$KeystoreFile = "nopenra-upload.keystore",
	[string]$KeyAlias = "nopenra",
	[string]$Password = "",
	[switch]$SkipAssetPackaging
)

$ErrorActionPreference = "Stop"

$scriptDir = if (-not [string]::IsNullOrWhiteSpace($PSScriptRoot)) { $PSScriptRoot } else { Split-Path -Parent $MyInvocation.MyCommand.Path }
if ([string]::IsNullOrWhiteSpace($scriptDir)) { $scriptDir = $PWD.Path }

$keystoreFullPath = if ([System.IO.Path]::IsPathRooted($KeystoreFile)) { $KeystoreFile } else { Join-Path $scriptDir $KeystoreFile }
$projectPath = Join-Path $scriptDir "OpenRA.Android\OpenRA.Android.csproj"

Write-Host "=== nOpenRA Mobile (eu.gfmm.nopenra) - Budowanie paczki Google Play (AAB) ===" -ForegroundColor Cyan

# Lokalizacja keytool (kompatybilna z roznymi wersjami JDK)
$keytoolCandidates = @(
	"C:\Program Files\Android\openjdk\jdk-21.0.8\bin\keytool.exe",
	"C:\Program Files (x86)\Android\openjdk\jdk-21.0.8\bin\keytool.exe",
	"C:\Program Files\Microsoft\jdk-21.0.5.11-hotspot\bin\keytool.exe"
)

$keytoolPath = ""
foreach ($candidate in $keytoolCandidates) {
	if (Test-Path $candidate) {
		$keytoolPath = $candidate
		break
	}
}

if ([string]::IsNullOrWhiteSpace($keytoolPath)) {
	$cmd = Get-Command "keytool.exe" -ErrorAction SilentlyContinue
	if ($cmd) {
		$keytoolPath = $cmd.Source
	}
}

if (-not (Test-Path $keystoreFullPath)) {
	Write-Host "`nNie znaleziono pliku klucza: $keystoreFullPath" -ForegroundColor Yellow
	Write-Host "Generowanie nowego klucza podpisu (Upload Keystore) dla eu.gfmm.nopenra..." -ForegroundColor Green

	if ([string]::IsNullOrWhiteSpace($Password)) {
		$secPwd = Read-Host -Prompt "Podaj bezpieczne haslo dla nowego klucza podpisu (min. 6 znakow)" -AsSecureString
		$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secPwd)
		$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
	}

	if ([string]::IsNullOrWhiteSpace($keytoolPath) -or (-not (Test-Path $keytoolPath))) {
		Write-Error "Nie znaleziono narzedzia keytool.exe. Upewnij sie, ze zainstalowano pakiet OpenJDK."
		exit 1
	}

	& $keytoolPath -genkeypair -v -keystore $keystoreFullPath -alias $KeyAlias -keyalg RSA -keysize 2048 -validity 10000 `
		-storepass $Password -keypass $Password -dname "CN=nOpenRA, O=gfmm, C=EU"

	Write-Host "Utworzono klucz: $keystoreFullPath (Alias: $KeyAlias)" -ForegroundColor Green
	Write-Host "UWAGA: Zachowaj ten plik i haslo w bezpiecznym miejscu! Bedzie potrzebny do kazdej kolejnej aktualizacji w Google Play." -ForegroundColor Red
}

if ([string]::IsNullOrWhiteSpace($Password)) {
	$secPwd = Read-Host -Prompt "Podaj haslo do magazynu kluczy $keystoreFullPath" -AsSecureString
	$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secPwd)
	$Password = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)
}

# Weryfikacja hasla do magazynu kluczy przed rozpoczeciem kompilacji
if (-not [string]::IsNullOrWhiteSpace($keytoolPath) -and (Test-Path $keytoolPath)) {
	Write-Host "`nWeryfikacja hasla do magazynu kluczy..." -ForegroundColor Cyan
	$verifyOutput = & $keytoolPath -list -keystore $keystoreFullPath -storepass $Password 2>&1
	if ($LASTEXITCODE -ne 0) {
		Write-Host "BLAD: Podane haslo do magazynu kluczy jest niepoprawne!" -ForegroundColor Red
		Write-Host "Upewnij sie, ze wpisujesz dokladnie to samo haslo, ktore zostalo uzyte przy tworzeniu pliku." -ForegroundColor Yellow
		exit 1
	}
	Write-Host "Haslo prawidlowe!" -ForegroundColor Green
}

# Pakowanie assetow (openra-data.zip)
$assetZip = Join-Path $scriptDir "OpenRA.Android\assets\openra-data.zip"
if (-not $SkipAssetPackaging -or -not (Test-Path $assetZip)) {
	Write-Host "`nAktualizacja paczki zasobow gry (openra-data.zip)..." -ForegroundColor Cyan
	$packageScript = Join-Path $scriptDir "OpenRA.Android\package-assets.ps1"
	& $packageScript
}

# Czyszczenie zablokowanych lub przestarzalych plikow obj i AAB
Write-Host "`nCzyszczenie tymczasowych plikow kompilacji..." -ForegroundColor Gray
$objDir = Join-Path $scriptDir "OpenRA.Android\obj"
if (Test-Path $objDir) {
	& attrib -r "$objDir\*.*" /s /d 2>$null
	Remove-Item -Path $objDir -Recurse -Force -ErrorAction SilentlyContinue
}

$binAndroidDir = Join-Path $scriptDir "bin\net10.0-android"
if (Test-Path $binAndroidDir) {
	Get-ChildItem -Path $binAndroidDir -Filter "*.aab" -Recurse -ErrorAction SilentlyContinue | Remove-Item -Force
}

Write-Host "`nKompilacja i publikacja do Android App Bundle (AAB)..." -ForegroundColor Cyan
Write-Host "Klucz: $keystoreFullPath" -ForegroundColor Gray
Write-Host "Alias: $KeyAlias" -ForegroundColor Gray

dotnet publish "$projectPath" -f net10.0-android -c Release `
	-p:AndroidPackageFormat=aab `
	-p:AndroidKeyStore=true `
	-p:AndroidSigningKeyStore="$keystoreFullPath" `
	-p:AndroidSigningKeyAlias=$KeyAlias `
	-p:AndroidSigningKeyPass=$Password `
	-p:AndroidSigningStorePass=$Password

$outputAab = Get-ChildItem -Path (Join-Path $scriptDir "bin") -Filter "*Signed.aab" -Recurse -ErrorAction SilentlyContinue |
	Sort-Object LastWriteTime -Descending |
	Select-Object -First 1

if (-not $outputAab) {
	$outputAab = Get-ChildItem -Path (Join-Path $scriptDir "OpenRA.Android") -Filter "*Signed.aab" -Recurse -ErrorAction SilentlyContinue |
		Sort-Object LastWriteTime -Descending |
		Select-Object -First 1
}

if ($outputAab) {
	Write-Host "`n========================================================" -ForegroundColor Green
	Write-Host "SUKCES! Gotowa, produkcyjnie podpisana paczka AAB:" -ForegroundColor Green
	Write-Host $outputAab.FullName -ForegroundColor Yellow
	Write-Host ("Rozmiar: {0:N2} MB" -f ($outputAab.Length / 1MB)) -ForegroundColor Cyan
	Write-Host "========================================================`n" -ForegroundColor Green

	$uploadScript = Join-Path $scriptDir "upload-to-googleplay.py"
	if (Test-Path $uploadScript) {
		$sendChoice = Read-Host "Czy chcesz automatycznie przeslac te paczke do Google Play Console? (T/N) [Domyslnie: T]"
		if ([string]::IsNullOrWhiteSpace($sendChoice) -or $sendChoice.ToUpper() -eq "T") {
			python "$uploadScript" "$($outputAab.FullName)"
		} else {
			Write-Host "Pominiecie wysylania. Mozesz wgrac plik recznie w Google Play Console." -ForegroundColor Yellow
		}
	}
} else {
	Write-Error "Nie znaleziono wygenerowanego pliku *Signed.aab!"
	exit 1
}
