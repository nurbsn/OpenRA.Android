## ====================================================================
## Traduction française pour OpenRA (nOpenRA Mobile)
## ====================================================================

## Boutons généraux (Common Buttons)
button-cancel = Annuler
button-retry = Réessayer
button-back = Retour
button-continue = Continuer
button-quit = Quitter
button-ok = OK
button-close = Fermer
button-prompt-confirm = Confirmer
button-prompt-other = Redémarrer
button-text-input-prompt-accept = OK
button-container-ok = OK

## Gestionnaire de Mods et de Contenu (Mod Manager)
label-mod-manager-title = Gestionnaire de Mods et Contenu
button-tab-installed-mods = Mods installés
button-tab-download-mods = Télécharger des Mods
button-tab-storage-folder = Dossier Stockage & Cartes
button-mod-active = Actif
button-mod-switch = Basculer
label-mod-active-tag = [ACTIF]
label-mod-version = version
button-refresh-list = Actualiser la liste
label-download-desc = Entrez l'URL directe de l'archive du mod (.zip ou .oramod) :
button-paste-link = Coller le lien
button-download-install = Télécharger & Installer
label-ready-download = Prêt à télécharger
label-popular-mods = Mods OpenRA populaires (toucher pour remplir le lien) :
label-storage-desc-1 = Dossier racine pour les mods (/mods) et les cartes (/maps) :
label-storage-desc-2 = Sur Android récent, /Android/data/ est verrouillé. Choisissez un dossier partagé :
label-storage-presets = Emplacements rapides (toucher pour choisir) :
button-storage-shared = Stockage interne (/storage/emulated/0/OpenRA)
button-storage-download = Dossier Téléchargements (/storage/emulated/0/Download/OpenRA)
button-storage-documents = Dossier Documents (/storage/emulated/0/Documents/OpenRA)
button-storage-default = Dossier par défaut de l'application
button-save-create-folders = Enregistrer & Créer les dossiers
button-mods-title = Mods
label-storage-error-empty = Erreur : le chemin ne peut pas être vide.
label-storage-saved = Enregistré ! Dossiers /mods et /maps créés.
label-download-error-url = Erreur : URL invalide.
label-download-error-protocol = Erreur : seuls les protocoles HTTP et HTTPS sont pris en charge.
label-download-connecting = Connexion au serveur...
label-download-installing = Installation et extraction...
label-download-success = Mod installé avec succès !

## Paramètres de langue (Language Settings)
button-panel-language = Langue
label-language-section-header = LANGUE & TRADUCTIONS
label-select-language = Langue :
label-language-restart-info = Sélectionnez la langue de l'application. Le gestionnaire de mods, les paramètres et l'interface traduite seront mis à jour immédiatement.
button-language-en = English
button-language-pl = Polski
button-language-de = Deutsch
button-language-es = Español
button-language-fr = Français
button-language-pt = Português
button-language-it = Italiano
button-language-ru = Русский

## Menu principal (Main Menu)
label-singleplayer-title = Solo
label-multiplayer-title = Multijoueur
button-settings-title = Paramètres
button-extras-title = Extras
button-main-menu-content = Gérer le contenu
button-singleplayer-menu-skirmish = Escarmouche
button-singleplayer-menu-load = Charger
label-missions-title = Missions
button-extras-menu-replays = Rediffusions
label-music-title = Musique
label-map-editor-title = Éditeur de cartes
button-extras-menu-assetbrowser = Explorateur de ressources
label-credits-title = Crédits
button-map-editor-new-map = Nouvelle carte
button-map-editor-load-map = Charger une carte
dropdownbutton-news-bg-button = Actualités du front
label-loading-news = Chargement des actualités...

## Onglets des paramètres (Settings Tabs)
button-settings-panel-reset = Réinitialiser
button-panel-gameplay = Jeu
button-panel-input = Commandes
button-panel-display = Affichage
button-panel-audio = Audio
button-panel-hotkeys = Raccourcis
button-panel-advanced = Avancé

## Paramètres - Commandes (Input Settings)
label-input-section-header = Commandes
label-touch-hold-duration-slider = Délai d'appui pour le cadre de sélection :
label-touch-navigation-title = Navigation tactile mobile
label-touch-desc-tap = - Appui court : Sélectionner unités/bâtiments, déplacer ou attaquer
label-touch-desc-swipe = - Glisser (Swipe) : Déplacer la caméra sur le champ de bataille (PAN)
label-touch-desc-pinch = - Pincer (Pinch) : Zoomer et dézoomer avec deux doigts
label-touch-desc-hold = - Maintenir (Hold) : Activer le rectangle de sélection
label-mouse-control-container = Schéma de contrôle :
label-zoom-modifier-container = Modificateur de zoom :
checkbox-edgescroll-container = Défilement aux bords de l'écran
checkbox-alternate-scroll-container = Défilement souris alternatif
checkbox-lockmouse-container = Verrouiller la souris dans la fenêtre
label-mouse-scroll-type-container = Mode de défilement :
label-scrollspeed-slider-container-scroll-speed = Vitesse de caméra :
label-zoomspeed-slider-container-zoom-speed = Vitesse de zoom :
label-ui-scrollspeed-slider-container-scroll-speed = Vitesse de défilement UI :

options-mouse-scroll-type =
    .disabled = Désactivé
    .standard = Standard
    .inverted = Inversé
    .joystick = Joystick

options-control-scheme =
    .classic = Classique
    .modern = Moderne
    .otherrts = Autre STR

## Paramètres - Jeu et Profil (Gameplay & Profile Settings)
label-profile-section-header = Profil
label-player-container = Nom du joueur :
label-playercolor-container-color = Couleur préférée :
label-gameplay-section-header = Jeu
label-auto-save-interval = Fréquence de sauvegarde auto :
label-auto-save-max-file-number = Limite de sauvegardes auto :
checkbox-hide-replay-chat-container = Masquer le chat dans les rediffusions
label-forum-profile-section-header = Compte Forum OpenRA
label-forum-profile-username = Identifiant :
label-forum-profile-password = Mot de passe :
button-forum-profile-link = Lier le compte
button-forum-profile-unlink = Délier le compte
button-forum-profile-retry = Réessayer
button-forum-visit-forum = Visiter le forum

auto-save-interval =
    .disabled = Désactivé
    .options =
        { $seconds ->
            [one] 1 seconde
           *[other] { $seconds } s
        }
    .minute-options =
        { $minutes ->
            [one] 1 minute
           *[other] { $minutes } min
        }

auto-save-max-file-number = { $saves } sauvegardes

## Paramètres - Affichage (Display Settings)
label-display-section-header = Affichage
label-battlefield-camera-dropdown = Caméra du champ de bataille :
label-ui-scale-dropdown = Échelle de l'interface (UI) :
checkbox-cursordouble-container = Agrandir la taille du curseur
label-target-lines-dropdown-container = Lignes de ciblage :
label-status-bar-dropdown-container-bars = Barres d'état :

checkbox-player-stance-colors-container =
    .label = Couleurs selon la relation des joueurs
    .tooltip = Change les couleurs selon la relation (soi, ennemi, allié, neutre)

checkbox-ui-feedback-container =
    .label = Afficher les notifications de l'interface
    .tooltip = Affiche des notifications textuelles pour les événements de l'interface

checkbox-transients-container =
    .label = Afficher les notifications d'événements de jeu
    .tooltip = Affiche des notifications textuelles pour les événements de la partie

checkbox-pause-shellmap-container = Mettre en pause l'arrière-plan du menu
label-video-section-header = Vidéo
label-video-mode-dropdown-container = Mode vidéo :
dropdownbutton-video-mode-dropdown-container = Fenêtré
label-window-resolution-container-size = Taille de la fenêtre :
label-resolution-preset = Préréglages :
dropdownbutton-resolution-select-preset = Choisir un préréglage
label-display-selection-container = Choisir l'écran :
checkbox-vsync-container = Activer la VSync
checkbox-frame-limit-gamespeed-container = Limiter les IPS à la cadence du jeu
label-gl-profile-dropdown-container = Profil OpenGL :
label-restart-required-container-video-desc = Les changements d'écran et OpenGL nécessitent un redémarrage
checkbox-frame-limiter = Limiteur d'images ({ $fps } IPS)

options-camera =
    .close = Proche
    .medium = Moyenne
    .far = Éloignée
    .furthest = Très éloignée

options-display-mode =
    .windowed = Fenêtré
    .legacy-fullscreen = Plein écran (Ancien)
    .fullscreen = Plein écran

options-status-bars =
    .standard = Standard
    .show-on-damage = Afficher si endommagé
    .always-show = Toujours afficher

options-target-lines =
    .automatic = Automatiques
    .manual = Manuelles
    .disabled = Désactivées

## Paramètres - Audio (Audio Settings)
label-audio-section-header = Audio
label-no-audio-device-container = Les contrôles audio nécessitent un périphérique actif
checkbox-cash-ticks-container = Son du compteur de crédits
checkbox-mute-sound-container = Couper le son
label-sound-volume-container = Volume des effets :

checkbox-mute-background-music-container =
    .label = Couper la musique du menu
    .tooltip = Coupe la musique de fond lorsqu'aucune piste n'est jouée

label-music-title-volume-container = Volume de la musique :
label-audio-device-container = Périphérique audio :
label-video-volume-container = Volume des vidéos :
label-restart-required-container-audio-desc = Les changements de périphérique s'appliqueront après redémarrage

## Paramètres - Avancé (Advanced Settings)
label-network-section-header = Avancé
checkbox-nat-discovery-container = Activer la découverte UPnP/NAT-PMP
checkbox-fetch-news-container = Récupérer les actualités de la communauté
checkbox-perfgraph-container = Afficher le graphique de performances
checkbox-check-version-container = Vérifier les mises à jour
checkbox-perftext-container = Afficher le texte de performances (IPS)
checkbox-sendsysinfo-container = Envoyer des informations système anonymes
checkbox-enable-discord-service-container = Activer Discord Rich Presence
label-debug-section-header = Développeur

## Boîtes de dialogue de confirmation (Confirmation Dialogs)
dialog-settings-save =
    .title = Redémarrage requis
    .prompt = Certains changements ne prendront effet qu'après le redémarrage du jeu.
    .cancel = Continuer

dialog-settings-restart =
    .title = Redémarrer maintenant ?
    .prompt = Certains changements nécessitent un redémarrage. Redémarrer maintenant ?
    .confirm = Redémarrer maintenant
    .cancel = Plus tard

dialog-settings-reset =
    .title = Réinitialiser { $panel }
    .prompt = Voulez-vous vraiment réinitialiser tous les paramètres de cet onglet ?
    .confirm = Réinitialiser
    .cancel = Annuler

## Salon, Escarmouche et Multijoueur (Lobby, Skirmish & Multiplayer)
dropdownbutton-server-lobby-slots = Gérer les emplacements
button-server-lobby-reset-options = Valeurs par défaut
button-skirmish-tabs-players-tab = Joueurs
button-skirmish-tabs-options-tab = Options
button-multiplayer-tabs-players-tab = Joueurs
button-multiplayer-tabs-options-tab = Options
button-multiplayer-tabs-servers-tab = Serveurs
button-server-lobby-changemap = Changer de carte
button-server-lobby-start-game = Lancer la partie
button-server-lobby-disconnect = Quitter la partie
label-lobby-options-bin-title = Options de la carte
label-lobby-players-name = Nom
label-lobby-players-color = Couleur
label-lobby-players-faction = Faction
label-lobby-players-team = Équipe
label-lobby-players-handicap = Handicap
label-lobby-players-spawn = Départ
label-lobby-players-ready = Prêt
button-lobby-players-join = Jouer à cet emplacement
label-lobby-players-spectator = Spectateur
checkbox-lobby-players-new-spectator-toggle = Autoriser les spectateurs ?
button-lobby-players-spectate = Observer
label-bot-player = Joueur IA (Bot)

options-slot-admin =
    .add-bots = Ajouter des bots
    .remove-bots = Retirer les bots
    .configure-bots = Configurer les bots
    .teams-count = { $count } Équipes
    .humans-vs-bots = Humains contre Bots
    .free-for-all = Chacun pour soi
    .configure-teams = Configurer les équipes

options-lobby-slot =
    .slot = Emplacement
    .open = Ouvert
    .closed = Fermé
    .bots = Bots
    .bots-disabled = Bots désactivés

options-game-speed =
    .slowest = Très lente
    .slower = Lente
    .normal = Normale
    .fast = Rapide
    .faster = Très rapide
    .fastest = Maximale

options-time-limit =
    .no-limit = Aucune limite
    .options =
        { $minutes ->
            [one] { $minutes } minute
           *[other] { $minutes } minutes
        }

## Options des règles (Rules Options in Lobby)
checkbox-fog-of-war =
    .label = Brouillard de guerre
    .description = Une ligne de vue est requise pour voir les forces ennemies

checkbox-explored-map =
    .label = Carte explorée
    .description = La carte est entièrement découverte dès le départ

checkbox-debug-menu =
    .label = Triches (Cheats)
    .description = Active les codes de triche et les commandes développeur

checkbox-crates =
    .label = Caisses bonus
    .description = Ramassez des caisses pour obtenir des bonus aléatoires

checkbox-ally-build-radius =
    .label = Construire près des alliés
    .description = Permet aux alliés de construire dans votre zone de construction

checkbox-build-radius =
    .label = Limiter la zone de construction
    .description = Limite la pose de bâtiments autour du Chantier de Construction

checkbox-short-game =
    .label = Partie courte
    .description = Les joueurs sont vaincus lorsque leur base est détruite

dropdown-tech-level =
    .label = Niveau technologique
    .description = Unités et capacités disponibles pour les joueurs

dropdown-game-speed =
    .label = Vitesse du jeu
    .description = Contrôle la vitesse d'écoulement du temps

checkbox-separate-team-spawns =
    .label = Séparer les équipes au départ
    .description = Les joueurs sans point de départ assigné commencent loin de l'ennemi

dropdown-starting-units =
    .label = Unités de départ
    .description = Les unités avec lesquelles les joueurs commencent la partie

dropdown-time-limit =
    .label = Limite de temps
    .description = Le joueur ou l'équipe ayant le meilleur score à la fin du temps gagne

## Choix de carte & Missions (Map Chooser & Mission Browser)
label-mapchooser-panel-title = Choisir une carte
label-filter-order-controls-desc = Filtrer :
label-filter-order-controls-orderby = Trier par :
button-mapchooser-panel-randommap = Carte aléatoire
button-mapchooser-panel-delete-map = Supprimer la carte
button-mapchooser-panel-delete-all-maps = Tout supprimer
button-mapchooser-panel-ok = OK
button-mapchooser-system-maps-tab = Cartes officielles
button-mapchooser-remote-maps-tab = Cartes du serveur
button-mapchooser-user-maps-tab = Cartes personnalisées
button-mapchooser-generated-maps-tab = Générer une carte
label-all-maps = Toutes les cartes
label-no-matches = Aucun résultat
label-created-by = Créée par { $author }
label-map-size-huge = Immense
label-map-size-large = Grande
label-map-size-medium = Moyenne
label-map-size-small = Petite

options-order-maps =
    .player-count = Joueurs
    .title = Titre
    .date = Date
    .size = Taille

button-missionbrowser-panel-start-briefing-video = Voir le briefing
button-missionbrowser-panel-stop-briefing-video = Arrêter le briefing
button-missionbrowser-panel-start-info-video = Vidéo d'info
button-missionbrowser-panel-stop-info-video = Arrêter la vidéo
button-missionbrowser-panel-play = Jouer
button-missionbrowser-panel-mission-info = Infos mission
button-missionbrowser-panel-mission-options = Options
dropdown-missionbrowser-difficulty =
    .label = Difficulté
    .description = Niveau de difficulté de la mission
dropdown-missionbrowser-gamespeed = Vitesse :
label-missionbrowser-normal-difficulty = Normale

## Sauvegarder/Charger & Rediffusions (Save/Load & Replays)
label-gamesave-browser-panel-load-title = Charger une partie
label-gamesave-browser-panel-save-title = Sauvegarder la partie
button-gamesave-browser-panel-delete-all = Tout supprimer
button-gamesave-browser-panel-delete = Supprimer
button-gamesave-browser-panel-rename = Renommer
button-gamesave-browser-panel-load = Charger
button-gamesave-browser-panel-save = Sauvegarder
label-load-game-browser-panel-title = Charger une partie
label-load-game-browser-panel-choose-save = Choisir une sauvegarde
button-load-game-browser-panel-load = Charger
label-replaybrowser-panel-title = Visionneuse de rediffusions
button-replaybrowser-panel-watch = Regarder

## Menu en jeu et HUD (In-Game Menu & HUD)
label-menu-buttons-title = Options
button-top-buttons-options-tooltip = Options
button-top-buttons-beacon-tooltip = Placer une balise
button-top-buttons-sell-tooltip = Vendre
button-top-buttons-power-tooltip = Couper l'alimentation
button-top-buttons-repair-tooltip = Réparer
button-production-types-building-tooltip = Bâtiments
button-production-types-defense-tooltip = Défense
button-production-types-infantry-tooltip = Infanterie
button-production-types-vehicle-tooltip = Véhicules
button-production-types-aircraft-tooltip = Aviation
button-production-types-naval-tooltip = Marine
label-mute-indicator = Son coupé
label-paused = En pause

supportpowers-support-powers-palette =
    .ready = PRÊT
    .hold = EN ATTENTE

productionpalette-sidebar-production-palette =
    .ready = PRÊT
    .hold = EN ATTENTE

menu-ingame =
    .leave = Quitter
    .abort = Abandonner la mission
    .restart = Recommencer
    .surrender = Capituler
    .load-game = Charger une partie
    .save-game = Sauvegarder la partie
    .music = Musique
    .settings = Paramètres
    .return-to-map = Retour à la carte
    .resume = Reprendre
    .save-map = Sauvegarder la carte
    .exit-map = Quitter l'éditeur
    .next-mission = Mission suivante

menu-game-info =
    .objectives = Objectifs
    .briefing = Briefing
    .options = Options
    .debug = Triches
    .chat = Chat

label-mission-objectives = Mission :
label-mission-objective = Mission :
checkbox-stats-objective = Détruisez toute opposition !
label-stats-player = Joueur
label-stats-faction = Faction
label-stats-score = Score
label-stats-actions = Actions
label-mission-in-progress = En cours
label-mission-accomplished = Accomplie
label-mission-failed = Échouée

dialog-leave-mission =
    .title = Quitter la mission
    .prompt = Quitter cette partie et revenir au menu ?
    .confirm = Quitter
    .cancel = Rester

dialog-restart-mission =
    .title = Recommencer
    .prompt = Voulez-vous vraiment recommencer la mission ?
    .confirm = Recommencer
    .cancel = Rester

dialog-surrender =
    .title = Capituler
    .prompt = Voulez-vous vraiment capituler ?
    .confirm = Capituler
    .cancel = Rester

label-profile-link-desc-a = Associez un compte du forum pour vous identifier
label-profile-link-desc-b = auprès des autres joueurs, rejoindre des serveurs
label-profile-link-desc-c = privés et afficher des badges.
button-profile-link = Associer un compte du forum OpenRA
button-profile-unlink = Dissocier le compte du forum
label-forum-profile-description = Associez un compte du forum pour vous identifier auprès des autres joueurs et afficher des badges.
label-forum-profile-result-unlinked = Le compte n'est pas associé à un profil du forum OpenRA.
label-sendsysinfo-checkbox-container-desc = Les données système anonymes aident les développeurs à améliorer OpenRA.
label-debug-hidden-container-a = Des options supplémentaires pour les développeurs peuvent être
label-debug-hidden-container-b = activées via la ligne de commande ou dans le fichier settings.yaml.
