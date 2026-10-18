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
        os.path.join("bin", "Release", "net10.0-android", "**", "*Signed.aab"),
        os.path.join("bin", "net10.0-android", "**", "*Signed.aab"),
        os.path.join("OpenRA.Android", "bin", "Release", "net10.0-android", "**", "*Signed.aab"),
    ]
    for pattern in patterns:
        matches = glob.glob(pattern, recursive=True)
        if matches:
            matches.sort(key=os.path.getmtime, reverse=True)
            return matches[0]
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
            if 'already been used' in err_text or upload_err.status_code == 403 or upload_err.status_code == 400:
                bundles_list = service.edits().bundles().list(packageName=PACKAGE_NAME, editId=edit_id).execute()
                existing_bundles = bundles_list.get('bundles', [])
                if existing_bundles:
                    version_code = existing_bundles[-1].get('versionCode')
                    print(f"   Pakiet z kodem wersji {version_code} znajduje sie juz w Google Play Console – uzywam istniejacego pakietu.")
                else:
                    raise
            else:
                raise

        print(f"\n4. Przypisywanie wersji {version_code} do sciezki '{track}'...")
        release_notes = [
            {
                'language': 'pl-PL',
                'text': 'Wydanie nOpenRA Mobile (RTS Engine): sterowanie dotykowe, menedżer modów i tłumaczenia PL/EN.'
            },
            {
                'language': 'en-US',
                'text': 'nOpenRA Mobile (RTS Engine) release: touch controls, in-game mod manager, and EN/PL localization.'
            }
        ]

        for attempt_status in [status, 'draft']:
            track_body = {
                'track': track,
                'releases': [{
                    'name': f"{version_code} (1.0.{version_code - 1})",
                    'versionCodes': [str(version_code)],
                    'status': attempt_status,
                    'releaseNotes': release_notes
                }]
            }
            service.edits().tracks().update(
                packageName=PACKAGE_NAME,
                editId=edit_id,
                track=track,
                body=track_body
            ).execute()
            try:
                service.edits().validate(packageName=PACKAGE_NAME, editId=edit_id).execute()
                print(f"   Przypisano wersje do sciezki '{track}' ze statusem '{attempt_status}'.")
                break
            except HttpError as val_err:
                val_text = val_err.content.decode('utf-8', errors='ignore')
                if attempt_status != 'draft' and 'draft app' in val_text:
                    print("   Aplikacja w Google Play ma jeszcze status 'Draft app' (wymaga dokonczenia deklaracji w konsoli) – zapisuje wydanie ze statusem 'draft'.")
                    continue
                raise

        print("\n5. Zatwierdzanie zmian w Google Play Console (Commit)...")
        try:
            service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id, changesNotSentForReview=True).execute()
        except Exception:
            service.edits().commit(packageName=PACKAGE_NAME, editId=edit_id).execute()
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
