# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-10-17

## 1. Zrealizowane prace i najnowsze zmiany

### A. Ekran wyboru aktywnego moda i Menedżer Modów (Active Mod Chooser & Mod Manager)
- Zaimplementowano wbudowany panel `MOD_MANAGER_PANEL` dostępny z poziomu menu głównego (przycisk **`Mody / Mods`**):
  - Dostępny w grach: Red Alert (`ra`), Tiberian Dawn (`cnc`), Dune 2000 (`d2k`) oraz Tiberian Sun (`ts`).
  - Trzy dedykowane zakładki:
    1. **Zainstalowane Mody**:
       - Dynamiczne skanowanie wszystkich zainstalowanych gier i dodatkowych modów.
       - Czytelne nazwy gier: *Command & Conquer: Red Alert*, *Command & Conquer: Tiberian Dawn*, *Dune 2000*, *Command & Conquer: Tiberian Sun*.
       - Oznaczenie aktywnego moda etykietą `[AKTYWNY]`.
       - Przycisk akcji **"Przełącz"** umożliwiający natychmiastowe przełączenie aktywnej gry w locie (in-process) bez konieczności ponownego instalowania lub restartowania aplikacji.
       - Zapisywanie ostatnio wybranego moda w `GameSettings.LastActiveMod` – wybrana gra uruchamia się automatycznie przy kolejnym starcie aplikacji.
    2. **Pobierz Mody**:
       - Wygodny interfejs pobierania archiwów modów (`.zip`, `.oramod`) bezpośrednio z sieci.
       - Pole tekstowe na bezpośredni adres URL z przyciskiem szybkiego wklejania ze schowka systemowego Androida (**"Wklej link"**).
       - Gotowe presety popularnych modów społecznościowych OpenRA (**Combined Arms**, **Romanov's Vengeance**, **Shattered Paradise**).
       - Pasek postępu pobierania (`ProgressBarWidget`) oraz status pobierania i rozpakowywania na żywo.
       - Asynchroniczne pobieranie strumieniowe i automatyczne rozpakowywanie do folderu modów w pamięci urządzenia.
    3. **Folder Danych i Map (Custom Storage Path)**:
       - Obejście ograniczeń Android 11+ (Scoped Storage / blokada `/Android/data/`).
       - Możliwość wyboru dowolnego katalogu w pamięci wspólnej urządzenia (domyślnie `/storage/emulated/0/OpenRA`).
       - Szybkie presety lokalizacji: Pamięć wewnętrzna (`/storage/emulated/0/OpenRA`), Pobrane (`.../Download/OpenRA`), Dokumenty (`.../Documents/OpenRA`) oraz folder prywatny aplikacji.
       - Przycisk **"Zapisz i Utwórz Foldery"**: automatyczne tworzenie podfolderów `/mods` oraz `/maps` wraz z plikami instruktażowymi `README.txt`.
       - Użytkownik może w prosty sposób wgrywać mapy i mody przez kabel USB lub dowolnego menedżera plików w Androidzie.
       - Dynamiczne odświeżanie pamięci podręcznej modów i map w locie (`Game.RefreshInstalledMods()`, rejestracja folderu map w `MapCache`).

### B. Ikona aplikacji (App Icon)
- Dodano ikonę Red Alert (czerwona gwiazda z sierpem i młotem) we wszystkich gęstościach ekranu Androida:
  - `OpenRA.Android/Resources/mipmap-mdpi/app_icon.png` (48x48)
  - `OpenRA.Android/Resources/mipmap-hdpi/app_icon.png` (72x72)
  - `OpenRA.Android/Resources/mipmap-xhdpi/app_icon.png` (96x96)
  - `OpenRA.Android/Resources/mipmap-xxhdpi/app_icon.png` (144x144)
  - `OpenRA.Android/Resources/mipmap-xxxhdpi/app_icon.png` (192x192)
- Skonfigurowano `AndroidManifest.xml` (`android:icon="@mipmap/app_icon"`, `android:roundIcon="@mipmap/app_icon"`) oraz `LauncherActivity.cs`.
- Ikona wyświetla się poprawnie na pulpicie lunchera Androida (zweryfikowano: `screen_home.png`).

### C. Przebudowa i naprawa menu Settings -> Input
- Poprawiono układ panelu `Settings -> Input`:
  - Usunięto nakładanie się tekstów i elementów (brak kolizji opisów ze sliderami).
  - Usunięto desktopowe schematy myszy ("Classic", "Modern", "Other RTS") oraz opcje przewijania krawędziowego i blokady kursora myszy.
  - Pozostawiono wyłącznie czyste, ergonomiczne sterowanie mobilne (ekran dotykowy).
- Dodano suwak konfiguracji czasu przytrzymania do zaznaczania obszarowego:
  - Wartości od 300 ms do 2000 ms (domyślnie 1000 ms).
  - Dynamiczna etykieta wskazująca aktualną wartość, np. `1000 ms (1.0s)`.
  - Wartość zapisywana w `GameSettings.TouchHoldDuration` (zweryfikowano: `screen_settings_input_fresh.png`, `screen_slider_dragged.png`).

### D. Animacja kołowa przytrzymania (Hold Progress Animation)
- Zaimplementowano w `WorldInteractionControllerWidget.cs` procedurę `DrawTouchHoldIndicator`:
  - **Dyskretny pierścień tła**: o promieniu 34px wokół miejsca przyłożenia palca.
  - **Zegarkowy łuk postępu (sweeping arc)**: kreślony zgodnie z ruchem wskazówek zegara od góry (-90°) proporcjonalnie do upływającego czasu (0% - 100% czasu ze slidera).
  - **Pulsujący rdzeń wewnętrzny**: rozszerzający się świetlisty punkt w centrum dotknięcia.
  - Po dojściu łuku do końca (100%) następuje płynne przejście w prostokąt zaznaczania obszarowego (`BoxSelecting`).
  - Animacja znika natychmiast, gdy palec zostanie oderwany lub przesunięty (swipe) do przewijania mapy.
  - Działanie potwierdzone na żywo w emulatorze (zweryfikowano: `hold_anim.png`).

### E. Sterowanie dotykowe (Touch Navigation Scheme)
- Dedykowany adapter wejścia dotykowego w `OpenRA.Game/Input/TouchInputAdapter.cs`:
  - **Swipe (przesuwanie palcem po mapie)**: płynne przesuwanie widoku pola bitwy.
  - **Przytrzymanie w miejscu (Hold)**: animacja kołowa i wejście w tryb zaznaczania prostokątem (`BoxSelecting`).
  - **Pojedynczy szybki tap**: zaznaczenie jednostki/budynku lub wydanie rozkazu marszu / ataku.
  - **Dwa palce**: jednoczesne przesuwanie kamery oraz zoom (pinch-to-zoom).
  - **Interakcja z UI**: dotknięcia elementów interfejsu (lewy pasek, prawy pasek budowy, menu, suwaki) działają natychmiastowo bez opóźnień gestów.

### F. Lewy pasek akcji (Action Bar)
- Zintegrowano na stałe z lewym panelem:
  - Przycisk **`ALL`**: zaznaczenie wszystkich własnych jednostek na ekranie.
  - Przycisk **`X`**: natychmiastowe odznaczenie jednostek i reset trybu rozkazu.
  - 5 Przycisków Grup Kontrolnych **`1`** do **`5`** z dynamicznymi licznikami i podświetleniem.
  - Przesunięcie belki postaw jednostek (`STANCE_BAR`) poniżej grup.

### G. Dymki Tooltip i Przycisk Następnej Misji
- Dymki budynków i jednostek pojawiają się poniżej panelu budowy (nie zasłaniają palca).
- W menu podsumowania misji po wygranej pojawia się przycisk **"Next Mission"**.

---

## 2. Stan techniczny i weryfikacja
- Wszystkie projekty (`OpenRA.Game`, `OpenRA.Platforms.Default`, `OpenRA.Mods.Common`, `OpenRA.Android`) kompilują się z 0 błędami.
- Spakowane archiwum zasobów: `OpenRA.Android/assets/openra-data.zip` (2535 plików).
- Zbudowano i zainstalowano na emulatorze: `bin/net10.0-android/android-x64/org.openra.android-Signed.apk`.
- Zweryfikowano działanie na żywo w emulatorze Google Play Games (`localhost:6520`):
  - Prawidłowa ikona Red Alert na pulpicie launchera (`screen_home.png`).
  - Płynne przełączanie gier w locie (Tiberian Dawn -> Red Alert -> Tiberian Sun -> Dune 2000) bez restartu aplikacji (`screen_after_switch_click.png`, `screen_ts_modmanager.png`).
  - Menedżer Modów i Zawartości:
    - Zakładka "Zainstalowane Mody" z listą gier i statusem aktywności (`screen_mm_opened_cnc.png`).
    - Zakładka "Pobierz Mody" z presetami linków i polem wprowadzania (`screen_tab2_pobierz_live.png`, `screen_preset_ca.png`).
    - Zakładka "Folder Danych i Map" z konfiguracją `/storage/emulated/0/OpenRA` i poprawnym tworzeniem katalogów `/mods` i `/maps` z plikiem `README.txt` (`screen_tab3_opened.png`, `screen_tab3_saved.png`).
  - Rozgrywka, sterowanie dotykowe, animacja kołowa przytrzymania i lewy pasek akcji.

---

## 3. Następne kroki (do wyboru)
1. Przygotowanie modułu tłumaczenia gry na język polski i inne języki (pliki Fluent `*.pl.ftl` lub integracja API tłumaczeń).
2. Dodanie panelu pobierania zasobów muzycznych / filmów wideo dla poszczególnych modów.
3. Dalsze dostosowywanie interfejsu dotykowego według preferencji użytkownika.
