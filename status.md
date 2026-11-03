# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-11-03

## 1. Oficjalne zrzuty ekranu dla sklepu Google Play (1920x1080) – ZAKOŃCZONE

Wszystkie 5 wymaganych zrzutów ekranu w rozdzielczości 1920x1080 zostało pomyślnie przechwyconych bezpośrednio z działającej instancji gry na emulatorze Google Play Games Developer Emulator (`localhost:6520`) i zweryfikowanych pod kątem poprawności wizualnej, rozdzielczości i zawartości.

Pliki zostały zsynchronizowane w katalogach:
- `D:\Dokumenty\antigravityProjects\nOpenRA\store_screenshots\`
- `C:\Users\nurbs\.gemini\antigravity\brain\189c9089-e65f-425c-8675-9d41a85d0178\`

### Wykaz zrzutów:
1. **`screenshot_1_ra_main_menu.png`** (3 792 791 B, 1920x1080):
   - Menu główne moda Red Alert: stylizowany radziecki motyw z czerwoną gwiazdą i sierpem/młotem, animowane tło mapy, czytelne spolszczone menu nawigacyjne przy skali UI 1.75.
2. **`screenshot_2_ra_skirmish_lobby.png`** (2 163 867 B, 1920x1080):
   - Lobby potyczki (*Skirmish*): wybór frakcji ZSRR, konfiguracja graczy AI, podgląd minimapy, sloty dowódców, polska lokalizacja UI.
3. **`screenshot_3_ra_base_building.png`** (967 213 B, 1920x1080):
   - Rozbudowa bazy w fazie wczesnej/średniej: rozłożony Plac Budowy (MCV), elektrownie jądrowe/cieplne, koszary, rafineria rudy oraz aktywny zbieracz (Harvester) dostarczający surowce.
4. **`screenshot_4_ra_combat.png`** (1 705 480 B, 1920x1080):
   - Radziecka formacja pancerna w natarciu bojowym: transportery opancerzone (APC), pojazdy przeciwlotnicze (Mobile Flak) i czołg ciężki (Heavy Tank) uformowane w szyk bojowy na przedpolu bazy w asyście Fabryki Wojennej i Wieży Tesli.
5. **`screenshot_5_ra_tesla_defense.png`** (1 710 052 B, 1920x1080):
   - W pełni operacyjna obrona bazy z działającą **Wieżą Tesli** (`Tesla Coil`): rozłożona na zachodnim skrzydle bazy z widocznym wskaźnikiem naładowania, w otoczeniu kompleksu energetycznego (4 elektrownie, zasilanie 310) i 2 rafinerii.

---

## 2. Inżynieria sterowania dotykowego i automatyzacji na Androidzie

W toku realizacji zadania zdekodowano i zaimplementowano precyzyjną automatyzację interfejsu OpenRA dla ekranów dotykowych i emulatora Android:

### A. Architektura wejścia i mapowanie palety produkcyjnej (`ProductionPaletteWidget.cs`)
- **Skróty klawiaturowe zakładek produkcji:**
  - Budynki (`Building`): Klawisz `E` (`KEYCODE_E` = 33)
  - Obrona (`Defense`): Klawisz `R` (`KEYCODE_R` = 46)
  - Piechota (`Infantry`): Klawisz `T` (`KEYCODE_T` = 48)
  - Pojazdy (`Vehicle`): Klawisz `Y` (`KEYCODE_Y` = 53)
- **Klawisze funkcyjne slotów palety produkcyjnej:**
  - Siatka 3 kolumny: Slot 1..3 (Wiersz 1) = `F1`..`F3` (kody 131–133), Slot 4..6 (Wiersz 2) = `F4`..`F6` (kody 134–136), Slot 7..9 (Wiersz 3) = `F7`..`F9` (kody 137–139).
  - Wciśnięcie klawisza pustego slotu uruchamia budowę; wciśnięcie klawisza gotowego budynku (`item.Done`) podnosi go do kursora rozmieszczenia (`PickUpCompletedBuildingIcon`).

### B. Współrzędne dotykowe (Tap Targets) w rozdzielczości 1920x1080 (UI Scale 1.75)
- **Pasek rozkazów (lewy):**
  - Zaznacz wszystkie jednostki (`SELECT_ALL`): `(40, 390)`
  - Rozłóż bazę / rozpakuj MCV (`DEPLOY`): `(40, 204)`
- **Pasek boczny (prawy, X: 1630–1880, Y: 440–680):**
  - Wiersz 1: Col 1 `(1675, 480)`, Col 2 `(1755, 480)`, Col 3 `(1835, 480)`
  - Wiersz 2: Col 1 `(1675, 560)`, Col 2 `(1755, 560)`, Col 3 `(1835, 560)`
  - Wiersz 3: Col 1 `(1675, 640)`, Col 2 `(1755, 640)`, Col 3 `(1835, 640)`
- **Pozycje budynków w bazie (Vegetation):**
  - Plac Budowy (MCV): `(960, 500)`
  - Elektrownie 1 & 2 (wschód): `(1060, 480)`, `(1060, 360)`
  - Elektrownie 3 & 4 (zachód / północ): `(860, 380)`, `(1060, 240)`
  - Rafinerie rudy 1 & 2 (południe): `(960, 670)`, `(1100, 670)`
  - Fabryka Wojenna (południowy zachód): `(830, 670)`
  - Wieża Tesli (wysunięta obrona zachodnia): `(760, 500)`

### C. Deterministyczny detektor ukończenia budowy (`GOTOWE`)
- Wyeliminowano podatność na błędy timeoutów poprzez bezpośrednią analizę bufora klatki screencap:
  - Napis `"GOTOWE"` na ikonie slotu renderowany jest z charakterystycznym żółtym konturem RGB (`R > 190, G > 170, B < 60`).
  - Liczba żółtych pikseli podczas budowy wynosi `0`, po ukończeniu skacze do `> 200`.

---

## 3. Stan techniczny portu – Wersja v8 (1.0.7)

- **Platforma docelowa:** Android (API 26-34) / Google Play Games Developer Emulator (`localhost:6520`) / Urządzenia fizyczne x86_64 i ARM64.
- **Płynność i frame pacing:** `Graphics.CapFramerate=True`, `Graphics.MaxFramerate=60`.
- **Shadery:** Pełna precyzja `highp float` i `highp int` w OpenGL ES 3.0, brak artefaktów na shaderze mgły wojennej (`combined.frag`).
- **Tryb pełnoekranowy:** Wymuszony `ImmersiveSticky` przez `WindowInsetsController`, brak przesłaniania UI przez paski systemowe.
- **Wielkość przycisków:** Przyciski paska rozkazów powiększone do 42x30 px, czytelne i responsywne.

---

## 4. Środowisko i narzędzia

- **ADB:** `C:\Program Files (x86)\Android\android-sdk\platform-tools\adb.exe`
- **Emulator:** Google Play Games on PC Developer Emulator (`localhost:6520`)
- **Skrypt budujący:** `.\build-android-release.ps1`
- **Klucz podpisu (Keystore):** `nopenra-upload.keystore` (Alias: `nopenra`)
- **Konto serwisowe Google Cloud:** `gen-lang-client-0077146295-3ea3b88c5e9f.json`
- **Skrypt publikacji do Google Play:** `python upload-to-googleplay.py --track internal` (lub `--track production`)

---

## 5. Podsumowanie i gotowość projektu
Zadanie przygotowania i wygenerowania oficjalnego zestawu zrzutów ekranu w rozdzielczości 1920x1080 zostało w 100% zrealizowane. Wszystkie materiały graficzne oraz zaktualizowany kod są gotowe do publikacji w sklepie Google Play.
