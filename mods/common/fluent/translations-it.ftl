## ====================================================================
## Traduzione italiana per OpenRA (nOpenRA Mobile)
## ====================================================================

## Pulsanti generali (Common Buttons)
button-cancel = Annulla
button-retry = Riprova
button-back = Indietro
button-continue = Continua
button-quit = Esci
button-ok = OK
button-close = Chiudi
button-prompt-confirm = Conferma
button-prompt-other = Riavvia
button-text-input-prompt-accept = OK
button-container-ok = OK

## Gestore Mod e Contenuti (Mod Manager)
label-mod-manager-title = Gestore Mod e Contenuti
button-tab-installed-mods = Mod installate
button-tab-download-mods = Scarica Mod
button-tab-storage-folder = Cartella Dati e Mappe
button-mod-active = Attiva
button-mod-switch = Cambia
label-mod-active-tag = [ATTIVA]
label-mod-version = versione
button-refresh-list = Aggiorna lista
label-download-desc = Inserisci l'URL diretto dell'archivio della mod (.zip o .oramod):
button-paste-link = Incolla link
button-download-install = Scarica e Installa
label-ready-download = Pronto per il download
label-popular-mods = Mod popolari di OpenRA (tocca per inserire il link):
label-storage-desc-1 = Cartella principale per le mod (/mods) e le mappe (/maps):
label-storage-desc-2 = Nelle versioni recenti di Android /Android/data/ è bloccata. Scegli una cartella condivisa:
label-storage-presets = Posizioni rapide (tocca per scegliere):
button-storage-shared = Memoria interna (/storage/emulated/0/OpenRA)
button-storage-download = Cartella Download (/storage/emulated/0/Download/OpenRA)
button-storage-documents = Cartella Documenti (/storage/emulated/0/Documents/OpenRA)
button-storage-default = Cartella predefinita dell'app
button-save-create-folders = Salva e Crea Cartelle
button-mods-title = Mod
label-storage-error-empty = Errore: il percorso non può essere vuoto.
label-storage-saved = Salvato! Cartelle /mods e /maps create.
label-download-error-url = Errore: URL non valido.
label-download-error-protocol = Errore: Sono supportati solo i protocolli HTTP e HTTPS.
label-download-connecting = Connessione al server...
label-download-installing = Installazione ed estrazione...
label-download-success = Mod installata con successo!

## Impostazioni lingua (Language Settings)
button-panel-language = Lingua
label-language-section-header = LINGUA E TRADUZIONI
label-select-language = Lingua:
label-language-restart-info = Seleziona la lingua dell'applicazione. Il gestore mod, le impostazioni e l'interfaccia tradotta verranno aggiornati immediatamente.
button-language-en = English
button-language-pl = Polski
button-language-de = Deutsch
button-language-es = Español
button-language-fr = Français
button-language-pt = Português
button-language-it = Italiano
button-language-ru = Русский

## Menu principale (Main Menu)
label-singleplayer-title = Giocatore singolo
label-multiplayer-title = Multigiocatore
button-settings-title = Impostazioni
button-extras-title = Extra
button-main-menu-content = Gestisci contenuti
button-singleplayer-menu-skirmish = Schermaglia
button-singleplayer-menu-load = Carica partita
label-missions-title = Missioni
button-extras-menu-replays = Replay
label-music-title = Musica
label-map-editor-title = Editor mappe
button-extras-menu-assetbrowser = Esplora risorse
label-credits-title = Riconoscimenti
button-map-editor-new-map = Nuova mappa
button-map-editor-load-map = Carica mappa
dropdownbutton-news-bg-button = Notizie dal fronte
label-loading-news = Caricamento notizie...

## Schede impostazioni (Settings Tabs)
button-settings-panel-reset = Ripristina
button-panel-gameplay = Gioco
button-panel-input = Comandi
button-panel-display = Schermo
button-panel-audio = Audio
button-panel-hotkeys = Scorciatoie
button-panel-advanced = Avanzate

## Impostazioni - Comandi (Input Settings)
label-input-section-header = Comandi
label-touch-hold-duration-slider = Ritardo pressione per riquadro selezione:
label-touch-navigation-title = Comandi touch mobili
label-touch-desc-tap = - Tocco singolo: Seleziona unità/edifici, muovi o attacca
label-touch-desc-swipe = - Scorri (Swipe): Sposta la visuale sulla mappa (PAN)
label-touch-desc-pinch = - Pizzica (Pinch): Ingrandisci e riduci con due dita
label-touch-desc-hold = - Tieni premuto (Hold): Attiva selezione rettangolare
label-mouse-control-container = Schema di controllo:
label-zoom-modifier-container = Modificatore zoom:
checkbox-edgescroll-container = Scorrimento ai bordi dello schermo
checkbox-alternate-scroll-container = Scorrimento mouse alternativo
checkbox-lockmouse-container = Blocca mouse nella finestra
label-mouse-scroll-type-container = Comportamento scorrimento:
label-scrollspeed-slider-container-scroll-speed = Velocità visuale:
label-zoomspeed-slider-container-zoom-speed = Velocità zoom:
label-ui-scrollspeed-slider-container-scroll-speed = Velocità scorrimento UI:

options-mouse-scroll-type =
    .disabled = Disabilitato
    .standard = Standard
    .inverted = Invertito
    .joystick = Joystick

options-control-scheme =
    .classic = Classico
    .modern = Moderno
    .otherrts = Altro RTS

## Impostazioni - Gioco e Profilo (Gameplay & Profile Settings)
label-profile-section-header = Profilo
label-player-container = Nome giocatore:
label-playercolor-container-color = Colore preferito:
label-gameplay-section-header = Gioco
label-auto-save-interval = Frequenza salvataggio auto:
label-auto-save-max-file-number = Limite salvataggi auto:
checkbox-hide-replay-chat-container = Nascondi chat nei replay
label-forum-profile-section-header = Account Forum OpenRA
label-forum-profile-username = Nome utente:
label-forum-profile-password = Password:
button-forum-profile-link = Collega account
button-forum-profile-unlink = Scollega account
button-forum-profile-retry = Riprova
button-forum-visit-forum = Visita il forum

auto-save-interval =
    .disabled = Disabilitato
    .options =
        { $seconds ->
            [one] 1 secondo
           *[other] { $seconds } s
        }
    .minute-options =
        { $minutes ->
            [one] 1 minuto
           *[other] { $minutes } min
        }

auto-save-max-file-number = { $saves } salvataggi

## Impostazioni - Schermo (Display Settings)
label-display-section-header = Schermo
label-battlefield-camera-dropdown = Visuale campo di battaglia:
label-ui-scale-dropdown = Scala interfaccia (UI):
checkbox-cursordouble-container = Ingrandisci cursore
label-target-lines-dropdown-container = Linee bersaglio:
label-status-bar-dropdown-container-bars = Barre di stato:

checkbox-player-stance-colors-container =
    .label = Colori relazione giocatori
    .tooltip = Cambia i colori in base alla relazione (proprio, nemico, alleato, neutrale)

checkbox-ui-feedback-container =
    .label = Mostra notifiche interfaccia
    .tooltip = Mostra brevi notifiche testuali per gli eventi dell'interfaccia

checkbox-transients-container =
    .label = Mostra notifiche eventi di gioco
    .tooltip = Mostra brevi notifiche testuali per gli eventi di gioco

checkbox-pause-shellmap-container = Metti in pausa sfondo menu
label-video-section-header = Video
label-video-mode-dropdown-container = Modalità video:
dropdownbutton-video-mode-dropdown-container = In finestra
label-window-resolution-container-size = Dimensione finestra:
label-resolution-preset = Predefiniti:
dropdownbutton-resolution-select-preset = Scegli predefinito
label-display-selection-container = Seleziona schermo:
checkbox-vsync-container = Abilita VSync
checkbox-frame-limit-gamespeed-container = Limita FPS alla velocità di gioco
label-gl-profile-dropdown-container = Profilo OpenGL:
label-restart-required-container-video-desc = Le modifiche a schermo e OpenGL richiedono il riavvio
checkbox-frame-limiter = Limitatore fotogrammi ({ $fps } FPS)

options-camera =
    .close = Vicina
    .medium = Media
    .far = Lontana
    .furthest = Molto lontana

options-display-mode =
    .windowed = In finestra
    .legacy-fullscreen = Schermo intero (Classico)
    .fullscreen = Schermo intero

options-status-bars =
    .standard = Standard
    .show-on-damage = Mostra se danneggiato
    .always-show = Mostra sempre

options-target-lines =
    .automatic = Automatiche
    .manual = Manuali
    .disabled = Disabilitate

## Impostazioni - Audio (Audio Settings)
label-audio-section-header = Audio
label-no-audio-device-container = I controlli audio richiedono un dispositivo attivo
checkbox-cash-ticks-container = Suono contatore crediti
checkbox-mute-sound-container = Disattiva audio
label-sound-volume-container = Volume effetti:

checkbox-mute-background-music-container =
    .label = Disattiva musica menu
    .tooltip = Disattiva la musica di sottofondo quando non è in riproduzione alcuna traccia

label-music-title-volume-container = Volume musica:
label-audio-device-container = Dispositivo audio:
label-video-volume-container = Volume video:
label-restart-required-container-audio-desc = Le modifiche al dispositivo verranno applicate al riavvio

## Impostazioni - Avanzate (Advanced Settings)
label-network-section-header = Avanzate
checkbox-nat-discovery-container = Abilita rilevamento UPnP/NAT-PMP
checkbox-fetch-news-container = Scarica notizie della community
checkbox-perfgraph-container = Mostra grafico prestazioni
checkbox-check-version-container = Controlla aggiornamenti
checkbox-perftext-container = Mostra testo prestazioni (FPS)
checkbox-sendsysinfo-container = Invia informazioni di sistema anonime
checkbox-enable-discord-service-container = Abilita Discord Rich Presence
label-debug-section-header = Sviluppatore

## Finestre di conferma (Confirmation Dialogs)
dialog-settings-save =
    .title = Riavvio richiesto
    .prompt = Alcune modifiche non verranno applicate finché il gioco non verrà riavviato.
    .cancel = Continua

dialog-settings-restart =
    .title = Riavviare ora?
    .prompt = Alcune modifiche richiedono il riavvio del gioco. Riavviare ora?
    .confirm = Riavvia ora
    .cancel = Riavvia più tardi

dialog-settings-reset =
    .title = Ripristina { $panel }
    .prompt = Sei sicuro di voler ripristinare tutte le impostazioni in questo pannello?
    .confirm = Ripristina
    .cancel = Annulla

## Lobby, Schermaglia e Multigiocatore (Lobby, Skirmish & Multiplayer)
dropdownbutton-server-lobby-slots = Gestione slot
button-server-lobby-reset-options = Predefiniti
button-skirmish-tabs-players-tab = Giocatori
button-skirmish-tabs-options-tab = Opzioni
button-multiplayer-tabs-players-tab = Giocatori
button-multiplayer-tabs-options-tab = Opzioni
button-multiplayer-tabs-servers-tab = Server
button-server-lobby-changemap = Cambia mappa
button-server-lobby-start-game = Avvia partita
button-server-lobby-disconnect = Lascia partita
label-lobby-options-bin-title = Opzioni mappa
label-lobby-players-name = Nome
label-lobby-players-color = Colore
label-lobby-players-faction = Fazione
label-lobby-players-team = Squadra
label-lobby-players-handicap = Handicap
label-lobby-players-spawn = Partenza
label-lobby-players-ready = Pronto
button-lobby-players-join = Gioca in questo slot
label-lobby-players-spectator = Spettatore
checkbox-lobby-players-new-spectator-toggle = Consentire spettatori?
button-lobby-players-spectate = Osserva
label-bot-player = Giocatore IA (Bot)

options-slot-admin =
    .add-bots = Aggiungi bot
    .remove-bots = Rimuovi bot
    .configure-bots = Configura bot
    .teams-count = { $count } Squadre
    .humans-vs-bots = Umani contro Bot
    .free-for-all = Tutti contro tutti
    .configure-teams = Configura squadre

options-lobby-slot =
    .slot = Slot
    .open = Aperto
    .closed = Chiuso
    .bots = Bot
    .bots-disabled = Bot disabilitati

options-game-speed =
    .slowest = Molto lenta
    .slower = Lenta
    .normal = Normale
    .fast = Veloce
    .faster = Molto veloce
    .fastest = Massima

options-time-limit =
    .no-limit = Nessun limite
    .options =
        { $minutes ->
            [one] { $minutes } minuto
           *[other] { $minutes } minuti
        }

## Opzioni regole (Rules Options in Lobby)
checkbox-fog-of-war =
    .label = Nebbia di guerra
    .description = È necessaria la linea di tiro/vista per vedere i nemici

checkbox-explored-map =
    .label = Mappa esplorata
    .description = La mappa inizia completamente scoperta

checkbox-debug-menu =
    .label = Trucchi (Cheats)
    .description = Abilita trucchi e comandi sviluppatore

checkbox-crates =
    .label = Casse bonus
    .description = Raccogli le casse con le unità per ricevere bonus casuali

checkbox-ally-build-radius =
    .label = Costruisci vicino agli alleati
    .description = Permette agli alleati di costruire nella tua area

checkbox-build-radius =
    .label = Limita area di costruzione
    .description = Limita il posizionamento delle strutture intorno al Cantiere

checkbox-short-game =
    .label = Partita breve
    .description = I giocatori vengono sconfitti quando le loro basi sono distrutte

dropdown-tech-level =
    .label = Livello tecnologico
    .description = Le unità e le abilità disponibili nella partita

dropdown-game-speed =
    .label = Velocità di gioco
    .description = Controlla la velocità con cui scorre il tempo

checkbox-separate-team-spawns =
    .label = Separa partenze squadre
    .description = I giocatori senza punto assegnato iniziano il più lontano possibile dai nemici

dropdown-starting-units =
    .label = Unità iniziali
    .description = Le unità con cui i giocatori iniziano la partita

dropdown-time-limit =
    .label = Limite di tempo
    .description = Vince il giocatore o la squadra con il punteggio più alto allo scadere del tempo

## Scelta mappa e Missioni (Map Chooser & Mission Browser)
label-mapchooser-panel-title = Scegli mappa
label-filter-order-controls-desc = Filtra:
label-filter-order-controls-orderby = Ordina per:
button-mapchooser-panel-randommap = Mappa casuale
button-mapchooser-panel-delete-map = Elimina mappa
button-mapchooser-panel-delete-all-maps = Elimina tutte
button-mapchooser-panel-ok = OK
button-mapchooser-system-maps-tab = Mappe ufficiali
button-mapchooser-remote-maps-tab = Mappe del server
button-mapchooser-user-maps-tab = Mappe personalizzate
button-mapchooser-generated-maps-tab = Genera mappa
label-all-maps = Tutte le mappe
label-no-matches = Nessun risultato
label-created-by = Creata da { $author }
label-map-size-huge = Enorme
label-map-size-large = Grande
label-map-size-medium = Media
label-map-size-small = Piccola

options-order-maps =
    .player-count = Giocatori
    .title = Titolo
    .date = Data
    .size = Dimensione

button-missionbrowser-panel-start-briefing-video = Guarda briefing
button-missionbrowser-panel-stop-briefing-video = Ferma briefing
button-missionbrowser-panel-start-info-video = Video info
button-missionbrowser-panel-stop-info-video = Ferma video
button-missionbrowser-panel-play = Gioca
button-missionbrowser-panel-mission-info = Info missione
button-missionbrowser-panel-mission-options = Opzioni
dropdown-missionbrowser-difficulty =
    .label = Difficoltà
    .description = Il livello di difficoltà della missione
dropdown-missionbrowser-gamespeed = Velocità:
label-missionbrowser-normal-difficulty = Normale

## Salva/Carica e Replay (Save/Load & Replays)
label-gamesave-browser-panel-load-title = Carica partita
label-gamesave-browser-panel-save-title = Salva partita
button-gamesave-browser-panel-delete-all = Elimina tutto
button-gamesave-browser-panel-delete = Elimina
button-gamesave-browser-panel-rename = Rinomina
button-gamesave-browser-panel-load = Carica
button-gamesave-browser-panel-save = Salva
label-load-game-browser-panel-title = Carica partita
label-load-game-browser-panel-choose-save = Scegli salvataggio
button-load-game-browser-panel-load = Carica
label-replaybrowser-panel-title = Visualizzatore replay
button-replaybrowser-panel-watch = Guarda

## Menu di gioco e HUD (In-Game Menu & HUD)
label-menu-buttons-title = Opzioni
button-top-buttons-options-tooltip = Opzioni
button-top-buttons-beacon-tooltip = Posiziona segnalatore
button-top-buttons-sell-tooltip = Vendi
button-top-buttons-power-tooltip = Disattiva energia
button-top-buttons-repair-tooltip = Ripara
button-production-types-building-tooltip = Edifici
button-production-types-defense-tooltip = Difesa
button-production-types-infantry-tooltip = Fanteria
button-production-types-vehicle-tooltip = Veicoli
button-production-types-aircraft-tooltip = Velivoli
button-production-types-naval-tooltip = Marina
label-mute-indicator = Audio disattivato
label-paused = In pausa

supportpowers-support-powers-palette =
    .ready = PRONTO
    .hold = IN ATTESA

productionpalette-sidebar-production-palette =
    .ready = PRONTO
    .hold = IN ATTESA

menu-ingame =
    .leave = Esci
    .abort = Abbandona missione
    .restart = Ricomincia
    .surrender = Arrenditi
    .load-game = Carica partita
    .save-game = Salva partita
    .music = Musica
    .settings = Impostazioni
    .return-to-map = Torna alla mappa
    .resume = Riprendi
    .save-map = Salva mappa
    .exit-map = Esci dall'editor
    .next-mission = Missione successiva

menu-game-info =
    .objectives = Obiettivi
    .briefing = Briefing
    .options = Opzioni
    .debug = Trucchi
    .chat = Chat

label-mission-objectives = Missione:
label-mission-objective = Missione:
checkbox-stats-objective = Distruggi tutte le forze nemiche!
label-stats-player = Giocatore
label-stats-faction = Fazione
label-stats-score = Punteggio
label-stats-actions = Azioni
label-mission-in-progress = In corso
label-mission-accomplished = Compiuta
label-mission-failed = Fallita

dialog-leave-mission =
    .title = Lasciare la missione
    .prompt = Lasciare la partita e tornare al menu principale?
    .confirm = Esci
    .cancel = Resta

dialog-restart-mission =
    .title = Ricomincia
    .prompt = Sei sicuro di voler ricominciare la missione?
    .confirm = Ricomincia
    .cancel = Resta

dialog-surrender =
    .title = Arrendersi
    .prompt = Sei sicuro di volerti arrendere?
    .confirm = Arrenditi
    .cancel = Resta

label-profile-link-desc-a = Collega un account del forum per identificarti
label-profile-link-desc-b = con gli altri giocatori, unirti a server
label-profile-link-desc-c = privati e mostrare i badge.
button-profile-link = Collega account del forum OpenRA
button-profile-unlink = Scollega account del forum
label-forum-profile-description = Collega un account del forum per identificarti con gli altri giocatori e mostrare i badge.
label-forum-profile-result-unlinked = L'account non è collegato a un profilo del forum OpenRA.
label-sendsysinfo-checkbox-container-desc = I dati di sistema anonimi aiutano gli sviluppatori a migliorare OpenRA.
label-debug-hidden-container-a = Opzioni aggiuntive per gli sviluppatori possono essere abilitate
label-debug-hidden-container-b = tramite riga di comando o nel file settings.yaml.
