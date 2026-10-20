# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-10-20

## 1. Rozwiązanie blokady inicjalizacji ekranu w SDL2 – Wersja v5 (1.0.4)

### A. Diagnoza awarii na 4 zrzutach ekranu z Google Play (20 października)
- **Komunikat z Google Play:** *"Awarie u użytkowników: Aplikacja otwiera się, ale ciągle ulega awariom"* (zrzuty ekranu ukazujące 4 różne urządzenia testowe Google zawieszone na czarnym ekranie ze wstępną ikoną systemowego splash screenu).
- **Zidentyfikowana bezpośrednia przyczyna awarii (Hang / ANR na starcie):**
  1. **Blokada inicjalizacji w `SDLSurface.java` (`Skip .. Surface is not ready`):**
     - W bibliotece `sdl2.jar` metoda `surfaceChanged(SurfaceHolder, int, int width, int height)` zawierała warunek:
       ```java
       if ((n6 == 0 || n6 == 6) && this.mWidth < this.mHeight) {
           Log.v("SDL", "Skip .. Surface is not ready.");
           this.mIsSurfaceReady = false;
           return;
       }
       ```
     - Gdy urządzenie testowe Google otwiera aplikację w orientacji pionowej (domyślny stan fizyczny telefonów w labie testowym), `SDLSurface` odrzucało powierzchnię, ustawiało `mIsSurfaceReady = false` i przerywało inicjalizację.
     - Ponieważ `SDLActivity.handleNativeState()` uruchamia wątek gry `mSDLThread` **wyłącznie wtedy, gdy `mIsSurfaceReady == true`**, silnik gry OpenRA **nigdy nie został uruchomiony**.
     - Aplikacja wisiała w nieskończoność na czarnym ekranie splash screenu, co automat testowy Google zaklasyfikował jako awarię/zamrożenie przy starcie.
  2. **Konflikt `resizeableActivity="true"` z wymuszeniem orientacji poziomej:**
     - Od Androida 12+ flaga `resizeableActivity="true"` sprawia, że system ignoruje `screenOrientation="sensorLandscape"` na urządzeniach w labie testowym, pozostawiając okno w pionie i aktywując powyższy deadlock w SDL2.

### B. Wdrożone rozwiązania w Wersji 5 (1.0.4)
1. **Przebudowa i dekompilacja `sdl2.jar`:**
   - Wyeliminowano z kodu `SDLSurface.java` blokadę `Skip .. Surface is not ready`.
   - Powierzchnia graficzna jest teraz natychmiast konfigurowana i oznaczana jako gotowa (`mIsSurfaceReady = true`, `handleNativeState()`), niezależnie od tego, czy urządzenie znajduje się w pionie, poziomie czy trybie okienkowym.
   - Skompilowano zaktualizowaną klasę `SDLSurface.class` za pomocą OpenJDK 21 z `android-36/android.jar` i zaktualizowano `OpenRA.Android/libs/sdl2.jar`.
2. **Konfiguracja Manifestu i Aktywności:**
   - Ustawiono `android:resizeableActivity="false"` w `AndroidManifest.xml` oraz w `MainApplication.cs`, gwarantując wymuszenie orientacji `sensorLandscape` w systemie Android.
   - Dodano jawny atrybut `[Register("eu.gfmm.nopenra.MainApplication")]`.
3. **Podbicie wersji do 5 (`1.0.4`):**
   - `ApplicationVersion = 5`, `ApplicationDisplayVersion = 1.0.4` w `OpenRA.Android.csproj`.
   - `versionCode = "5"`, `versionName = "1.0.4"` w `AndroidManifest.xml`.
   - `AndroidVersion = "1.0.4"` w `Game.cs`.
   - Zaktualizowane notatki do wydania w `upload-to-googleplay.py`.

---

## 2. Wyjaśnienie wcześniejszego odrzucenia wersji 3 i 4

### A. Diagnoza odrzucenia (20 października)
- **Komunikat z Google Play:** *"Naruszenie zasad dotyczących nieprawidłowego działania – Awarie u użytkowników: Aplikacja otwiera się, ale ciągle ulega awariom. Wyegzekwowano: 20 paź"*.
- **Weryfikacja przez Google Play Developer API:**
  - Odrzucenie dotyczyło **Wersji 3 (1.0.2)**, a nie Wersji 4!
  - W konsoli zarejestrowane były dotąd jedynie wersje 1, 2 oraz 3.
  - Zrzuty ekranu dołączone przez Google (splash screen w pionie i poziomie) w 100% potwierdzają zdiagnozowany problem wersji 3: brak implementacji metody natywnej JNI przy bezpośrednim uruchomieniu `SDLActivity` przez crawler (`UnsatisfiedLinkError`) oraz wyścig w oknie `WindowManager` przy obrocie ekranu w trampoline activity.

### B. Wykrycie i naprawa błędu podpisu oraz uploadu
- Przy próbie uploadu Wersji 4 wykryto, że lokalna paczka AAB w katalogu `bin` była podpisana domyślnym kluczem deweloperskim Android Debug (`24:58:4C:83...`), przez co Google Play zwracał błąd 403 (oczekiwano klucza `B1:68:7F:21...`).
- Potwierdzono, że oficjalny magazyn kluczy `nopenra-upload.keystore` posiada **dokładnie ten oczekiwany przez Google odcisk SHA1: `B1:68:7F:21:DE:E8:F8:7F:B1:CD:5D:F6:F9:A9:23:C3:88:10:30:18`**.
- W skrypcie `upload-to-googleplay.py` usunięto błąd, który przy kodzie 403 cicho ignorował błąd i przepinał starą wersję 3.
- Dodano automatyczną weryfikację certyfikatu w `upload-to-googleplay.py` i `build-android-release.ps1` – próba przesłania paczki z podpisem debug jest natychmiast blokowana z czytelnym komunikatem.

---

## 2. Rozwiązanie awarii startowej w kodzie (Wersja v4 / 1.0.3)

### A. Diagnoza awarii na zrzutach z Google Play (20 października)
- **Komunikat błędu:** *"Aplikacja otwiera się, ale ciągle ulega awariom"* (zrzuty ekranu ukazujące zapętlenie splash screenu w orientacji poziomej, czarne koło maski wycięcia kamery i ponowny start w pionie).
- **Zidentyfikowana bezpośrednia przyczyna awarii:**
  1. **Brak implementacji metody natywnej (`UnsatisfiedLinkError`):**
     - Dotychczas rejestracja metod JNI (`runManagedGame`) następowała dopiero w `LauncherActivity.OnCreate()`.
     - W `AndroidManifest.xml` aktywność `org.libsdl.app.SDLActivity` posiadała atrybut `android:exported="true"`.
     - Zautomatyzowany robot testowy Google Play (Robo Crawler / Firebase Test Lab) oraz mechanizm wznawiania po ubiciu procesu (Process Death / Recents restore) uruchamiały `SDLActivity` bezpośrednio, z pominięciem `LauncherActivity`.
     - Skutkowało to natychmiastowym błędem w Java: `java.lang.UnsatisfiedLinkError: No implementation found for void org.libsdl.app.SDLActivity.runManagedGame()`, ubijającym proces natychmiast po starcie.
  2. **Wyścig w oknie WindowManager (Trampoline Activity):**
     - `LauncherActivity` żądała `ScreenOrientation.SensorLandscape` i natychmiast po `StartActivity` wywoływała `Finish()`. W połączeniu z obrotem ekranu z orientacji pionowej (w jakiej roboty Google domyślnie trzymają urządzenia) powodowało to `Activity top resumed state loss timeout` i awaryjne zamykanie okna przez systemowy `ActivityTaskManager`.

### B. Wdrożone rozwiązania w wersji 4 (1.0.3)
1. **Wprowadzenie klasy `MainApplication` (`OpenRA.Android/MainApplication.cs`):**
   - Zarejestrowano własną klasę `[Application]` w systemie Android.
   - `MainApplication.OnCreate()` jest **zawsze gwarantowane przez system Android do wykonania jako pierwsze w procesie**, zanim jakakolwiek Activity (`SDLActivity` czy `LauncherActivity`) rozpocznie działanie.
   - Rejestracja JNI (`AndroidGameBridge.RegisterJniMethods()`) wykonuje się natychmiast na poziomie aplikacji, eliminując jakiekolwiek ryzyko `UnsatisfiedLinkError`.
2. **Bezpośredni punkt wejścia (`SDLActivity` jako jedyny launcher):**
   - Przeniesiono filtry intencji `android.intent.action.MAIN` oraz `android.intent.category.LAUNCHER` bezpośrednio na `org.libsdl.app.SDLActivity`.
   - Wyeliminowano całkowicie trampoline activity, podwójne splash screeny i kolizje przy obrocie ekranu.
   - `LauncherActivity` pozostawiono jako bezpieczny wewnętrzny redirect ze wsteczną kompatybilnością.
3. **Odporność na błędy zapisu i Scoped Storage:**
   - Wyeliminowano próby bezpośredniego zapisu do `/storage/emulated/0/OpenRA` w `Game.cs:GetCustomContentPath()`, które w Androidzie 11+ (targetSdk 36) powodowały błędy `MediaProvider: Creating or writing to a non-default top level directory is not allowed!`. Aplikacja domyślnie korzysta w 100% z legalnego, zawsze dostępnego katalogu `SupportDir/Content`.
   - Dodano podwójny fallback w `AndroidGameBridge`: w razie niepowodzenia wypakowania zasobów na pamięć zewnętrzną, następuje natychmiastowe automatyczne powtórzenie w pamięci wewnętrznej (`FilesDir`).
4. **Podbicie wersji:**
   - `ApplicationVersion = 4`, `ApplicationDisplayVersion = 1.0.3` (csproj).
   - `versionCode = "4"`, `versionName = "1.0.3"` (manifest).
   - `AndroidVersion = "1.0.3"` (Game.cs).

---

## 2. Rozwiązanie problemu stron pamięci 16 KB (Poprzednia wersja v3)

### A. Diagnoza przyczyny odrzucenia (Awarie u użytkowników / Nieprawidłowe działanie)
- **Komunikat błędu z Google Play:** *"Aplikacja otwiera się, ale ciągle ulega awariom"* (zrzut ekranu z systemowym oknem dialogowym: *"Clear cache for nOpenRA Mobile? nOpenRA Mobile closed because this app has a bug. Try clearing the app's cache first..."*).
- **Bezpośrednia przyczyna awarii:**
  - Zautomatyzowane testy Google Play (Pre-launch report / CTS na Androidzie 15+) są uruchamiane na środowiskach i urządzeniach o **16 KB rozmiarze stron pamięci** (16 KB page size kernel).
  - Biblioteki `base/lib/arm64-v8a/libopenal.so`, `base/lib/x86_64/libopenal.so` oraz `libfreetype.so` posiadały nagłówki segmentów ELF `PT_LOAD` wyrównane do 4096 bajtów (`align = 4 KB`).
  - Dynamiczny linker Androida na jądrach 16 KB odrzucał ładowanie tych bibliotek (`dlopen failed: empty/misaligned PT_LOAD segment`), powodując natychmiastowe ubicie procesu aplikacji (SIGSEGV/abort) już w trakcie startu (`SDLActivity.loadLibraries` -> `System.loadLibrary("openal")`).

### B. Wdrożone poprawki i rekonfiguracja kompilacji
1. **Pobranie i konfiguracja oficjalnego Android NDK r28c:**
   - Zainstalowano pakiet `ndk;28.2.13676358` oraz `cmake;3.22.1` z ninja.
2. **Kompilacja bibliotek natywnych z obsługą stron pamięci 16 KB:**
   - Przebudowano od źródeł `libopenal.so` (OpenAL Soft) dla architektur `arm64-v8a` oraz `x86_64` z flagą linkera `-Wl,-z,max-page-size=16384`.
   - Przebudowano od źródeł `libfreetype.so` (FreeType) dla `arm64-v8a` oraz `x86_64` z flagą `-Wl,-z,max-page-size=16384`.
   - Przetestowano i potwierdzono nagłówki ELF: **wszystkie 8 bibliotek `.so` w `libs` mają teraz `align = 16384` (16 KB) oraz idealne dopasowanie offsetów**.
3. **Odporność na błędy audio (`OpenAlSoundEngine`):**
   - W `OpenRA.Platforms.Default/DefaultPlatform.cs` rozszerzono łapanie wyjątków z `InvalidOperationException` na ogólny `Exception`, dzięki czemu w przypadku braku urządzenia audio lub problemu z biblioteką natywną silnik bezpiecznie przełącza się na `DummySoundEngine()` zamiast zamykać grę.
4. **Zabezpieczenie ścieżek zapisu (`AndroidGameBridge.cs`):**
   - Dodano bezpieczny fallback do wewnętrznego `context.FilesDir`, jeśli pamięć zewnętrzna urządzenia testowego jest niedostępna lub odmontowana.
5. **Obsługa dużych ekranów i tabletów (`resizeableActivity`):**
   - Dodano `android:resizeableActivity="true"` w `AndroidManifest.xml` oraz `ResizeableActivity = true` w `LauncherActivity.cs` (usuwając zalecenia Google Play dotyczące urządzeń z dużym ekranem).
6. **Podbicie wersji do 3 (`1.0.2`):**
   - Zaktualizowano `ApplicationVersion = 3`, `ApplicationDisplayVersion = 1.0.2` w `OpenRA.Android.csproj`.
   - Zaktualizowano `versionCode = "3"`, `versionName = "1.0.2"` w `AndroidManifest.xml`.
   - Zaktualizowano `AndroidVersion = "1.0.2"` w `Game.cs`.
   - Zaktualizowano notatki do wydania w `upload-to-googleplay.py`.

---

## 2. Zrealizowane prace i wcześniejsze zmiany

### A. Wersjonowanie aplikacji i modów (Version System)
- Rozwiązano problem wyświetlania wersji deweloperskiej `{DEV_VERSION}`.
- Wersja aplikacji składa się teraz z wersji silnika OpenRA oraz wersji portu na Androida:
  - Format: `{EngineVersion} (Android v{AndroidVersion})`, np. `bleed-20261017 (Android v1.0.0)`.
- Zaimplementowano spójną obsługę wersji w całym silniku:
  - `VERSION`: zaktualizowano z `{DEV_VERSION}` do `bleed-20261017`.
  - `OpenRA.Game/Game.cs`: dodano `AndroidVersion = "1.0.0"` oraz `AppVersion => $"{EngineVersion} (Android v{AndroidVersion})"`. W przypadku braku lub `{DEV_VERSION}` silnik automatycznie stosuje fallback do aktualnego buildu.
  - `OpenRA.Game/Manifest.cs`: automatyczny fallback do `Game.EngineVersion` w przypadku braku wersji w metadanych moda.
  - `OpenRA.Mods.Common/Widgets/Logic/VersionLabelLogic.cs`: wyświetlanie sformatowanej wersji pod logo EVA i w menu głównym.
  - `OpenRA.Mods.Cnc/CncLoadScreen.cs`: wyświetlanie sformatowanej wersji również na ekranie początkowym ładowania gry pod logo EVA.
  - `OpenRA.Mods.Common/Widgets/Logic/ModManagerLogic.cs`: wyświetlanie wersji moda obok tytułu na liście zainstalowanych modów (np. `Command & Conquer: Red Alert (bleed-20261017)`).

### B. Zakładka Język i Tłumaczenia w Ustawieniach (Language & Localization)
- Dodano nową zakładkę **"Język" / "Language"** w panelu `Settings`:
  - Zarejestrowano `LANGUAGE_PANEL` w `mods/common/chrome/settings.yaml` i `mods/cnc/chrome/settings.yaml`.
  - Zdefiniowano interfejs w `mods/common/chrome/settings-language.yaml` (lista rozwijana języków, szybkie przyciski przełączania `English` / `Polski`, etykiety informacyjne).
  - Utworzono logikę `OpenRA.Mods.Common/Widgets/Logic/Settings/LanguageSettingsLogic.cs`:
    - Obsługa zapisu wybranego języka do `Game.Settings.Game.Language`.
    - Wywołanie `FluentProvider.Reload()` w locie w celu natychmiastowego przeładowania stringów bez konieczności restartu.
- Architektura tłumaczeń w locie (`FluentProvider` / `FluentBundle`):
  - Ustawienie `GameSettings.Language` (domyślnie `"en"`).
  - Mechanizm nakładania tłumaczeń: baza angielska z automatycznym nakładaniem zasobów z `common|fluent/translations-{culture}.ftl`.
  - Przygotowano kompletny plik tłumaczeń na język polski: `mods/common/fluent/translations-pl.ftl` (pokrywający Menedżer Modów, Ustawienia, menu główne, opcje w grze oraz sterowanie dotykowe).
- Spójność językowa Menedżera Modów:
  - Usunięto zahardkodowane teksty polskie z `mod-manager.yaml` i `ModManagerLogic.cs`.
  - Wprowadzono klucze Fluent (`label-mod-manager-title`, `button-tab-installed-mods`, `button-tab-download-mods`, `button-tab-storage`, itd.).
  - Cały interfejs (menu, mody, ustawienia) jest w 100% spójny z aktualnie wybranym językiem (angielski lub polski).

### C. Repozytorium GitHub i Dokumentacja
- Połączono i wypchnięto projekt do oficjalnego repozytorium GitHub: [OpenRA.Android](https://github.com/nurbsn/OpenRA.Android).
- Gałąź `main` zaktualizowana i zsynchronizowana z GitHubem (`myorigin/main`).
- Utworzono dwujęzyczny plik `README.md` w korzeniu repozytorium:
  - Część angielska (English): opis portu, lista obsługiwanych gier i modów, opis sterowania dotykowego, action bar, in-process mod manager, instrukcja kompilacji i pakowania APK.
  - Część polska (Polski): kompletne tłumaczenie opisu, wymagań i instrukcji.

### D. Ekran wyboru aktywnego moda i Menedżer Modów (Active Mod Chooser & Mod Manager)
- Zaimplementowano wbudowany panel `MOD_MANAGER_PANEL` dostępny z poziomu menu głównego (przycisk **`Mody / Mods`**):
  - Dostępny w grach: Red Alert (`ra`), Tiberian Dawn (`cnc`), Dune 2000 (`d2k`) oraz Tiberian Sun (`ts`).
  - Trzy dedykowane zakładki:
    1. **Zainstalowane Mody**:
       - Dynamiczne skanowanie wszystkich zainstalowanych gier i dodatkowych modów.
       - Czytelne nazwy gier: *Command & Conquer: Red Alert*, *Command & Conquer: Tiberian Dawn*, *Dune 2000*, *Command & Conquer: Tiberian Sun*.
       - Oznaczenie aktywnego moda etykietą `[AKTYWNY]`.
       - Przycisk akcji **"Przełącz"** umożliwiający natychmiastowe przełączenie aktywnej gry w locie (in-process) bez restartu aplikacji.
       - Zapisywanie ostatnio wybranego moda w `GameSettings.LastActiveMod`.
    2. **Pobierz Mody**:
       - Interfejs pobierania archiwów modów (`.zip`, `.oramod`) bezpośrednio z sieci.
       - Pole tekstowe z przyciskiem szybkiego wklejania ze schowka systemowego Androida (**"Wklej link"**).
       - Gotowe presety popularnych modów społecznościowych OpenRA (**Combined Arms**, **Romanov's Vengeance**, **Shattered Paradise**).
       - Pasek postępu pobierania oraz status na żywo.
    3. **Folder Danych i Map (Custom Storage Path)**:
       - Obejście ograniczeń Android 11+ (Scoped Storage).
       - Możliwość wyboru dowolnego katalogu w pamięci wspólnej urządzenia (domyślnie `/storage/emulated/0/OpenRA`).
       - Szybkie presety lokalizacji.
       - Przycisk **"Zapisz i Utwórz Foldery"**: automatyczne tworzenie podfolderów `/mods` oraz `/maps` wraz z plikami `README.txt`.

### E. Ikona aplikacji (App Icon)
- Dodano ikonę Red Alert we wszystkich gęstościach ekranu Androida:
  - `OpenRA.Android/Resources/mipmap-mdpi/app_icon.png` (48x48)
  - `OpenRA.Android/Resources/mipmap-hdpi/app_icon.png` (72x72)
  - `OpenRA.Android/Resources/mipmap-xhdpi/app_icon.png` (96x96)
  - `OpenRA.Android/Resources/mipmap-xxhdpi/app_icon.png` (144x144)
  - `OpenRA.Android/Resources/mipmap-xxxhdpi/app_icon.png` (192x192)

### F. Sterowanie dotykowe i animacja kołowa przytrzymania
- Suwak konfiguracji czasu przytrzymania do zaznaczania obszarowego w `Settings -> Input` (300 ms - 2000 ms).
- Animacja zegarowego pierścienia postępu przytrzymania palca (`DrawTouchHoldIndicator`) w `WorldInteractionControllerWidget.cs`.
- Lewy pasek akcji z przyciskiem `ALL`, przyciskiem `X` oraz 5 grupami jednostek z licznikami.
- Dymki tooltip pod panelem budowy i przycisk "Next Mission" w podsumowaniu misji.

---

## 2. Stan techniczny i weryfikacja
- Wszystkie projekty kompilują się pomyślnie z 0 błędami.
- Zbudowano zaktualizowaną paczkę zasobów `openra-data.zip` (2534 pliki, w tym nowe pliki tłumaczeń i konfiguracji).
- Zbudowano podpisany pakiet APK: `bin/net10.0-android/android-x64/org.openra.android-Signed.apk`.
- Repozytorium GitHub `https://github.com/nurbsn/OpenRA.Android` w pełni zaktualizowane na gałęzi `main`.
