# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-10-27

## 1. Poprawki graficzne, UI i pełnego ekranu – Wersja v8 (1.0.7)

### A. Zgłoszone problemy po testach na urządzeniu fizycznym (Xiaomi 11T / Android 14)
1. **Paski telefonu (pasek stanu u góry i pasek nawigacyjny z prawej) przesłaniały UI:**
   - Brakowało wymuszenia flagi `SDL_WINDOW_FULLSCREEN` w oknie SDL oraz wywołania nowoczesnego API `WindowInsetsController` dla trybu `ImmersiveSticky`.
2. **Mgła wojenna (szary/czarny shroud) wyświetlała się z poziomymi pasami:**
   - W shaderze `glsl/combined.frag` precyzja zmiennoprzecinkowa była ustawiona na `mediump float` (FP16 – zaledwie 10 bitów mantysy). Ponieważ głębokość Z zależy liniowo od współrzędnej Y ekranu, 10-bitowa kwantyzacja głębokości powodowała schodkowanie i z-fighting (naprzemienne paski w miejscach styku mgły z terenem).
   - Dodatkowo shader bezwarunkowo nadpisywał `gl_FragDepth = depth;`, wyłączając sprzętowy Early-Z i precyzję bufora rastrującego.
3. **Animacje dziwnie przeskakiwały / przycinały:**
   - Przy arkuszach sprajtów o rozmiarze 2048x2048 precyzja `mediump` (10 bitów mantysy = 1024 stany) nie była w stanie dokładnie zaadresować pojedynczego teksla, powodując przeskakiwanie współrzędnych UV o 2 piksele na klatkę.
   - Brak limitera klatek (`CapFramerate=False`) na ekranach 120Hz prowadził do nieregularnego buforowania klatek logicznych gry względem VSync.
4. **Przyciski szybkich akcji (po lewej stronie) były zbyt małe:**
   - Przyciski paska rozkazów miały rozmiar 36x26 px.

### B. Wdrożone rozwiązania w Wersji 8 (1.0.7)
1. **Pełny tryb immersyjny (`Immersive Sticky`) bez pasków systemowych:**
   - W `OpenRA.Platforms.Default/Sdl2PlatformWindow.cs`: włączono flagę `SDL.SDL_WindowFlags.SDL_WINDOW_FULLSCREEN` na Androidzie przy tworzeniu okna i wywołano `SDL_SetWindowFullscreen`.
   - W `OpenRA.Android/AndroidGameBridge.cs`: dodano metodę `ApplyImmersiveFullscreen()`, która bezpośrednio przez JNI pobiera aktywność `SDLActivity` i konfiguruje `WindowInsetsController.Hide(systemBars())` z zachowaniem `ShowTransientBarsBySwipe` oraz flagi `WindowManagerFlags.Fullscreen`.
2. **Eliminacja pasów mgły wojennej i poprawa precyzji shaderów:**
   - W `glsl/combined.frag`: zmieniono precyzję na `precision highp float; precision highp int;` (pełne 32-bitowe IEEE 754 floaty w OpenGL ES 3.0+).
   - Zmodyfikowano zapis do `gl_FragDepth`: bufor głębokości jest nadpisywany wyłącznie wtedy, gdy sprajt faktycznie zawiera dodatkową maskę głębokości (`length(vDepthMask) > 0.0`), co pozwala GPU na zachowanie pełnej, sprzętowej precyzji bufora 24-bit oraz optymalizacji Early-Z.
   - Podbito do `highp` również `glsl/combined.vert`, `glsl/model.frag` oraz wszystkie shadery post-processingu (`glsl/postprocess_*.frag`).
3. **Płynność animacji i stabilny frame pacing:**
   - Pełna precyzja `highp` w próbkowaniu teksli wyeliminowała skakanie UV w animacjach.
   - W `AndroidGameBridge.cs` ustawiono parametry startowe `"Graphics.CapFramerate=True"`, `"Graphics.MaxFramerate=60"`, co synchronizuje pętlę renderowania z logiką gry i eliminuje mikrozacięcia.
4. **Powiększenie przycisków szybkich akcji o ~15%:**
   - W `mods/ra/chrome/ingame-player.yaml`:
     - Pasek rozkazów (`Container@COMMAND_BAR`): szerokość z 36 do 42 px, wysokość z 405 do 465 px.
     - Przyciski (15 przycisków: ruch, atak, stop, ALL, X, grupy 1-5 itd.): powiększone z 36x26 px na **42x30 px** (skok Y z 27 na 31 px).
     - Pasek postaw (`Container@STANCE_BAR`): przesunięty na Y: 535, przyciski powiększone do **42x30 px**.
   - Zaktualizowano i spakowano paczkę `openra-data.zip` (2540 plików).
5. **Aktualizacja opisu wydania i podbicie wersji:**
   - Podbito wersję do **8 (`1.0.7`)** w `OpenRA.Android.csproj`, `AndroidManifest.xml` oraz `Game.cs`.
   - Zaktualizowano notatki wydania w `upload-to-googleplay.py` o informację o testach na fizycznym urządzeniu.

---

## 2. Rozwiązanie awarii po 10-12s na telefonach fizycznych (Mali GPU) – Wersja v7 (1.0.6)
- **Przyczyna:** Błąd `GL_INVALID_ENUM` przy `glCopyTexImage2D` z formatem `GL_BGRA` w shaderze `MenuPostProcessEffect`.
- **Rozwiązanie:** Zmiana formatu na `OpenGL.GL_RGBA` i zabezpieczenie blokiem `try-catch`.

---

## 3. Rozwiązanie odrzucenia Google Play (Broken Functionality) – Wersja v6 (1.0.5)
- **Przyczyna:** Brak lokalnych plików gry przy czystej instalacji.
- **Rozwiązanie:** Dołączenie oficjalnych darmowych zasobów Red Alert (`ra-content.zip`) i automatyczne rozpakowywanie przy pierwszym starcie (`AssetExtractor.cs`).

---

## 4. Narzędzia i pliki wdrożeniowe
- **Klucz podpisu (Upload Keystore):** `nopenra-upload.keystore` (Alias: `nopenra`).
- **Skrypt budujący:** `.\build-android-release.ps1`.
- **Konto serwisowe Google Cloud API:** `gen-lang-client-0077146295-3ea3b88c5e9f.json`.
- **Skrypt wysyłający:** `python upload-to-googleplay.py --track internal` (lub `--track production`).

---

## 5. Następne kroki do publikacji wersji 8 (1.0.7)
1. Zbudowanie podpisanej paczki produkcyjnej (AAB):
   ```powershell
   .\build-android-release.ps1 -SkipAssetPackaging
   ```
   *(flaga `-SkipAssetPackaging` wykorzysta już przygotowany i zweryfikowany plik `openra-data.zip`).*
2. Wysłanie paczki do Google Play:
   ```powershell
   python upload-to-googleplay.py --track internal
   ```
   (lub `--track production`).
