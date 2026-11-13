# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-11-13

## 1. Wydanie v1.0.10 (Release 11) – Stabilność dotyku/wyjścia, panel kolejki i ujednolicone Ustawienia

Przygotowano wersję **v1.0.10** (versionCode: **11**):

- **Naprawa zaznaczania obszarowego i gestów dotykowych (`TouchInputAdapter`, `WorldInteractionControllerWidget`, `Sdl2Input`)**:
  - Wyeliminowano blokowanie i natychmiastowe aktywowanie prostokątnej ramki zaznaczania przy szybkim przesuwaniu kamery palcem (panningu).
  - Poprawiono wykrywanie granic widgetów (`ProductionPaletteWidget.EventBoundsContains`, ignorowanie wyłączonych kontrolek), czyszczenie stanu gestów przy utracie fokusu/minimalizacji i starcie rozgrywki oraz dodano testy `TouchInputAdapterTest.cs`.
- **Naprawa awarii przy sprzedaży budynku i czystego wyjścia (`ProductionPaletteWidget`, `SetRallyPointOrderGenerator`, `Game`, `AndroidGameBridge`)**:
  - Usunięto wyjątek `InvalidOperationException` po sprzedaży lub zniszczeniu budynku produkcyjnego przy otwartym panelu kolejki albo aktywnym trybie Rally Point.
  - Przeniesiono sprzątanie zasobów gry, dźwięku, kontekstu graficznego i lokalnego serwera do bloku `finally` w `Game.Run()` oraz `AndroidGameBridge`, eliminując wiszące procesy/audio w tle po wyjściu.
- **Panel kolejki budowy (`+5`, `-1`, `⏸`, `⊘`, `⚑`, `✕`) we wszystkich modach**:
  - Naprawiono zakotwiczenie panelu w `cnc` tuż przy `PRODUCTION_BACKGROUND` (zamiast lewego górnego rogu `0, 0`).
  - Dopasowano kolorystykę tła i przycisków panelu do aktywnego moda/frakcji (`panel-black-*` / `dialog4`, `sidebar-button-*` / `button-*`, `ChromeMetrics`).
- **Ujednolicenie menu Ustawień we wszystkich modach**:
  - `mods/cnc/mod.yaml` korzysta ze wspólnych plików `common|chrome/settings*.yaml` z zachowaniem natywnego stylu C&C (`dialog`, `dialog2`, `dialog3` w `mods/cnc/chrome.yaml` i uzupełnione klucze w `mods/cnc/fluent/chrome.ftl`).
  - Dodano `common|chrome/settings-language.yaml` do `mods/polanie/mod.yaml`.
- **Weryfikacja**:
  - `dotnet test OpenRA.Test\OpenRA.Test.csproj` (512 zaliczonych, 2 pominięte, 0 błędów).
  - Emulator (`localhost:6520`, C&C GDI/Nod, Red Alert Allies) oraz fizyczny telefon (`99fmkrk7bukvmnqw`, `2400x1080`, Mali-G77 MC9).

---

## 2. Publikacja GitHub (v1.0.10)

- **Repozytorium / gałąź:** `https://github.com/nurbsn/OpenRA.Android.git` (`main`), tag `v1.0.10`.
- **Oficjalne wydanie:** [GitHub Release v1.0.10](https://github.com/nurbsn/OpenRA.Android/releases/tag/v1.0.10)
- **Załączony instalator:** [`OpenRA-Android-v1.0.10.apk`](https://github.com/nurbsn/OpenRA.Android/releases/download/v1.0.10/OpenRA-Android-v1.0.10.apk)

---

## 3. Publikacja Google Play Console

- Zaktualizowano notatki o wydaniu (PL/EN) w `upload-to-googleplay.py` dla `versionCode = 11` (`1.0.10`).
- Aby wygenerować `.aab` i wysłać aktualizację do Google Play Console, uruchom `.\build-android-release.ps1` z hasłem do `nopenra-upload.keystore`.
