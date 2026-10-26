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
        'title': 'nOpenRA Mobile (RTS Engine)',
        'shortDescription': 'Mobilny port otwartoźródłowego silnika strategii czasu rzeczywistego OpenRA.',
        'fullDescription': (
            'nOpenRA Mobile to otwartoźródłowy port silnika strategii czasu rzeczywistego (RTS) OpenRA '
            'przystosowany do ekranów dotykowych systemu Android.\n\n'
            'NAJWAŻNIEJSZE FUNKCJE:\n'
            '• Dedykowane sterowanie dotykowe: płynne przewijanie mapy (swipe), przybliżanie dwoma palcami (pinch-to-zoom) '
            'oraz zaznaczanie obszarowe z kołowym wskaźnikiem przytrzymania.\n'
            '• Panel szybkich akcji: przycisk zaznaczania wszystkich jednostek na ekranie (ALL), szybkie odznaczanie (X) '
            'oraz 5 grup jednostek z licznikami na żywo.\n'
            '• Wbudowany Menedżer Modów: przełączanie aktywnej gry i modyfikacji w locie bez restartu aplikacji, '
            'pobieranie modów społeczności z sieci oraz wybór własnego folderu danych i map.\n'
            '• Wielojęzyczny interfejs: obsługa języka polskiego i angielskiego.\n\n'
            'INFORMACJE PRAWNE I LICENCJA (GPLv3):\n'
            'To jest nieoficjalny, tworzony przez społeczność port otwartoźródłowego silnika OpenRA, '
            'udostępniany na licencji GNU General Public License v3.0 (GPLv3).\n'
            'Kod źródłowy: https://github.com/nurbsn/OpenRA.Android\n\n'
            'OŚWIADCZENIE (DISCLAIMER):\n'
            'Aplikacja nie jest powiązana, wspierana ani autoryzowana przez Electronic Arts Inc., Westwood Studios '
            'ani oficjalny zespół OpenRA. Nazwy Command & Conquer, Red Alert, Tiberian Dawn oraz Dune 2000 są '
            'zastrzeżonymi znakami towarowymi odpowiednich właścicieli i zostały użyte wyłącznie w celach informacyjnych '
            'dotyczących kompatybilności silnika.'
        )
    },
    'en-US': {
        'title': 'nOpenRA Mobile (RTS Engine)',
        'shortDescription': 'Mobile port of the open-source OpenRA Real-Time Strategy game engine.',
        'fullDescription': (
            'nOpenRA Mobile is a community-driven Android port of the open-source OpenRA Real-Time Strategy (RTS) '
            'engine featuring touch-first controls and hardware-accelerated OpenGL ES graphics.\n\n'
            'KEY FEATURES:\n'
            '• Touch-First Controls: smooth swipe camera scrolling, two-finger pinch-to-zoom, and hold-to-box-select '
            'with a customizable circular progress indicator.\n'
            '• Quick Action Bar: select all visible units (ALL), clear selection (X), and manage 5 control groups '
            'with live unit counters.\n'
            '• Built-in Mod & Content Manager: switch active mods in-process without restarting, download community '
            'mods from URLs, and configure custom storage directories for maps and mods.\n'
            '• Multilingual UI: full support for English and Polish.\n\n'
            'OPEN SOURCE & LICENSE (GPLv3):\n'
            'This application is distributed under the GNU General Public License v3.0 (GPLv3).\n'
            'Source code: https://github.com/nurbsn/OpenRA.Android\n\n'
            'LEGAL DISCLAIMER:\n'
            'This is an unofficial community port of the OpenRA engine and is not affiliated with, endorsed, or '
            'sponsored by Electronic Arts Inc., Westwood Studios, or the official OpenRA project. '
            'Command & Conquer, Red Alert, Tiberian Dawn, and Dune 2000 are registered trademarks of their '
            'respective owners and are referenced solely to indicate engine compatibility.'
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


def upload_bundle(aab_path=None, track='production', status='completed', update_listings=True):
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
                'text': 'Zintegrowane podstawowe zasoby gry dla natychmiastowego startu offline bez konieczności pobierania, pełna kompatybilność z Android 15 oraz poprawki stabilności.'
            },
            {
                'language': 'en-US',
                'text': 'Integrated core game assets for immediate offline startup without additional downloads, Android 15 compatibility, and stability improvements.'
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
            service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id, changesNotSentForReview=True).execute()
        except HttpError as commit_err:
            commit_text = commit_err.content.decode('utf-8', errors='ignore')
            if 'draft' not in track_body['releases'][0]['status'] and 'draft' in commit_text.lower():
                print("   Zmiana statusu wydania na 'draft' z powodu wymogow Google Play...")
                track_body['releases'][0]['status'] = 'draft'
                service.edits().tracks().update(
                    packageName=PACKAGE_NAME,
                    editId=edit_id,
                    track=track,
                    body=track_body
                ).execute()
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


if __name__ == '__main__':
    aab = sys.argv[1] if len(sys.argv) > 1 else None
    upload_bundle(aab)
