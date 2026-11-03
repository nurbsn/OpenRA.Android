# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-11-03

## 1. Google Play Console – Publikacja zrzutów ekranu i ASO – ZAKOŃCZONE

Wszystkie 5 oficjalnych zrzutów ekranu w rozdzielczości 1920x1080 zostało pomyślnie wgranych i opublikowanych w Google Play Console (`eu.gfmm.nopenra`):
- **Języki docelowe:** Polski (`pl-PL`) oraz Angielski (`en-US`).
- **Kategorie urządzeń:**
  - `phoneScreenshots` (5 grafik 1920x1080)
  - `sevenInchScreenshots` (5 grafik 1920x1080)
  - `tenInchScreenshots` (5 grafik 1920x1080)
- Łącznie przesłano i zatwierdzono 30 grafik w sesji edycji Google Play API (`androidpublisher v3`).
- Zmiany zostały zatwierdzone i zapisane w Google Play Console.

---

## 2. Repozytorium GitHub – Zrzuty i dokumentacja – ZAKOŃCZONE

- **Katalog zrzutów:** Dodano oficjalne pliki 1920x1080 do `store_screenshots/`:
  - `screenshot_1_ra_main_menu.png`
  - `screenshot_2_ra_skirmish_lobby.png`
  - `screenshot_3_ra_base_building.png`
  - `screenshot_4_ra_combat.png`
  - `screenshot_5_ra_tesla_defense.png`
- **Dokumentacja:** Zaktualizowano [README.md](file:///d:/Dokumenty/antigravityProjects/nOpenRA/README.md) o galerię zrzutów ekranu.
- **Commit i push:** Zmiany wypchnięto do gałęzi `main` w `https://github.com/nurbsn/OpenRA.Android.git` (commit `9d13138`).

---

## 3. GitHub Release – Wydanie v1.0.8 z instalatorem APK – ZAKOŃCZONE

Opublikowano oficjalne wydanie na GitHubie:
- **Wersja:** **v1.0.8** (VersionCode: 9)
- **Tag:** `v1.0.8` (skierowany na commit `9d13138`)
- **Strona wydania:** https://github.com/nurbsn/OpenRA.Android/releases/tag/v1.0.8
- **Załączony instalator APK:** [`OpenRA-Android-v1.0.8.apk`](https://github.com/nurbsn/OpenRA.Android/releases/download/v1.0.8/OpenRA-Android-v1.0.8.apk) (92.55 MB, podpisany, gotowy do instalacji na Androidzie 7.0+).
- **Changelog (PL/EN):**
  - Nowy kompletny zestaw zrzutów ekranu w rozdzielczości 1920x1080 w sklepie Google Play i na GitHubie.
  - Optymalizacja pionowego układu paska rozkazów (`COMMAND_BAR`) zapobiegająca ucinaniu przycisków na ekranach panoramicznych.
  - Bezrestartowe przełączanie modów w locie (`Game.SwitchToExternalMod` -> `InitializeMod`).
  - Szybkie przeładowanie po zmianie ustawień języka i skali UI w menu gry.
  - Precyzja shaderów `highp` w OpenGL ES 3.0, eliminacja pasów na mgle wojennej i płynne 60 FPS w trybie `ImmersiveSticky`.

---

## 4. Środowisko i narzędzia

- **ADB:** `C:\Program Files (x86)\Android\android-sdk\platform-tools\adb.exe`
- **Emulator:** Google Play Games on PC Developer Emulator (`localhost:6520`)
- **Skrypt budujący:** `.\build-android-release.ps1` oraz `.\build-apk.ps1`
- **Klucz podpisu (Keystore):** `nopenra-upload.keystore` (Alias: `nopenra`)
- **Konto serwisowe Google Cloud:** `gen-lang-client-0077146295-3ea3b88c5e9f.json`
- **Skrypt publikacji do Google Play:** `python upload-to-googleplay.py`
