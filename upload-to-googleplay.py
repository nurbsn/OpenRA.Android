import os
import sys
import glob
from google.oauth2 import service_account
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from googleapiclient.http import MediaFileUpload

PACKAGE_NAME = "eu.gfmm.nopenra"
KEY_FILE = "gen-lang-client-0077146295-3ea3b88c5e9f.json"
SCOPES = ['https://www.googleapis.com/auth/androidpublisher']

STORE_LISTINGS = {
    'pl-PL': {
        'title': 'Red Tide RTS: Classic Warfare',
        'shortDescription': 'Klasyczna strategia czasu rzeczywistego (RTS). Buduj bazę i walcz offline!',
        'fullDescription': (
            'Red Tide RTS: Classic Warfare to mobilna, otwartoźródłowa gra strategiczna czasu rzeczywistego (RTS), '
            'zaprojektowana z myślą o ekranach dotykowych systemu Android.\n\n'
            'Doświadcz prawdziwej, klasycznej rozgrywki RTS znanej ze złotego wieku gier strategicznych lat 90.: '
            'zbieraj surowce, rozbudowuj bazę, odkrywaj technologie i dowodź potężnymi armiami na lądzie, w powietrzu i na wodzie – '
            'całkowicie za darmo, w 100% bez mikropłatności i bez pay-to-win!\n\n'
            'NAJWAŻNIEJSZE CECHY ROZGRYWKI (RTS):\n'
            '• Prawdziwa strategia czasu rzeczywistego: brak sztucznych liczników energii, brak mikropłatności, czysta taktyka i refleks.\n'
            '• Budowanie baz i zarządzanie zasobami: stawiaj elektrownie, koszary, rafinerie i fabryki, zabezpieczaj linie zaopatrzenia.\n'
            '• Zróżnicowane siły zbrojne: czołgi, artyleria, żołnierze, śmigłowce, myśliwce oraz okręty podwodne i krążowniki.\n'
            '• Pełna rozgrywka OFFLINE: graj w dowolnym miejscu bez dostępu do internetu w trybie Potyczki (Skirmish) przeciwko botom AI o różnym poziomie trudności.\n'
            '• Intuicyjne sterowanie dotykowe: płynne przesuwanie kamery (swipe), przybliżanie dwoma palcami (pinch-to-zoom) oraz szybkie zaznaczanie ramką (hold-to-select).\n'
            '• Pasek szybkiego dowodzenia: natychmiastowe zaznaczanie wszystkich jednostek (ALL), rozpraszanie, odznaczanie (X) oraz 5 niezależnych grup armii.\n'
            '• Wbudowany Menedżer Modów: obsługa klasycznych modyfikacji gier strategicznych (m.in. Red Alert, Tiberian Dawn, Dune 2000) z możliwością instalowania dodatkowych map i modów społeczności.\n'
            '• Pełna polska i angielska wersja językowa interfejsu.\n\n'
            'INFORMACJE PRAWNE I LICENCJA (GPLv3):\n'
            'Red Tide RTS jest niezależnym, tworzonym przez społeczność projektem opartym na otwartoźródłowym silniku OpenRA, '
            'rozpowszechnianym na warunkach licencji GNU General Public License v3.0 (GPLv3).\n'
            'Pełny kod źródłowy: https://github.com/nurbsn/OpenRA.Android\n\n'
            'OŚWIADCZENIE (DISCLAIMER):\n'
            'Ta aplikacja nie jest powiązana, autoryzowana ani wspierana przez Electronic Arts Inc., Westwood Studios '
            'ani oficjalnych twórców projektu OpenRA. Znaki towarowe Command & Conquer, Red Alert, Tiberian Dawn oraz Dune 2000 '
            'należą do ich prawowitych właścicieli i zostały użyte wyłącznie w celach informacyjnych.'
        )
    },
    'en-US': {
        'title': 'Red Tide RTS: Classic Warfare',
        'shortDescription': 'Classic Real-Time Strategy (RTS). Build bases and command armies offline!',
        'fullDescription': (
            'Red Tide RTS: Classic Warfare is a touch-optimized mobile Real-Time Strategy (RTS) game '
            'powered by an open-source tactical engine.\n\n'
            'Experience true classic 90s-era RTS gameplay: harvest resources, construct bases, research advanced tech trees, '
            'and command massive armies across land, air, and sea. 100% free, open-source, with zero pay-to-win mechanics or timers!\n\n'
            'KEY RTS FEATURES:\n'
            '• Pure Real-Time Strategy: no energy timers, no pay-to-win, no microtransactions — purely skill, strategy, and tactics.\n'
            '• Base Construction & Economy: build power plants, barracks, ore refineries, and war factories to sustain your warmachine.\n'
            '• Diverse Combat Units: tanks, mobile artillery, rocket infantry, attack helicopters, jet fighters, submarines, and cruisers.\n'
            '• Full OFFLINE Support: play anytime, anywhere without an internet connection in Skirmish mode against intelligent AI commanders.\n'
            '• Touch-First Controls: smooth camera panning, responsive pinch-to-zoom, and hold-to-box-select with a visual hold ring.\n'
            '• Quick Action Command Bar: instant select-all (ALL), scatter, cancel selection (X), and 5 army control groups with live unit counters.\n'
            '• In-game Mod & Content Manager: switch between supported classic mods (including Red Alert, Tiberian Dawn, Dune 2000) and download community maps.\n'
            '• Multilingual UI: full support for English and Polish.\n\n'
            'OPEN SOURCE & LICENSE (GPLv3):\n'
            'Red Tide RTS is an independent community project powered by the open-source OpenRA engine, licensed under the GNU General Public License v3.0 (GPLv3).\n'
            'Source code: https://github.com/nurbsn/OpenRA.Android\n\n'
            'LEGAL DISCLAIMER:\n'
            'This application is an independent community project and is not affiliated with, endorsed, or sponsored by Electronic Arts Inc., '
            'Westwood Studios, or the official OpenRA developers. Command & Conquer, Red Alert, Tiberian Dawn, and Dune 2000 are registered '
            'trademarks of their respective owners and are mentioned solely for compatibility and reference purposes.'
        )
    }
}


def find_aab():
    patterns = [
        os.path.join("bin", "net10.0-android", "publish", "*Signed.aab"),
        os.path.join("bin", "Release", "net10.0-android", "publish", "*Signed.aab"),
        os.path.join("bin", "Release", "net10.0-android", "**", "*Signed.aab"),
        os.path.join("bin", "net10.0-android", "**", "*Signed.aab"),
        os.path.join("OpenRA.Android", "bin", "Release", "net10.0-android", "**", "*Signed.aab"),
    ]
    all_matches = []
    for pattern in patterns:
        matches = glob.glob(pattern, recursive=True)
        all_matches.extend(matches)
    if all_matches:
        all_matches = list(set(all_matches))
        all_matches.sort(key=os.path.getmtime, reverse=True)
        return all_matches[0]
    return None


def upload_bundle(aab_path=None, track='internal', status='completed', update_listings=False):
    if not os.path.exists(KEY_FILE):
        print(f"BLAD: Nie znaleziono pliku klucza API: {KEY_FILE}")
        sys.exit(1)

    if not aab_path:
        aab_path = find_aab()

    if not aab_path or not os.path.exists(aab_path):
        print("BLAD: Nie znaleziono pliku AAB do wyslania!")
        print("Uruchom najpierw: .\\build-android-release.ps1, aby zbudowac paczke.")
        sys.exit(1)

    print("=== Automatyczny upload nOpenRA Mobile do Google Play Console ===")
    print(f"Pakiet (ApplicationId): {PACKAGE_NAME}")
    print(f"Plik paczki: {aab_path}")
    print(f"Rozmiar: {os.path.getsize(aab_path) / (1024*1024):.2f} MB")
    print(f"Sciezka (Track): {track}")

    # Weryfikacja czy paczka nie jest przypadkiem podpisana kluczem debug
    try:
        import zipfile
        with zipfile.ZipFile(aab_path, 'r') as z:
            names = z.namelist()
            if any('ANDROIDD.RSA' in n or 'ANDROIDD.SF' in n for n in names):
                print("\n[BLAD KRYTYCZNY] Wykryto podpis kluczem debugującym Android Debug (ANDROIDD.RSA)!")
                print("Paczka musi być podpisana oficjalnym kluczem produkcyjnym (nopenra-upload.keystore).")
                print("Uruchom skrypt .\\build-android-release.ps1 i podaj poprawne hasło do magazynu kluczy.")
                sys.exit(1)
    except Exception as sig_check_err:
        print(f"Ostrzeżenie przy sprawdzaniu podpisu paczki: {sig_check_err}")

    try:
        credentials = service_account.Credentials.from_service_account_file(
            KEY_FILE, scopes=SCOPES
        )
        service = build('androidpublisher', 'v3', credentials=credentials)

        print("\n1. Tworzenie sesji edycji w Google Play...")
        edit = service.edits().insert(body={}, packageName=PACKAGE_NAME).execute()
        edit_id = edit['id']
        print(f"   Sesja utworzona (Edit ID: {edit_id})")

        if update_listings:
            print("\n2. Aktualizacja opisow w sklepie (pl-PL oraz en-US)...")
            for lang, listing_data in STORE_LISTINGS.items():
                try:
                    service.edits().listings().update(
                        packageName=PACKAGE_NAME,
                        editId=edit_id,
                        language=lang,
                        body=listing_data
                    ).execute()
                    print(f"   Zaktualizowano karte sklepu dla jezyka: {lang}")
                except Exception as listing_err:
                    print(f"   Ostrzezenie (pominieto opis {lang}): {listing_err}")

        print("\n3. Przesylanie pakietu AAB do Google Play (moze zajac kilkadziesiat sekund)...")
        version_code = None
        try:
            media = MediaFileUpload(aab_path, mimetype='application/octet-stream', resumable=True)
            bundle_req = service.edits().bundles().upload(
                packageName=PACKAGE_NAME,
                editId=edit_id,
                media_body=media
            )
            bundle_resp = bundle_req.execute()
            version_code = bundle_resp.get('versionCode')
            sha256 = bundle_resp.get('sha256')
            print(f"   SUKCES! Pakiet przeslany! Kod wersji (VersionCode): {version_code}")
            print(f"   SHA-256: {sha256}")
        except HttpError as upload_err:
            err_text = upload_err.content.decode('utf-8', errors='ignore')
            if 'already been used' in err_text:
                bundles_list = service.edits().bundles().list(packageName=PACKAGE_NAME, editId=edit_id).execute()
                existing_bundles = bundles_list.get('bundles', [])
                if existing_bundles:
                    version_code = existing_bundles[-1].get('versionCode')
                    print(f"   Pakiet z kodem wersji {version_code} znajduje sie juz w Google Play Console – uzywam istniejacego pakietu.")
                else:
                    raise
            else:
                print(f"\n[BLAD PRZESYLANIA PAKIETU DO GOOGLE PLAY]\nKod HTTP: {upload_err.status_code}\nOdpowiedź Google: {err_text}")
                raise

        print(f"\n4. Przypisywanie wersji {version_code} do sciezki '{track}'...")
        release_notes = [
            {
                'language': 'pl-PL',
                'text': 'Wersja 1.0.10 naprawia blokowanie ramki zaznaczania obszarowego przy szybkim dotyku/przesuwaniu mapy, eliminuje awarię po sprzedaży budynku z aktywną kolejką lub celem zbiórki (Rally Point) oraz problem zawieszonego procesu/dźwięku po wyjściu z gry. Panel sterowania kolejką budowy działa teraz poprawnie obok menu budowy we wszystkich modach w dopasowanej kolorystyce, a menu Ustawienia zostało ujednolicone pomiędzy wszystkimi modami.'
            },
            {
                'language': 'en-US',
                'text': 'Version 1.0.10 fixes sticky area selection box activation during quick touch panning, resolves a crash when selling buildings with active queues or rally point targeting, ensures clean process and audio shutdown on exit, positions the touch queue control panel beside the build palette with matching mod/faction themes across all mods, and unifies the Settings menu across all mods.'
            }
        ]

        track_body = {
            'track': track,
            'releases': [{
                'name': f"{version_code} (1.0.{version_code - 1})",
                'versionCodes': [str(version_code)],
                'status': status,
                'releaseNotes': release_notes
            }]
        }

        try:
            service.edits().tracks().update(
                packageName=PACKAGE_NAME,
                editId=edit_id,
                track=track,
                body=track_body
            ).execute()
            print(f"   Przypisano wersje do sciezki '{track}' ze statusem '{status}'.")
        except HttpError as track_err:
            track_err_text = track_err.content.decode('utf-8', errors='ignore')
            if 'draft' not in status and ('draft' in track_err_text.lower() or 'not allowed' in track_err_text.lower()):
                print("   Aplikacja wymaga statusu 'draft' w Google Play – zapisuje wydanie ze statusem 'draft'...")
                track_body['releases'][0]['status'] = 'draft'
                service.edits().tracks().update(
                    packageName=PACKAGE_NAME,
                    editId=edit_id,
                    track=track,
                    body=track_body
                ).execute()
                print(f"   Przypisano wersje do sciezki '{track}' ze statusem 'draft'.")
            else:
                raise

        print("\n5. Zatwierdzanie zmian w Google Play Console (Commit)...")
        try:
            service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
        except HttpError as commit_err:
            commit_text = commit_err.content.decode('utf-8', errors='ignore')
            if 'changesnotsentforreview' in commit_text.lower():
                service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id, changesNotSentForReview=True).execute()
            elif 'draft' not in track_body['releases'][0]['status'] and 'draft' in commit_text.lower():
                print("   Zmiana statusu wydania na 'draft' z powodu wymogow Google Play...")
                track_body['releases'][0]['status'] = 'draft'
                service.edits().tracks().update(
                    packageName=PACKAGE_NAME,
                    editId=edit_id,
                    track=track,
                    body=track_body
                ).execute()
                try:
                    service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
                except Exception:
                    service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id, changesNotSentForReview=True).execute()
            else:
                raise
        print("   SUKCES! Zmiany zostaly zatwierdzone w Google Play Console!")
        print("\n========================================================")
        print(f"Wersja {version_code} zostala pomyslnie zapisana w Google Play!")
        print("========================================================")

    except Exception as e:
        print(f"\nBLAD PODCZAS PRZESYLANIA: {e}")
        sys.exit(1)


def update_listings_only():
    if not os.path.exists(KEY_FILE):
        print(f"BLAD: Nie znaleziono pliku klucza API: {KEY_FILE}")
        sys.exit(1)

    print("=== Aktualizacja opisów w Google Play (bez wgrywania nowej paczki AAB) ===")
    print(f"Pakiet (ApplicationId): {PACKAGE_NAME}")

    try:
        credentials = service_account.Credentials.from_service_account_file(
            KEY_FILE, scopes=SCOPES
        )
        service = build('androidpublisher', 'v3', credentials=credentials)

        print("\n1. Tworzenie sesji edycji w Google Play...")
        edit = service.edits().insert(body={}, packageName=PACKAGE_NAME).execute()
        edit_id = edit['id']
        print(f"   Sesja utworzona (Edit ID: {edit_id})")

        print("\n2. Zapisywanie zoptymalizowanych opisów ASO (pl-PL oraz en-US)...")
        for lang, listing_data in STORE_LISTINGS.items():
            try:
                service.edits().listings().update(
                    packageName=PACKAGE_NAME,
                    editId=edit_id,
                    language=lang,
                    body=listing_data
                ).execute()
                print(f"   [OK] Zaktualizowano kartę sklepu dla języka: {lang}")
            except Exception as listing_err:
                print(f"   [BŁĄD] Nie udało się zaktualizować {lang}: {listing_err}")

        print("\n3. Zatwierdzanie zmian w Google Play Console (Commit)...")
        try:
            service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
        except HttpError as commit_err:
            commit_text = commit_err.content.decode('utf-8', errors='ignore')
            if 'changesnotsentforreview' in commit_text.lower():
                service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id, changesNotSentForReview=True).execute()
            else:
                raise

        print("\n========================================================")
        print("SUKCES! Opisy i słowa kluczowe w Sklepie Play zostały zaktualizowane!")
        print("========================================================")

    except Exception as e:
        print(f"\nBLAD PODCZAS AKTUALIZACJI OPISOW: {e}")
        sys.exit(1)


if __name__ == '__main__':
    import argparse
    parser = argparse.ArgumentParser(description="Upload nOpenRA Mobile AAB to Google Play Console")
    parser.add_argument("aab", nargs="?", default=None, help="Path to .aab file or track name (internal/production)")
    parser.add_argument("--track", default="internal", choices=["internal", "production", "alpha", "beta"], help="Track to assign (default: internal)")
    parser.add_argument("--status", default="completed", choices=["completed", "draft", "halted", "inProgress"], help="Release status (default: completed)")
    parser.add_argument("--update-listings", action="store_true", default=False, help="Update store listing descriptions")
    parser.add_argument("--listings-only", action="store_true", default=False, help="Update store listings ONLY (without uploading AAB)")
    args, unknown = parser.parse_known_args()

    if args.listings_only:
        update_listings_only()
        sys.exit(0)

    aab_path = args.aab
    track_name = args.track
    if aab_path in ["internal", "production", "alpha", "beta"]:
        track_name = aab_path
        aab_path = None

    upload_bundle(aab_path=aab_path, track=track_name, status=args.status, update_listings=args.update_listings)
