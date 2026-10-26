# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-10-26

## 1. Rozwiązanie odrzucenia Google Play (Broken Functionality) – Wersja v6 (1.0.5)

### A. Diagnoza odrzucenia Wersji 5 (1.0.4) z 26 października
- **Komunikat z Google Play Console / e-mail weryfikacyjny:**
  *"Naruszenie zasad dotyczących nieprawidłowego działania – Awarie u użytkowników: Aplikacja otwiera się, ale ciągle ulega awariom. Kod wersji 5: In-app experience."*
- **Dlaczego zakładki „Raport przed opublikowaniem” i „Android Vitals” były puste:**
  - Wersja 5 została wysłana skryptem API bezpośrednio na ścieżkę produkcyjną (`production`), gdzie Google nie generuje automatycznego raportu robota (Robo Crawler jest dedykowany dla ścieżek testowych: wewnątrz/zamknięta).
  - Weryfikacja została przeprowadzona manualnie przez żywego testera w laboratorium Google Play.
- **Zidentyfikowana bezpośrednia przyczyna odrzucenia:**
  1. Start silnika, biblioteka SDL2, OpenGL ES 3.2 i odtwarzanie audio działały bez zarzutu (poprawka z wersji 5 całkowicie usunęła czarny ekran i deadlock orientacji).
  2. Jednak po pierwszym uruchomieniu nowo zainstalowanej gry pojawiał się ekran Content Installera:
     *„Command & Conquer: Red Alert requires original game assets to run”* z przyciskami: **`[Advanced]`**, **`[Quick Install]`** oraz **`[Quit]`**.
  3. W odizolowanym środowisku review testerzy Google nie mają otwartego dostępu do zewnętrznych serwerów HTTP (pobieranie kończyło się błędem/timeoutem) lub tester po prostu klikał **`[Quit]`**, co wywoływało `Game.Exit()` i natychmiastowe ubicie procesu aplikacji.
  4. Zgodnie z wytycznymi Google Play dotyczącymi *Broken Functionality*, aplikacja po pobraniu ze sklepu musi natychmiast oferować grywalną funkcjonalność offline, a natychmiastowe zamykanie lub brak działania bez zewnętrznych pobrań jest klasyfikowany jako awaria/brak funkcjonalności.

### B. Wdrożone rozwiązania w Wersji 6 (1.0.5)
1. **Zintegrowanie darmowych zasobów bazowych Red Alert (`ra-content.zip`):**
   - Pobrano oficjalną paczkę `ra-quickinstall.zip` (12.88 MB / 13.5 MB po rozpakowaniu) zawierającą 39 bazowych plików `.mix` i `.aud` Red Alert (udostępnionych bezpłatnie jako freeware).
   - Umieszczono paczkę jako asset Androida: `OpenRA.Android/assets/ra-content.zip`.
   - Zaktualizowano `OpenRA.Android/package-assets.ps1`, aby automatycznie weryfikował obecność `ra-content.zip`.
2. **Automatyczne rozpakowywanie przy pierwszym starcie (`AssetExtractor.cs`):**
   - Dodano metodę `EnsureContentExtracted(Context context, string supportDir, ...)`.
   - Zasoby są wypakowywane bezpośrednio do oficjalnego katalogu gry: `SupportDir/Content/ra/v2`.
   - Mechanizm posiada stempel wersji (`.extracted_ra_content`), dzięki czemu wypakowanie następuje tylko raz przy pierwszym uruchomieniu po instalacji lub aktualizacji.
   - Jeśli pliki (`allies.mix`, `conquer.mix`, itp.) już istnieją, krok jest natychmiast pomijany.
3. **Integracja w punkcie wejścia (`AndroidGameBridge.cs`):**
   - Dodano wywołanie `AssetExtractor.EnsureContentExtracted` przed inicjalizacją i załadowaniem moda `ra` (zarówno dla pamięci głównej, jak i wewnętrznego fallbacku `FilesDir`).
   - Silnik OpenRA od razu wykrywa zainstalowaną grę i ładuje bezpośrednio menu główne Red Alert.
4. **Podbicie wersji do 6 (`1.0.5`):**
   - `OpenRA.Android.csproj`: `ApplicationVersion = 6`, `ApplicationDisplayVersion = 1.0.5`.
   - `AndroidManifest.xml`: `android:versionCode="6"`, `android:versionName="1.0.5"`.
   - `Game.cs`: `AndroidVersion = "1.0.5"`.
   - `upload-to-googleplay.py`: zaktualizowane notatki do wydania po polsku i angielsku podkreślające natychmiastowy start offline.

### C. Weryfikacja na żywym emulatorze Androida
- Wyczyszczono całkowicie poprzednią instalację (`adb uninstall eu.gfmm.nopenra`).
- Zainstalowano nową paczkę z zasobami.
- Uruchomiono aplikację – w logcat potwierdzono:
  `[OpenRA.Android] Assets extracted successfully`
  `[OpenRA.Android] Red Alert content extracted successfully`
  `Loading mod: ra`
- **Wynik wizualny:** Gra natychmiast otwiera pełne, animowane menu główne Red Alert ze wszystkimi opcjami, w 100% offline, bez żadnych okien dialogowych, pytań o pobieranie i bez zamykania procesu.

---

## 2. Rozwiązanie blokady inicjalizacji ekranu w SDL2 – Wersja v5 (1.0.4)

### A. Diagnoza awarii na zrzutach ekranu z Google Play
- **Komunikat z Google Play:** *"Awarie u użytkowników: Aplikacja otwiera się, ale ciągle ulega awariom"* (zrzuty ekranu ukazujące urządzenia testowe Google zawieszone na czarnym ekranie ze wstępną ikoną systemowego splash screenu).
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
  2. **Konflikt `resizeableActivity="true"` z wymuszeniem orientacji poziomej:**
     - Od Androida 12+ flaga `resizeableActivity="true"` sprawia, że system ignoruje `screenOrientation="sensorLandscape"` na urządzeniach w labie testowym, pozostawiając okno w pionie i aktywując powyższy deadlock w SDL2.

### B. Wdrożone rozwiązania w Wersji 5 (1.0.4)
1. **Przebudowa i dekompilacja `sdl2.jar`:**
   - Wyeliminowano z kodu `SDLSurface.java` blokadę `Skip .. Surface is not ready`.
   - Powierzchnia graficzna jest teraz natychmiast konfigurowana i oznaczana jako gotowa (`mIsSurfaceReady = true`, `handleNativeState()`), niezależnie od orientacji.
   - Skompilowano zaktualizowaną klasę `SDLSurface.class` za pomocą OpenJDK 21 z `android-36/android.jar` i zaktualizowano `OpenRA.Android/libs/sdl2.jar`.
2. **Konfiguracja Manifestu i Aktywności:**
   - Ustawiono `android:resizeableActivity="false"` w `AndroidManifest.xml` oraz w `MainApplication.cs`.
   - Dodano jawny atrybut `[Register("eu.gfmm.nopenra.MainApplication")]`.

---

## 3. Rozwiązanie awarii startowej w kodzie – Wersja v4 (1.0.3)

### A. Diagnoza awarii
- **Komunikat błędu:** *"Aplikacja otwiera się, ale ciągle ulega awariom"* (zapętlenie splash screenu w orientacji poziomej).
- **Zidentyfikowana bezpośrednia przyczyna awarii:**
  1. **Brak implementacji metody natywnej (`UnsatisfiedLinkError`):**
     - Dotychczas rejestracja metod JNI (`runManagedGame`) następowała dopiero w `LauncherActivity.OnCreate()`.
     - Zautomatyzowany robot testowy Google Play (Robo Crawler) oraz wznawianie po Process Death uruchamiały `SDLActivity` bezpośrednio, z pominięciem `LauncherActivity`.
     - Skutkowało to błędem: `java.lang.UnsatisfiedLinkError: No implementation found for void org.libsdl.app.SDLActivity.runManagedGame()`.
  2. **Wyścig w oknie WindowManager (Trampoline Activity):**
     - `LauncherActivity` żądała `ScreenOrientation.SensorLandscape` i natychmiast wywoływała `Finish()`, powodując błędy WindowManagera.

### B. Wdrożone rozwiązania w wersji 4 (1.0.3)
1. **Wprowadzenie klasy `MainApplication` (`OpenRA.Android/MainApplication.cs`):**
   - Rejestracja JNI (`AndroidGameBridge.RegisterJniMethods()`) wykonuje się natychmiast w `MainApplication.OnCreate()` przed jakąkolwiek aktywnością.
2. **Bezpośredni punkt wejścia (`SDLActivity` jako jedyny launcher):**
   - Przeniesiono filtry intencji `MAIN` oraz `LAUNCHER` bezpośrednio na `org.libsdl.app.SDLActivity`.
   - Wyeliminowano całkowicie trampoline activity.
3. **Odporność na Scoped Storage:**
   - Domyślne korzystanie z legalnego katalogu `SupportDir/Content`.
   - Dodano podwójny fallback w `AndroidGameBridge` do `FilesDir`.

---

## 4. Obsługa stron pamięci 16 KB (Wersja v3 / 1.0.2)
- Re-kompilacja bibliotek natywnych NDK r28c (`libopenal.so`, `libfreetype.so`) z flagą `-Wl,-z,max-page-size=16384`.
- Zapewnienie pełnej kompatybilności z urządzeniami Android 15+.
- Dodanie bezpiecznego fallbacku do `DummySoundEngine()` w przypadku braku urządzenia dźwiękowego.

---

## 5. Zrealizowane funkcjonalności wcześniejsze
- **Architektura lokalizacji i tłumaczeń:**
  - Język polski i angielski w Ustawieniach (`Settings -> Language`).
  - Przeładowywanie dynamiczne w locie (`FluentProvider.Reload()`).
- **Menedżer Modów w grze (Mod Manager):**
  - Przełączanie gier w locie bez restartu (Red Alert, Tiberian Dawn, Dune 2000, Tiberian Sun).
  - Pobieranie modów z sieci i konfiguracja ścieżki map.
- **Sterowanie dotykowe:**
  - Przewijanie mapy jednym palcem (swipe).
  - Przybliżanie dwoma palcami (pinch-to-zoom).
  - Zaznaczanie obszarowe z regulowanym czasem przytrzymania i animacją zegarowego pierścienia.
  - Lewy panel szybkich akcji (`ALL`, `X`, 5 grup jednostek z licznikami na żywo).

---

## 6. Procedura wdrożenia Wersji 6 do Google Play Console

1. **Zbudowanie podpisanej paczki produkcyjnej AAB:**
   - Wygenerowano `bin\net10.0-android\publish\eu.gfmm.nopenra-Signed.aab` (wersja 6 / 1.0.5, rozmiar 94.36 MB, podpisana kluczem produkcyjnym `nopenra-upload.keystore`).

2. **Wysłanie paczki do Google Play:**
   - Skonfigurowano skrypt `upload-to-googleplay.py` z domyślną ścieżką `internal` (oraz opcją `--track production`).
   - Wersja 6 (1.0.5) została pomyślnie wysłana i przypisana do:
     - **Ścieżki produkcyjnej (`production`)** – oczekuje na weryfikację.
     - **Ścieżki testów wewnętrznych (`internal`)** – status `completed`, natychmiastowa dostępność dla testerów oraz automatyczne uruchomienie testów Robo Crawler (Raport przed opublikowaniem).

3. **Zatwierdzenie w Google Play Console:**
   - Wejście do [Google Play Console](https://play.google.com/console).
   - W sekcji **Testuj i publikuj** $\rightarrow$ **Testy wewnętrzne** wersja 6 jest natychmiast aktywna dla dodanych testerów.
   - W sekcji **Przegląd publikowania** wydanie produkcyjne można przesłać do sprawdzenia.
