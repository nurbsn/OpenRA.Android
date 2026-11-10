# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-11-10

## 1. Wydanie v1.0.9 (Release 10) – Sterowanie kolejką budowy i Rally Point

Wdrożono i opublikowano wersję **v1.0.9** (versionCode: **10**):

- **Wertykalny dotykowy panel zarządzania kolejką (Queue Panel):**
  - Dotknięcie ikony jednostki/budynku w menu bocznym rozwija pionowy panel 6 przycisków umieszczony bezpośrednio po lewej stronie palety.
  - `[ +5 ]` – masowe dodanie 5 jednostek do kolejki jednym tapnięciem.
  - `[ -1 ]` – precyzyjne odwołanie pojedynczej jednostki z kolejki ze zwrotem kredytów.
  - `[ || / > ]` – wstrzymanie lub wznowienie produkcji z podświetleniem w kolorze złota gry.
  - `[ ⊘ ]` – wektorowy symbol przekreślonego koła (zakaz/anulowanie), usuwa całą kolejkę danego typu.
  - `[ ⚑ ]` – dedykowany przycisk wyznaczania punktu zbiórki (Rally Point) dla wyprodukowanych jednostek.
  - `[ X ]` – zamknięcie panelu podręcznego.
- **Natywna stylistyka Red Alert:**
  - Zastosowano grafikę przycisków `sidebar-button-soviet` / `sidebar-button-allies`, idealnie zintegrowaną z oryginalnym interfejsem gry.
  - Kolorystyka: tekst `Color.FromArgb(235, 235, 235)` z czarnym cieniem, szary dla stanu nieaktywnego, złoto-bursztynowy dla aktywności.
- **Rozwiązanie problemu zaznaczania jednostek przy budynkach:**
  - W `OpenRA.Mods.Common/Traits/Buildings/RallyPoint.cs` wyłączono domyślne przechwytywanie dotknięć w ziemię po zaznaczeniu budynku (`Orders => yield break`).
  - Dzięki temu dotknięcie terenu lub jednostki w pobliżu koszar/fabryki nie przesuwa już punktu zbiórki, lecz zaznacza wybraną jednostkę lub odznacza budynek.
  - Wyznaczanie zbiórki odbywa się świadomie za pomocą generatora `SetRallyPointOrderGenerator` aktywowanego przyciskiem `[ ⚑ ]`.
- **Weryfikacja na emulatorze:**
  - Przetestowano w Google Play Games Emulator: zweryfikowano działanie wszystkich 6 przycisków, symboli `⊘` i `⚑`, zachowanie stanów aktywnych/nieaktywnych oraz brak klejenia zaznaczenia budynków.

---

## 2. Dystrybucja i publikacja

- **Kod źródłowy:** Zacommitowany i wypchnięty do gałęzi `main` w `https://github.com/nurbsn/OpenRA.Android.git`.
- **Tag Git:** `v1.0.9`.
- **GitHub Release:** Oficjalne wydanie ze spakowanym instalatorem APK `OpenRA-Android-v1.0.9.apk` (92.55 MB).
- **Google Play:** Skonfigurowane Release Notes i skrypt `upload-to-googleplay.py` dla versionCode 10.
