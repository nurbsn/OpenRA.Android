# Instrukcja Publikacji nOpenRA Mobile w Google Play

Niniejszy dokument zawiera kompletny kontekst, konfigurację, ścieżki plików, narzędzia i procedurę publikacji aplikacji **nOpenRA Mobile (RTS Engine)** w sklepie **Google Play**.

---

## 1. Kluczowe parametry projektu

* **Nazwa w sklepie:** `nOpenRA Mobile (RTS Engine)`
* **Nazwa na pulpicie telefonu:** `nOpenRA Mobile`
* **Technologia:** .NET 10.0 Android + SDL2 + OpenGL ES 3.0.
* **Identyfikator aplikacji (`ApplicationId`):** `eu.gfmm.nopenra` (domena `eu.gfmm`).
* **Wymagany Target SDK:** `36` (Android 16). Skonfigurowany w [`OpenRA.Android.csproj`](file:///d:/Dokumenty/antigravityProjects/nOpenRA/OpenRA.Android/OpenRA.Android.csproj) oraz [`AndroidManifest.xml`](file:///d:/Dokumenty/antigravityProjects/nOpenRA/OpenRA.Android/AndroidManifest.xml).
* **Min SDK:** `24` (Android 7.0).
* **Zarządzanie wersjami (`OpenRA.Android.csproj`):**
  * `ApplicationVersion` (`VersionCode`) – **musi być zawsze ściśle większy niż poprzednio użyty w Google Play** (aktualnie: `1`).
  * `ApplicationDisplayVersion` (`VersionName`) – np. `1.0.0`.
* **Uprawnienia zgodne z Google Play:**
  * Usunięto restrykcyjne uprawnienie `MANAGE_EXTERNAL_STORAGE` (All Files Access), które w Google Play jest blokowane dla gier. Aplikacja korzysta ze standardowych katalogów aplikacji oraz wbudowanego menedżera pobierania HTTP.

---

## 2. Klucz podpisywania (Upload Keystore)

W głównym folderze projektu skrypt budowania używa (lub automatycznie generuje przy pierwszym uruchomieniu) oficjalny magazyn kluczy:
* **Ścieżka:** `./nopenra-upload.keystore`
* **Alias:** `nopenra`
* **Algorytm:** RSA 2048-bit, ważność 10 000 dni (`CN=nOpenRA, O=gfmm, C=EU`).
* **Hasło:** Podawane przez użytkownika podczas uruchamiania `.\build-android-release.ps1` (możesz użyć tego samego hasła co w `nAnyWebApp`).
* **⚠️ KRYTYCZNA UWAGA:** Po wgraniu pierwszej wersji do Google Play tego pliku **NIGDY nie wolno usunąć ani zastąpić nowym**. Certyfikat z tego klucza zostaje na stałe zarejestrowany w Google Play App Signing jako oficjalny klucz przesyłania (*Upload Key*).
* Plik `*.keystore` jest zabezpieczony w `.gitignore` (nie trafia na publiczny GitHub).

---

## 3. Pierwsza rejestracja aplikacji w Google Play Console (Jednorazowo)

> [!IMPORTANT]
> **Ograniczenie Google Play Developer API:**  
> API Google (`androidpublisher v3`) ze względów bezpieczeństwa **nie posiada funkcji utworzenia zupełnie nowej aplikacji od zera**. Pierwsze utworzenie karty aplikacji oraz wgranie pierwszego pliku `.aab` (rejestracja nazwy pakietu `eu.gfmm.nopenra` i klucza podpisu) musi zostać wykonane **jeden raz ręcznie w przeglądarce**. Wszystkie kolejne wersje, opisy i wydania mogą być wysyłane w 100% automatycznie przez skrypt!

### Kroki pierwszej rejestracji:
1. Zbuduj pierwszą podpisaną paczkę `.aab` komendą:
   ```powershell
   .\build-android-release.ps1
   ```
   (Wybierz `N` przy pytaniu o automatyczny upload, jeśli jeszcze nie utworzyłeś aplikacji w konsoli).
2. Wejdź na [Google Play Console](https://play.google.com/console) i kliknij **Utwórz aplikację** (*Create app*):
   * **Nazwa aplikacji:** `nOpenRA Mobile (RTS Engine)`
   * **Domyślny język:** Polski (`pl-PL`) lub Angielski (`en-US`)
   * **Aplikacja czy gra:** Gra (*Game*)
   * **Bezpłatna czy płatna:** Bezpłatna (*Free*)
3. W sekcji **Testowanie -> Testy wewnętrzne** (lub **Produkcja**) utwórz pierwsze wydanie i wgraj ręcznie wygenerowany plik:
   `bin\Release\net10.0-android\publish\eu.gfmm.nopenra-Signed.aab`
4. Upewnij się, że w **Użytkownicy i uprawnienia** (*Users and permissions*) konto serwisowe:
   `playdev@gen-lang-client-0077146295.iam.gserviceaccount.com`
   posiada uprawnienia globalne do konta lub zostało dodane do aplikacji `nOpenRA Mobile`.
5. Od tego momentu **każde kolejne wydanie oraz aktualizacja opisów PL/EN działa w 100% automatycznie z poziomu skryptu**!

---

## 4. Automatyczny upload przez Google Play Developer API

* **Klucz Service Account:** `gen-lang-client-0077146295-3ea3b88c5e9f.json` w głównym katalogu (zabezpieczony w `.gitignore`).
* **Konto usługi:** `playdev@gen-lang-client-0077146295.iam.gserviceaccount.com`
* **Skrypt uploadu:** [`upload-to-googleplay.py`](file:///d:/Dokumenty/antigravityProjects/nOpenRA/upload-to-googleplay.py)
  * Automatycznie aktualizuje opisy w sklepie (`pl-PL` oraz `en-US`) wraz z wymaganym oświadczeniem licencyjnym GPLv3 i disclaimerem znaków towarowych Electronic Arts.
  * Przesyła podpisany pakiet `.aab` (`eu.gfmm.nopenra-Signed.aab`).
  * Przypisuje wydanie do ścieżki `production` z dwujęzycznymi notatkami o wydaniu (*Release Notes*) i zatwierdza sesję edycji (`commit`).

---

## 5. Jak zbudować i opublikować nową wersję (All-in-One)

Cały proces jest zautomatyzowany w skrypcie [`build-android-release.ps1`](file:///d:/Dokumenty/antigravityProjects/nOpenRA/build-android-release.ps1).

### Procedura krok po kroku:
1. **Podbicie wersji (przy kolejnych aktualizacjach):**
   W [`OpenRA.Android/OpenRA.Android.csproj`](file:///d:/Dokumenty/antigravityProjects/nOpenRA/OpenRA.Android/OpenRA.Android.csproj) oraz [`OpenRA.Android/AndroidManifest.xml`](file:///d:/Dokumenty/antigravityProjects/nOpenRA/OpenRA.Android/AndroidManifest.xml) zwiększ `ApplicationVersion` / `versionCode` (np. na `2`, `3`...).
2. **Uruchomienie skryptu w PowerShell:**
   ```powershell
   .\build-android-release.ps1
   ```
   *(Opcjonalnie: `.\build-android-release.ps1 -SkipAssetPackaging`, jeśli zasoby `openra-data.zip` nie uległy zmianie).*
3. Po zakończeniu kompilacji naciśnij `Enter` (`T`), aby automatycznie przesłać `.aab` i zaktualizować kartę sklepu w Google Play Console.
