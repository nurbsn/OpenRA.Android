# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-11-10

## 1. Wydanie v1.0.9 (Release 10) – Sterowanie kolejką budowy i Rally Point

Wdrożono i pomyślnie opublikowano wersję **v1.0.9** (versionCode: **10**):

- **Wertykalny dotykowy panel zarządzania kolejką (Queue Panel):**
  - Dotknięcie ikony jednostki/budynku w menu bocznym rozwija pionowy panel 6 przycisków umieszczony bezpośrednio po lewej stronie palety.
  - `[ +5 ]` – masowe dodanie 5 jednostek do kolejki jednym tapnięciem.
  - `[ -1 ]` – precyzyjne odwołanie pojedynczej jednostki z kolejki ze zwrotem kredytów.
  - `[ || / > ]` – wstrzymanie lub wznowienie produkcji z podświetleniem w kolorze złota gry.
  - `[ ⊘ ]` – wektorowy symbol przekreślonego koła (zakaz/anulowanie), usuwa całą kolejkę danego typu.
  - `[ ⚑ ]` – dedykowany przycisk wyznaczania punktu zbiórki (Rally Point) dla wyprodukowanych jednostek ze wskaźnikiem celu na mapie.
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

## 2. Publikacja GitHub (ZAKOŃCZONE)

- **Kod źródłowy:** Zacommitowany (`6201c87`) i wypchnięty do gałęzi `main` w `https://github.com/nurbsn/OpenRA.Android.git`.
- **Tag Git:** `v1.0.9` (wypchnięty do `myorigin`).
- **Oficjalne wydanie:** [GitHub Release v1.0.9](https://github.com/nurbsn/OpenRA.Android/releases/tag/v1.0.9)
- **Załączony instalator:** [`OpenRA-Android-v1.0.9.apk`](https://github.com/nurbsn/OpenRA.Android/releases/download/v1.0.9/OpenRA-Android-v1.0.9.apk) (92.55 MB, podpisany cyfrowo, gotowy do instalacji).

---

## 3. Publikacja Google Play Console

- Zaktualizowano notatki o wydaniu (Release Notes PL/EN) w `upload-to-googleplay.py` dla `versionCode = 10` (`1.0.9`).
- Paczka produkcyjna `.aab` wymaga podpisania kluczem `nopenra-upload.keystore`. Aby wygenerować i opublikować paczkę w Google Play:
  ```powershell
  .\build-android-release.ps1
  ```
  Podaj hasło do klucza `nopenra-upload.keystore`, a skrypt automatycznie zbuduje paczkę AAB i wyśle ją do Google Play Console.
