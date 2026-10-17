# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-10-17

## 1. Zrealizowane prace i najnowsze zmiany

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
