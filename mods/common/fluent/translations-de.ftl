## ====================================================================
## Deutsche Übersetzung für OpenRA (nOpenRA Mobile)
## ====================================================================

## Allgemeine Schaltflächen (Common Buttons)
button-cancel = Abbrechen
button-retry = Wiederholen
button-back = Zurück
button-continue = Weiter
button-quit = Beenden
button-ok = OK
button-close = Schließen
button-prompt-confirm = Bestätigen
button-prompt-other = Neustart
button-text-input-prompt-accept = OK
button-container-ok = OK

## Mod- & Inhaltsmanager (Mod Manager)
label-mod-manager-title = Mod- & Inhaltsmanager
button-tab-installed-mods = Installierte Mods
button-tab-download-mods = Mods herunterladen
button-tab-storage-folder = Speicher- & Kartenordner
button-mod-active = Aktiv
button-mod-switch = Wechseln
label-mod-active-tag = [AKTIV]
label-mod-version = Version
button-refresh-list = Liste aktualisieren
label-download-desc = Direkte URL des Mod-Archivs (.zip oder .oramod) eingeben:
button-paste-link = Link einfügen
button-download-install = Herunterladen & Installieren
label-ready-download = Bereit zum Herunterladen
label-popular-mods = Beliebte OpenRA-Mods (zum Einfügen antippen):
label-storage-desc-1 = Hauptverzeichnis für Mods (/mods) und Karten (/maps):
label-storage-desc-2 = Unter neuem Android ist /Android/data/ gesperrt. Wähle einen Ordner im gemeinsamen Speicher:
label-storage-presets = Schnellauswahl (antippen):
button-storage-shared = Interner Speicher (/storage/emulated/0/OpenRA)
button-storage-download = Download-Ordner (/storage/emulated/0/Download/OpenRA)
button-storage-documents = Dokumente-Ordner (/storage/emulated/0/Documents/OpenRA)
button-storage-default = Standard-App-Verzeichnis
button-save-create-folders = Speichern & Ordner erstellen
button-mods-title = Mods
label-storage-error-empty = Fehler: Pfad darf nicht leer sein.
label-storage-saved = Gespeichert! Ordner /mods und /maps erstellt.
label-download-error-url = Fehler: Ungültige URL.
label-download-error-protocol = Fehler: Nur HTTP und HTTPS werden unterstützt.
label-download-connecting = Verbinde mit Server...
label-download-installing = Installiere und entpacke...
label-download-success = Mod erfolgreich installiert!

## Spracheinstellungen (Language Settings)
button-panel-language = Sprache
label-language-section-header = SPRACHE & ÜBERSETZUNGEN
label-select-language = Sprache:
label-language-restart-info = Wähle die Sprache der Anwendung. Mod-Manager, Einstellungen und übersetzte Oberflächentexte werden sofort aktualisiert.
button-language-en = English
button-language-pl = Polski
button-language-de = Deutsch
button-language-es = Español
button-language-fr = Français
button-language-pt = Português
button-language-it = Italiano
button-language-ru = Русский

## Hauptmenü (Main Menu)
label-singleplayer-title = Einzelspieler
label-multiplayer-title = Mehrspieler
button-settings-title = Einstellungen
button-extras-title = Extras
button-main-menu-content = Inhalte verwalten
button-singleplayer-menu-skirmish = Gefecht
button-singleplayer-menu-load = Spiel laden
label-missions-title = Missionen
button-extras-menu-replays = Wiederholungen
label-music-title = Musik
label-map-editor-title = Karteneditor
button-extras-menu-assetbrowser = Asset-Browser
label-credits-title = Mitwirkende
button-map-editor-new-map = Neue Karte
button-map-editor-load-map = Karte laden
dropdownbutton-news-bg-button = Schlachtfeld-Nachrichten
label-loading-news = Lade Nachrichten...

## Einstellungen-Tabs (Settings Tabs)
button-settings-panel-reset = Zurücksetzen
button-panel-gameplay = Gameplay
button-panel-input = Steuerung
button-panel-display = Anzeige
button-panel-audio = Audio
button-panel-hotkeys = Hotkeys
button-panel-advanced = Erweitert

## Einstellungen - Steuerung (Input Settings)
label-input-section-header = Steuerung
label-touch-hold-duration-slider = Verzögerung für Auswahlrahmen (Halten):
label-touch-navigation-title = Mobile Touch-Steuerung
label-touch-desc-tap = - Einmal tippen: Einheiten/Gebäude auswählen, Bewegungs- oder Angriffsbefehl
label-touch-desc-swipe = - Wischen (Swipe): Kamera flüssig über das Schlachtfeld bewegen (PAN)
label-touch-desc-pinch = - Zwei Finger (Pinch): Hinein- und Herauszoomen
label-touch-desc-hold = - Gedrückt halten (Hold): Auswahlrahmen aktivieren
label-mouse-control-container = Steuerungsschema:
label-zoom-modifier-container = Zoom-Modifikator:
checkbox-edgescroll-container = Bildschirmrand-Scrollen
checkbox-alternate-scroll-container = Alternatives Maus-Scrollen
checkbox-lockmouse-container = Maus im Fenster sperren
label-mouse-scroll-type-container = Scroll-Verhalten:
label-scrollspeed-slider-container-scroll-speed = Scroll-Geschwindigkeit:
label-zoomspeed-slider-container-zoom-speed = Zoom-Geschwindigkeit:
label-ui-scrollspeed-slider-container-scroll-speed = UI-Scroll-Geschwindigkeit:

options-mouse-scroll-type =
    .disabled = Deaktiviert
    .standard = Standard
    .inverted = Invertiert
    .joystick = Joystick

options-control-scheme =
    .classic = Klassisch
    .modern = Modern
    .otherrts = Anderes RTS

## Einstellungen - Gameplay & Profil (Gameplay & Profile Settings)
label-profile-section-header = Profil
label-player-container = Spielername:
label-playercolor-container-color = Bevorzugte Farbe:
label-gameplay-section-header = Gameplay
label-auto-save-interval = Autom. Speichern alle:
label-auto-save-max-file-number = Max. Autospeicherungen:
checkbox-hide-replay-chat-container = Chat in Wiederholungen ausblenden
label-forum-profile-section-header = OpenRA-Forenkonto
label-forum-profile-username = Benutzername:
label-forum-profile-password = Passwort:
button-forum-profile-link = Konto verknüpfen
button-forum-profile-unlink = Verknüpfung aufheben
button-forum-profile-retry = Wiederholen
button-forum-visit-forum = Forum besuchen

auto-save-interval =
    .disabled = Deaktiviert
    .options =
        { $seconds ->
            [one] 1 Sekunde
           *[other] { $seconds } Sek.
        }
    .minute-options =
        { $minutes ->
            [one] 1 Minute
           *[other] { $minutes } Min.
        }

auto-save-max-file-number = { $saves } Spielstände

## Einstellungen - Anzeige (Display Settings)
label-display-section-header = Anzeige
label-battlefield-camera-dropdown = Schlachtfeldkamera:
label-ui-scale-dropdown = UI-Skalierung:
checkbox-cursordouble-container = Cursorgröße verdoppeln
label-target-lines-dropdown-container = Ziellinien:
label-status-bar-dropdown-container-bars = Statusleisten:

checkbox-player-stance-colors-container =
    .label = Beziehungsfarben der Spieler
    .tooltip = Spielerfarben je nach Beziehung ändern (eigene, Feind, Verbündeter, neutral)

checkbox-ui-feedback-container =
    .label = UI-Feedback-Benachrichtigungen anzeigen
    .tooltip = Kurze Textbenachrichtigungen für UI-Ereignisse anzeigen

checkbox-transients-container =
    .label = Spielereignis-Benachrichtigungen anzeigen
    .tooltip = Kurze Textbenachrichtigungen für Spielereignisse anzeigen

checkbox-pause-shellmap-container = Menühintergrund pausieren
label-video-section-header = Video
label-video-mode-dropdown-container = Videomodus:
dropdownbutton-video-mode-dropdown-container = Fenstermodus
label-window-resolution-container-size = Fenstergröße:
label-resolution-preset = Vorlagen:
dropdownbutton-resolution-select-preset = Vorlage wählen
label-display-selection-container = Bildschirm wählen:
checkbox-vsync-container = VSync aktivieren
checkbox-frame-limit-gamespeed-container = Bildrate auf Spieltakt begrenzen
label-gl-profile-dropdown-container = OpenGL-Profil:
label-restart-required-container-video-desc = Anzeige- und OpenGL-Änderungen erfordern einen Neustart
checkbox-frame-limiter = Bildratenbegrenzer ({ $fps } FPS)

options-camera =
    .close = Nah
    .medium = Mittel
    .far = Weit
    .furthest = Sehr weit

options-display-mode =
    .windowed = Fenstermodus
    .legacy-fullscreen = Vollbild (Klassisch)
    .fullscreen = Vollbild

options-status-bars =
    .standard = Standard
    .show-on-damage = Bei Schaden anzeigen
    .always-show = Immer anzeigen

options-target-lines =
    .automatic = Automatisch
    .manual = Manuell
    .disabled = Deaktiviert

## Einstellungen - Audio (Audio Settings)
label-audio-section-header = Audio
label-no-audio-device-container = Audiosteuerung erfordert ein aktives Audiogerät
checkbox-cash-ticks-container = Geld-Tickgeräusche
checkbox-mute-sound-container = Ton stummschalten
label-sound-volume-container = Effektlautstärke:

checkbox-mute-background-music-container =
    .label = Menümusik stummschalten
    .tooltip = Hintergrundmusik stummschalten, wenn kein Titel läuft

label-music-title-volume-container = Musiklautstärke:
label-audio-device-container = Audiogerät:
label-video-volume-container = Videolautstärke:
label-restart-required-container-audio-desc = Geräteänderungen werden nach einem Neustart wirksam

## Einstellungen - Erweitert (Advanced Settings)
label-network-section-header = Erweitert
checkbox-nat-discovery-container = UPnP/NAT-PMP-Erkennung aktivieren
checkbox-fetch-news-container = Community-Nachrichten abrufen
checkbox-perfgraph-container = Leistungsdiagramm anzeigen
checkbox-check-version-container = Nach Updates suchen
checkbox-perftext-container = Leistungstext (FPS) anzeigen
checkbox-sendsysinfo-container = Systeminformationen senden
checkbox-enable-discord-service-container = Discord Rich Presence aktivieren
label-debug-section-header = Entwickler

## Bestätigungsdialoge (Confirmation Dialogs)
dialog-settings-save =
    .title = Neustart erforderlich
    .prompt = Einige Änderungen werden erst nach einem Neustart wirksam.
    .cancel = Weiter

dialog-settings-restart =
    .title = Jetzt neu starten?
    .prompt = Einige Änderungen erfordern einen Neustart. Jetzt neu starten?
    .confirm = Jetzt neu starten
    .cancel = Später neu starten

dialog-settings-reset =
    .title = { $panel } zurücksetzen
    .prompt = Möchtest du wirklich alle Einstellungen in diesem Bereich zurücksetzen?
    .confirm = Zurücksetzen
    .cancel = Abbrechen

## Lobby, Gefecht & Mehrspieler (Lobby, Skirmish & Multiplayer)
dropdownbutton-server-lobby-slots = Slot-Verwaltung
button-server-lobby-reset-options = Standardwerte
button-skirmish-tabs-players-tab = Spieler
button-skirmish-tabs-options-tab = Optionen
button-multiplayer-tabs-players-tab = Spieler
button-multiplayer-tabs-options-tab = Optionen
button-multiplayer-tabs-servers-tab = Server
button-server-lobby-changemap = Karte ändern
button-server-lobby-start-game = Spiel starten
button-server-lobby-disconnect = Spiel verlassen
label-lobby-options-bin-title = Kartenoptionen
label-lobby-players-name = Name
label-lobby-players-color = Farbe
label-lobby-players-faction = Fraktion
label-lobby-players-team = Team
label-lobby-players-handicap = Handicap
label-lobby-players-spawn = Startpunkt
label-lobby-players-ready = Bereit
button-lobby-players-join = In diesem Slot spielen
label-lobby-players-spectator = Zuschauer
checkbox-lobby-players-new-spectator-toggle = Zuschauer erlauben?
button-lobby-players-spectate = Zuschauen
label-bot-player = KI-Spieler

options-slot-admin =
    .add-bots = Bots hinzufügen
    .remove-bots = Bots entfernen
    .configure-bots = Bots konfigurieren
    .teams-count = { $count } Teams
    .humans-vs-bots = Menschen gegen Bots
    .free-for-all = Jeder gegen jeden
    .configure-teams = Teams konfigurieren

options-lobby-slot =
    .slot = Slot
    .open = Offen
    .closed = Geschlossen
    .bots = Bots
    .bots-disabled = Bots deaktiviert

options-game-speed =
    .slowest = Am langsamsten
    .slower = Langsamer
    .normal = Normal
    .fast = Schnell
    .faster = Schneller
    .fastest = Am schnellsten

options-time-limit =
    .no-limit = Kein Limit
    .options =
        { $minutes ->
            [one] { $minutes } Minute
           *[other] { $minutes } Minuten
        }

## Spielregeln (Rules Options in Lobby)
checkbox-fog-of-war =
    .label = Nebel des Krieges
    .description = Sichtlinie ist erforderlich, um feindliche Truppen zu sehen

checkbox-explored-map =
    .label = Erkundete Karte
    .description = Die Karte ist zu Beginn bereits aufgedeckt

checkbox-debug-menu =
    .label = Cheats
    .description = Aktiviert Cheats und Entwicklerbefehle

checkbox-crates =
    .label = Bonuskisten
    .description = Sammle Kisten für zufällige Boni oder Effekte

checkbox-ally-build-radius =
    .label = Bei Verbündeten bauen
    .description = Erlaubt das Platzieren von Gebäuden im Baubereich von Verbündeten

checkbox-build-radius =
    .label = Baubereich begrenzen
    .description = Begrenzt den Gebäudebau auf den Bereich um den Bauhof

checkbox-short-game =
    .label = Kurzes Spiel
    .description = Spieler sind besiegt, sobald ihre Basis zerstört wurde

dropdown-tech-level =
    .label = Technologiestufe
    .description = Verfügbare Einheiten und Fähigkeiten im Spiel

dropdown-game-speed =
    .label = Spielgeschwindigkeit
    .description = Bestimmt, wie schnell die Zeit im Spiel vergeht

checkbox-separate-team-spawns =
    .label = Getrennte Team-Startpunkte
    .description = Spieler ohne festen Startpunkt starten möglichst weit weg vom Feind

dropdown-starting-units =
    .label = Starteinheiten
    .description = Einheiten, mit denen Spieler das Match beginnen

dropdown-time-limit =
    .label = Zeitlimit
    .description = Der Spieler oder das Team mit der höchsten Punktzahl gewinnt nach Ablauf der Zeit

## Kartenauswahl & Missionen (Map Chooser & Mission Browser)
label-mapchooser-panel-title = Karte wählen
label-filter-order-controls-desc = Filter:
label-filter-order-controls-orderby = Sortieren:
button-mapchooser-panel-randommap = Zufallskarte
button-mapchooser-panel-delete-map = Karte löschen
button-mapchooser-panel-delete-all-maps = Alle löschen
button-mapchooser-panel-ok = OK
button-mapchooser-system-maps-tab = Offizielle Karten
button-mapchooser-remote-maps-tab = Server-Karten
button-mapchooser-user-maps-tab = Eigene Karten
button-mapchooser-generated-maps-tab = Karte generieren
label-all-maps = Alle Karten
label-no-matches = Keine Treffer
label-created-by = Erstellt von { $author }
label-map-size-huge = Riesig
label-map-size-large = Groß
label-map-size-medium = Mittel
label-map-size-small = Klein

options-order-maps =
    .player-count = Spieler
    .title = Titel
    .date = Datum
    .size = Größe

button-missionbrowser-panel-start-briefing-video = Einsatzbesprechung
button-missionbrowser-panel-stop-briefing-video = Video stoppen
button-missionbrowser-panel-start-info-video = Infovideo ansehen
button-missionbrowser-panel-stop-info-video = Infovideo stoppen
button-missionbrowser-panel-play = Spielen
button-missionbrowser-panel-mission-info = Missionsinfo
button-missionbrowser-panel-mission-options = Optionen
dropdown-missionbrowser-difficulty =
    .label = Schwierigkeitsgrad
    .description = Schwierigkeitsgrad der Mission
dropdown-missionbrowser-gamespeed = Tempo:
label-missionbrowser-normal-difficulty = Normal

## Speichern/Laden & Wiederholungen (Save/Load & Replays)
label-gamesave-browser-panel-load-title = Spiel laden
label-gamesave-browser-panel-save-title = Spiel speichern
button-gamesave-browser-panel-delete-all = Alle löschen
button-gamesave-browser-panel-delete = Löschen
button-gamesave-browser-panel-rename = Umbenennen
button-gamesave-browser-panel-load = Laden
button-gamesave-browser-panel-save = Speichern
label-load-game-browser-panel-title = Spiel laden
label-load-game-browser-panel-choose-save = Spielstand wählen
button-load-game-browser-panel-load = Laden
label-replaybrowser-panel-title = Wiederholungen
button-replaybrowser-panel-watch = Ansehen

## Spielmenü & HUD (In-Game Menu & HUD)
label-menu-buttons-title = Optionen
button-top-buttons-options-tooltip = Optionen
button-top-buttons-beacon-tooltip = Signal setzen
button-top-buttons-sell-tooltip = Verkaufen
button-top-buttons-power-tooltip = Strom abschalten
button-top-buttons-repair-tooltip = Reparieren
button-production-types-building-tooltip = Gebäude
button-production-types-defense-tooltip = Verteidigung
button-production-types-infantry-tooltip = Infanterie
button-production-types-vehicle-tooltip = Fahrzeuge
button-production-types-aircraft-tooltip = Flugzeuge
button-production-types-naval-tooltip = Marine
label-mute-indicator = Ton stummgeschaltet
label-paused = Pausiert

supportpowers-support-powers-palette =
    .ready = BEREIT
    .hold = ANGEHALTEN

productionpalette-sidebar-production-palette =
    .ready = BEREIT
    .hold = ANGEHALTEN

menu-ingame =
    .leave = Verlassen
    .abort = Mission abbrechen
    .restart = Neu starten
    .surrender = Aufgeben
    .load-game = Spiel laden
    .save-game = Spiel speichern
    .music = Musik
    .settings = Einstellungen
    .return-to-map = Zurück zur Karte
    .resume = Fortsetzen
    .save-map = Karte speichern
    .exit-map = Editor verlassen
    .next-mission = Nächste Mission

menu-game-info =
    .objectives = Missionsziele
    .briefing = Besprechung
    .options = Optionen
    .debug = Cheats
    .chat = Chat

label-mission-objectives = Mission:
label-mission-objective = Mission:
checkbox-stats-objective = Vernichte alle feindlichen Truppen!
label-stats-player = Spieler
label-stats-faction = Fraktion
label-stats-score = Punkte
label-stats-actions = Aktionen
label-mission-in-progress = Läuft
label-mission-accomplished = Erfüllt
label-mission-failed = Gescheitert

dialog-leave-mission =
    .title = Mission verlassen
    .prompt = Spiel verlassen und zum Hauptmenü zurückkehren?
    .confirm = Verlassen
    .cancel = Bleiben

dialog-restart-mission =
    .title = Neu starten
    .prompt = Möchtest du die Mission wirklich neu starten?
    .confirm = Neu starten
    .cancel = Bleiben

dialog-surrender =
    .title = Aufgeben
    .prompt = Möchtest du wirklich aufgeben?
    .confirm = Aufgeben
    .cancel = Bleiben

label-profile-link-desc-a = Verknüpfen Sie ein Forenkonto, um sich
label-profile-link-desc-b = anderen Spielern gegenüber zu identifizieren,
label-profile-link-desc-c = privaten Servern beizutreten und Abzeichen anzuzeigen.
button-profile-link = Mit OpenRA-Forenkonto verknüpfen
button-profile-unlink = Forenkonto trennen
label-forum-profile-description = Verknüpfen Sie ein Forenkonto, um sich anderen Spielern gegenüber zu identifizieren und Abzeichen anzuzeigen.
label-forum-profile-result-unlinked = Konto ist nicht mit einem OpenRA-Forenprofil verknüpft.
label-sendsysinfo-checkbox-container-desc = Anonyme Systemdaten helfen den Entwicklern, OpenRA zu verbessern.
label-debug-hidden-container-a = Zusätzliche Entwickleroptionen können über die
label-debug-hidden-container-b = Befehlszeile oder in der Datei settings.yaml aktiviert werden.
