# Status Projektu: nOpenRA (Port Android)
Data aktualizacji: 2026-10-26

## 1. Rozwiązanie awarii po 10-12s na telefonach fizycznych (Mali GPU) – Wersja v7 (1.0.6)

### A. Diagnoza awarii na fizycznym telefonie (Xiaomi 11T / Mali-G77 MC9 / Android 14)
- **Zgłoszony objaw:** Gra instaluje się, uruchamia, odtwarza dźwięk i działa przez około 10–12 sekund, po czym automatycznie minimalizuje się do tła / pulpitu i nie da się jej przywrócić na pierwszy plan.
- **Logi z urządzenia fizycznego (`/storage/emulated/0/Android/data/eu.gfmm.nopenra/files/Support/Logs/graphics.log`):**
  ```text
  GL Errors: Invalid Enum
     at OpenRA.Platforms.Default.OpenGL.CheckGLError()
     at OpenRA.Platforms.Default.Texture.SetDataFromReadBuffer(Rectangle rect)
     at OpenRA.Renderer.GetRenderBufferSnapshot()
     at OpenRA.Mods.Common.Traits.RenderPostProcessPassBase.OpenRA.Traits.IRenderPostProcessPass.Draw(WorldRenderer wr)
     at OpenRA.Graphics.WorldRenderer.ApplyPostProcessing(PostProcessPassType type)
     at OpenRA.Graphics.WorldRenderer.Draw()
     at OpenRA.Game.RenderTick()
     at OpenRA.Game.Loop()
     at OpenRA.Game.Run()
  ```
- **Zidentyfikowana przyczyna źródłowa:**
  1. Po starcie gry ładuje się mapa tła menu głównego (`shellmap`), co trwa dokładnie ~10-12 sekund.
  2. Gdy shellmap kończy ładowanie, uruchamia się efekt `MenuPostProcessEffect` (ściemnienie/desaturacja tła menu), który wywołuje `Renderer.GetRenderBufferSnapshot()`.
  3. Metoda `Texture.SetDataFromReadBuffer` przekazywała do funkcji `glCopyTexImage2D` format wewnętrzny `OpenGL.GL_BGRA` (0x80E1):
     ```csharp
     var glInternalFormat = OpenGL.Profile == GLProfile.Embedded ? OpenGL.GL_BGRA : OpenGL.GL_RGBA8;
     OpenGL.glCopyTexImage2D(OpenGL.GL_TEXTURE_2D, 0, glInternalFormat, rect.X, rect.Y, rect.Width, rect.Height, 0);
     ```
  4. Zgodnie ze specyfikacją OpenGL ES 2.0 / 3.0 / 3.2, funkcja `glCopyTexImage2D` **nie akceptuje `GL_BGRA` jako `internalformat`** (akceptuje wyłącznie `GL_RGBA`, `GL_RGB`, `GL_ALPHA`, `GL_LUMINANCE`). Sterownik procesora graficznego ARM Mali natychmiast zgłaszał błąd `GL_INVALID_ENUM`.
  5. `OpenGL.CheckGLError()` rzucał `InvalidOperationException`, co powodowało przerwanie pętli renderowania `Game.Run()` i wyjście z biblioteki SDL, a Android animował zamkniętą aktywność jako minimalizację do pulpitu.
  6. Dodatkowo brak flagi `android:launchMode="singleTask"` powodował, że próba kliknięcia w zminimalizowaną aplikację tworzyła nową instancję aktywności, która kolidowała z zablokowaną pamięcią GPU.

### B. Wdrożone rozwiązania w Wersji 7 (1.0.6)
1. **Poprawka formatu bufora w OpenGL ES (`OpenRA.Platforms.Default/Texture.cs`):**
   - Zmieniono format wewnętrzny dla profilu `Embedded` z `GL_BGRA` na w 100% zgodny ze specyfikacją `OpenGL.GL_RGBA`.
   - Dodano podwójną klauzulę `try-catch` z awaryjnym fallbackiem do `GL_RGBA` oraz rejestracją do logu `graphics`, gwarantując, że błąd kopiowania bufora klatki nigdy nie przerwie pętli gry.
2. **Odporność silnika na błędy efektów wizualnych (`OpenRA.Game/Graphics/WorldRenderer.cs`):**
   - Otoczono wywołanie `pass.Draw(this)` w `ApplyPostProcessing` bezpieczną obsługą wyjątków `try-catch`. Kosmetyczne efekty post-processingu (rozmycie/ściemnienie menu) nie spowodują awarii gry nawet w przypadku nietypowych sterowników GPU.
3. **Zarządzanie oknem i wznawianiem zadania (`AndroidManifest.xml` oraz `MainApplication.cs`):**
   - Dodano `android:launchMode="singleTask"` do `SDLActivity`.
   - Ustawiono `android:resizeableActivity="true"` w `<application>` oraz `<activity>`.
   - Ustawiono `Exported = false` dla `LauncherActivity`.
4. **Podbicie wersji do 7 (`1.0.6`):**
   - `OpenRA.Android.csproj`: `ApplicationVersion = 7`, `ApplicationDisplayVersion = 1.0.6`.
   - `AndroidManifest.xml`: `android:versionCode="7"`, `android:versionName="1.0.6"`.
   - `Game.cs`: `AndroidVersion = "1.0.6"`.
   - `upload-to-googleplay.py`: zaktualizowano notatki wydania.

### C. Weryfikacja na podłączonym telefonie fizycznym (Xiaomi 11T)
- Zbudowano paczkę APK i zainstalowano na urządzeniu `99fmkrk7bukvmnqw` przez `adb install --no-incremental -r`.
- Uruchomiono aplikację i monitorowano proces:
  - PID: `10510`
  - Po upływie 12, 30 i 60 sekund: `mCurrentFocus=Window{43e68de u0 eu.gfmm.nopenra/org.libsdl.app.SDLActivity}` (aplikacja nie zminimalizowała się, działa płynnie na pierwszym planie).
  - Plik `graphics.log` ma rozmiar 0 bajtów (brak jakichkolwiek błędów OpenGL).
  - Przetestowano minimalizację przyciskiem HOME i powrót – aplikacja wznawia się natychmiast bez crasha (`Activity not started, its current task has been brought to the front`).

---

## 2. Rozwiązanie odrzucenia Google Play (Broken Functionality) – Wersja v6 (1.0.5)

### A. Diagnoza odrzucenia Wersji 5 (1.0.4) z 26 października
- **Komunikat z Google Play Console:**
  *"Naruszenie zasad dotyczących nieprawidłowego działania – Awarie u użytkowników: Aplikacja otwiera się, ale ciągle ulega awariom. Kod wersji 5: In-app experience."*
- **Przyczyna:** Brak lokalnych plików gry przy czystej instalacji (wyświetlał się Content Installer z przyciskiem Quit).
- **Rozwiązanie w v6:** Dołączenie oficjalnych darmowych zasobów Red Alert (`ra-content.zip`) i automatyczne rozpakowywanie przy pierwszym starcie (`AssetExtractor.cs`).

---

## 3. Rozwiązanie blokady inicjalizacji ekranu w SDL2 – Wersja v5 (1.0.4)
- **Przyczyna:** Wyścig wątków w bibliotece `sdl2.jar` (`Skip .. Surface is not ready`).
- **Rozwiązanie:** Wymuszenie orientacji `sensorLandscape` i usunięcie zawieszania w pętli `SDLSurface.java`.

---

## 4. Narzędzia i pliki wdrożeniowe
- **Klucz podpisu (Upload Keystore):** `nopenra-upload.keystore` (Alias: `nopenra`, algorytm RSA 2048, ważność 10000 dni).
- **Skrypt budujący:** `.\build-android-release.ps1` (generuje podpisany AAB i APK).
- **Konto serwisowe Google Cloud API:** `gen-lang-client-0077146295-3ea3b88c5e9f.json`.
- **Skrypt wysyłający:** `python upload-to-googleplay.py --track internal` (lub `--track production`).

---

## 5. Następne kroki
1. Zbudowanie podpisanej produkcyjnej paczki AAB: `.\build-android-release.ps1`.
2. Wysłanie nowej wersji v7 (1.0.6) do Google Play Console za pomocą skryptu:
   ```powershell
   python upload-to-googleplay.py --track internal
   ```
   (oraz na ścieżkę produkcyjną, jeśli wymagane: `python upload-to-googleplay.py --track production`).
3. W Google Play Console: przejście do **Przegląd publikowania** (*Publishing overview*) i zatwierdzenie wysłania zmian do weryfikacji.
