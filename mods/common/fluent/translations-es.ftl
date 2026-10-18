## ====================================================================
## Traducción al español para OpenRA (nOpenRA Mobile)
## ====================================================================

## Botones generales (Common Buttons)
button-cancel = Cancelar
button-retry = Reintentar
button-back = Atrás
button-continue = Continuar
button-quit = Salir
button-ok = Aceptar
button-close = Cerrar
button-prompt-confirm = Confirmar
button-prompt-other = Reiniciar
button-text-input-prompt-accept = Aceptar
button-container-ok = Aceptar

## Gestor de Mods y Contenido (Mod Manager)
label-mod-manager-title = Gestor de Mods y Contenido
button-tab-installed-mods = Mods instalados
button-tab-download-mods = Descargar Mods
button-tab-storage-folder = Carpeta de datos y mapas
button-mod-active = Activo
button-mod-switch = Cambiar
label-mod-active-tag = [ACTIVO]
label-mod-version = versión
button-refresh-list = Actualizar lista
label-download-desc = Introduce la URL directa del archivo del mod (.zip o .oramod):
button-paste-link = Pegar enlace
button-download-install = Descargar e instalar
label-ready-download = Listo para descargar
label-popular-mods = Mods populares de OpenRA (toca para rellenar el enlace):
label-storage-desc-1 = Directorio raíz para mods (/mods) y mapas (/maps):
label-storage-desc-2 = En versiones modernas de Android /Android/data/ está restringido. Elige una carpeta compartida:
label-storage-presets = Ubicaciones rápidas (toca para elegir):
button-storage-shared = Almacenamiento interno (/storage/emulated/0/OpenRA)
button-storage-download = Carpeta Descargas (/storage/emulated/0/Download/OpenRA)
button-storage-documents = Carpeta Documentos (/storage/emulated/0/Documents/OpenRA)
button-storage-default = Directorio predeterminado de la app
button-save-create-folders = Guardar y crear carpetas
button-mods-title = Mods
label-storage-error-empty = Error: la ruta no puede estar vacía.
label-storage-saved = ¡Guardado! Carpetas /mods y /maps creadas.
label-download-error-url = Error: URL no válida.
label-download-error-protocol = Error: Solo se admiten protocolos HTTP y HTTPS.
label-download-connecting = Conectando con el servidor...
label-download-installing = Instalando y extrayendo...
label-download-success = ¡Mod instalado correctamente!

## Ajustes de idioma (Language Settings)
button-panel-language = Idioma
label-language-section-header = IDIOMA Y TRADUCCIONES
label-select-language = Idioma:
label-language-restart-info = Selecciona el idioma de la aplicación. El gestor de mods, los ajustes y la interfaz traducida se actualizarán al instante.
button-language-en = English
button-language-pl = Polski
button-language-de = Deutsch
button-language-es = Español
button-language-fr = Français
button-language-pt = Português
button-language-it = Italiano
button-language-ru = Русский

## Menú principal (Main Menu)
label-singleplayer-title = Un jugador
label-multiplayer-title = Multijugador
button-settings-title = Ajustes
button-extras-title = Extras
button-main-menu-content = Gestionar contenido
button-singleplayer-menu-skirmish = Escaramuza
button-singleplayer-menu-load = Cargar partida
label-missions-title = Misiones
button-extras-menu-replays = Repeticiones
label-music-title = Música
label-map-editor-title = Editor de mapas
button-extras-menu-assetbrowser = Explorador de recursos
label-credits-title = Créditos
button-map-editor-new-map = Nuevo mapa
button-map-editor-load-map = Cargar mapa
dropdownbutton-news-bg-button = Noticias del frente
label-loading-news = Cargando noticias...

## Pestañas de ajustes (Settings Tabs)
button-settings-panel-reset = Restablecer
button-panel-gameplay = Juego
button-panel-input = Controles
button-panel-display = Pantalla
button-panel-audio = Audio
button-panel-hotkeys = Atajos
button-panel-advanced = Avanzado

## Ajustes - Controles (Input Settings)
label-input-section-header = Controles
label-touch-hold-duration-slider = Retardo de pulsación para selección por área:
label-touch-navigation-title = Navegación táctil móvil
label-touch-desc-tap = - Toque simple: Seleccionar unidades/edificios, mover o atacar
label-touch-desc-swipe = - Deslizar (Swipe): Desplazar la cámara por el mapa suavemente (PAN)
label-touch-desc-pinch = - Pellizcar (Pinch): Acercar y alejar el zoom con dos dedos
label-touch-desc-hold = - Mantener pulsado (Hold): Activar cuadro de selección rectangular
label-mouse-control-container = Esquema de control:
label-zoom-modifier-container = Modificador de zoom:
checkbox-edgescroll-container = Desplazar en los bordes de pantalla
checkbox-alternate-scroll-container = Desplazamiento alternativo del ratón
checkbox-lockmouse-container = Bloquear ratón en la ventana
label-mouse-scroll-type-container = Comportamiento de desplazamiento:
label-scrollspeed-slider-container-scroll-speed = Velocidad de cámara:
label-zoomspeed-slider-container-zoom-speed = Velocidad de zoom:
label-ui-scrollspeed-slider-container-scroll-speed = Velocidad de desplazamiento UI:

options-mouse-scroll-type =
    .disabled = Desactivado
    .standard = Estándar
    .inverted = Invertido
    .joystick = Joystick

options-control-scheme =
    .classic = Clásico
    .modern = Moderno
    .otherrts = Otro RTS

## Ajustes - Juego y Perfil (Gameplay & Profile Settings)
label-profile-section-header = Perfil
label-player-container = Nombre del jugador:
label-playercolor-container-color = Color preferido:
label-gameplay-section-header = Juego
label-auto-save-interval = Frecuencia de autoguardado:
label-auto-save-max-file-number = Límite de autoguardados:
checkbox-hide-replay-chat-container = Ocultar chat en repeticiones
label-forum-profile-section-header = Cuenta del foro de OpenRA
label-forum-profile-username = Usuario:
label-forum-profile-password = Contraseña:
button-forum-profile-link = Vincular cuenta
button-forum-profile-unlink = Desvincular cuenta
button-forum-profile-retry = Reintentar
button-forum-visit-forum = Visitar foro

auto-save-interval =
    .disabled = Desactivado
    .options =
        { $seconds ->
            [one] 1 segundo
           *[other] { $seconds } s
        }
    .minute-options =
        { $minutes ->
            [one] 1 minuto
           *[other] { $minutes } min
        }

auto-save-max-file-number = { $saves } guardados

## Ajustes - Pantalla (Display Settings)
label-display-section-header = Pantalla
label-battlefield-camera-dropdown = Cámara del campo de batalla:
label-ui-scale-dropdown = Escala de interfaz (UI):
checkbox-cursordouble-container = Aumentar tamaño del cursor
label-target-lines-dropdown-container = Líneas de objetivo:
label-status-bar-dropdown-container-bars = Barras de estado:

checkbox-player-stance-colors-container =
    .label = Colores según relación de jugadores
    .tooltip = Cambia los colores según la relación (propio, enemigo, aliado, neutral)

checkbox-ui-feedback-container =
    .label = Mostrar notificaciones de interfaz
    .tooltip = Muestra notificaciones de texto breves para eventos de la interfaz

checkbox-transients-container =
    .label = Mostrar notificaciones de eventos del juego
    .tooltip = Muestra notificaciones de texto breves para eventos de la batalla

checkbox-pause-shellmap-container = Pausar fondo del menú
label-video-section-header = Vídeo
label-video-mode-dropdown-container = Modo de vídeo:
dropdownbutton-video-mode-dropdown-container = En ventana
label-window-resolution-container-size = Tamaño de ventana:
label-resolution-preset = Preajustes:
dropdownbutton-resolution-select-preset = Seleccionar preajuste
label-display-selection-container = Seleccionar pantalla:
checkbox-vsync-container = Activar VSync
checkbox-frame-limit-gamespeed-container = Limitar fotogramas al ritmo del juego
label-gl-profile-dropdown-container = Perfil OpenGL:
label-restart-required-container-video-desc = Los cambios de pantalla y OpenGL requieren reiniciar
checkbox-frame-limiter = Límite de fotogramas ({ $fps } FPS)

options-camera =
    .close = Cerca
    .medium = Medio
    .far = Lejos
    .furthest = Muy lejos

options-display-mode =
    .windowed = En ventana
    .legacy-fullscreen = Pantalla completa (Clásico)
    .fullscreen = Pantalla completa

options-status-bars =
    .standard = Estándar
    .show-on-damage = Mostrar al recibir daño
    .always-show = Mostrar siempre

options-target-lines =
    .automatic = Automáticas
    .manual = Manuales
    .disabled = Desactivadas

## Ajustes - Audio (Audio Settings)
label-audio-section-header = Audio
label-no-audio-device-container = Los controles de audio requieren un dispositivo activo
checkbox-cash-ticks-container = Sonido de contador de recursos
checkbox-mute-sound-container = Silenciar sonido
label-sound-volume-container = Volumen de efectos:

checkbox-mute-background-music-container =
    .label = Silenciar música del menú
    .tooltip = Silencia la música de fondo cuando no se reproduce ninguna pista

label-music-title-volume-container = Volumen de música:
label-audio-device-container = Dispositivo de audio:
label-video-volume-container = Volumen de vídeo:
label-restart-required-container-audio-desc = Los cambios de dispositivo se aplicarán tras reiniciar

## Ajustes - Avanzado (Advanced Settings)
label-network-section-header = Avanzado
checkbox-nat-discovery-container = Activar descubrimiento UPnP/NAT-PMP
checkbox-fetch-news-container = Descargar noticias de la comunidad
checkbox-perfgraph-container = Mostrar gráfico de rendimiento
checkbox-check-version-container = Buscar actualizaciones
checkbox-perftext-container = Mostrar texto de rendimiento (FPS)
checkbox-sendsysinfo-container = Enviar información anónima del sistema
checkbox-enable-discord-service-container = Activar Discord Rich Presence
label-debug-section-header = Desarrollador

## Diálogos de confirmación (Confirmation Dialogs)
dialog-settings-save =
    .title = Reinicio necesario
    .prompt = Algunos cambios no se aplicarán hasta que se reinicie el juego.
    .cancel = Continuar

dialog-settings-restart =
    .title = ¿Reiniciar ahora?
    .prompt = Algunos cambios requieren reiniciar el juego. ¿Reiniciar ahora?
    .confirm = Reiniciar ahora
    .cancel = Reiniciar más tarde

dialog-settings-reset =
    .title = Restablecer { $panel }
    .prompt = ¿Seguro que deseas restablecer todos los ajustes de este panel?
    .confirm = Restablecer
    .cancel = Cancelar

## Sala, Escaramuza y Multijugador (Lobby, Skirmish & Multiplayer)
dropdownbutton-server-lobby-slots = Administrar ranuras
button-server-lobby-reset-options = Valores por defecto
button-skirmish-tabs-players-tab = Jugadores
button-skirmish-tabs-options-tab = Opciones
button-multiplayer-tabs-players-tab = Jugadores
button-multiplayer-tabs-options-tab = Opciones
button-multiplayer-tabs-servers-tab = Servidores
button-server-lobby-changemap = Cambiar mapa
button-server-lobby-start-game = Iniciar partida
button-server-lobby-disconnect = Salir de la sala
label-lobby-options-bin-title = Opciones del mapa
label-lobby-players-name = Nombre
label-lobby-players-color = Color
label-lobby-players-faction = Facción
label-lobby-players-team = Equipo
label-lobby-players-handicap = Desventaja
label-lobby-players-spawn = Inicio
label-lobby-players-ready = Listo
button-lobby-players-join = Jugar en esta ranura
label-lobby-players-spectator = Espectador
checkbox-lobby-players-new-spectator-toggle = ¿Permitir espectadores?
button-lobby-players-spectate = Observar
label-bot-player = Jugador IA (Bot)

options-slot-admin =
    .add-bots = Añadir bots
    .remove-bots = Quitar bots
    .configure-bots = Configurar bots
    .teams-count = { $count } Equipos
    .humans-vs-bots = Humanos contra Bots
    .free-for-all = Todos contra todos
    .configure-teams = Configurar equipos

options-lobby-slot =
    .slot = Ranura
    .open = Abierta
    .closed = Cerrada
    .bots = Bots
    .bots-disabled = Bots desactivados

options-game-speed =
    .slowest = Muy lenta
    .slower = Lenta
    .normal = Normal
    .fast = Rápida
    .faster = Muy rápida
    .fastest = Máxima

options-time-limit =
    .no-limit = Sin límite
    .options =
        { $minutes ->
            [one] { $minutes } minuto
           *[other] { $minutes } minutos
        }

## Opciones de reglas (Rules Options in Lobby)
checkbox-fog-of-war =
    .label = Niebla de guerra
    .description = Se requiere línea de visión para ver a las fuerzas enemigas

checkbox-explored-map =
    .label = Mapa explorado
    .description = El mapa comienza completamente descubierto

checkbox-debug-menu =
    .label = Trucos (Cheats)
    .description = Habilita trucos y comandos de desarrollador

checkbox-crates =
    .label = Cajas de bonificación
    .description = Recoge cajas con unidades para obtener bonificaciones aleatorias

checkbox-ally-build-radius =
    .label = Construir junto a aliados
    .description = Permite colocar estructuras dentro del área de construcción aliada

checkbox-build-radius =
    .label = Limitar área de construcción
    .description = Limita la colocación de estructuras alrededor del Patio de Construcción

checkbox-short-game =
    .label = Partida corta
    .description = Los jugadores son derrotados al perder todas sus bases

dropdown-tech-level =
    .label = Nivel tecnológico
    .description = Unidades y habilidades disponibles para los jugadores

dropdown-game-speed =
    .label = Velocidad de partida
    .description = Controla la velocidad a la que transcurre el tiempo

checkbox-separate-team-spawns =
    .label = Separar inicios de equipos
    .description = Los jugadores sin posición fija comienzan lo más lejos posible del enemigo

dropdown-starting-units =
    .label = Unidades iniciales
    .description = Las unidades con las que comienzan los jugadores

dropdown-time-limit =
    .label = Límite de tiempo
    .description = Gana el jugador o equipo con mayor puntuación al terminar el tiempo

## Selección de mapa y Misiones (Map Chooser & Mission Browser)
label-mapchooser-panel-title = Elegir mapa
label-filter-order-controls-desc = Filtrar:
label-filter-order-controls-orderby = Ordenar por:
button-mapchooser-panel-randommap = Mapa aleatorio
button-mapchooser-panel-delete-map = Eliminar mapa
button-mapchooser-panel-delete-all-maps = Eliminar todos
button-mapchooser-panel-ok = Aceptar
button-mapchooser-system-maps-tab = Mapas oficiales
button-mapchooser-remote-maps-tab = Mapas del servidor
button-mapchooser-user-maps-tab = Mapas propios
button-mapchooser-generated-maps-tab = Generar mapa
label-all-maps = Todos los mapas
label-no-matches = Sin coincidencias
label-created-by = Creado por { $author }
label-map-size-huge = Enorme
label-map-size-large = Grande
label-map-size-medium = Mediano
label-map-size-small = Pequeño

options-order-maps =
    .player-count = Jugadores
    .title = Título
    .date = Fecha
    .size = Tamaño

button-missionbrowser-panel-start-briefing-video = Ver informe
button-missionbrowser-panel-stop-briefing-video = Detener informe
button-missionbrowser-panel-start-info-video = Ver vídeo info
button-missionbrowser-panel-stop-info-video = Detener vídeo
button-missionbrowser-panel-play = Jugar
button-missionbrowser-panel-mission-info = Info de misión
button-missionbrowser-panel-mission-options = Opciones
dropdown-missionbrowser-difficulty =
    .label = Dificultad
    .description = Nivel de dificultad de la misión
dropdown-missionbrowser-gamespeed = Velocidad:
label-missionbrowser-normal-difficulty = Normal

## Guardar/Cargar y Repeticiones (Save/Load & Replays)
label-gamesave-browser-panel-load-title = Cargar partida
label-gamesave-browser-panel-save-title = Guardar partida
button-gamesave-browser-panel-delete-all = Eliminar todo
button-gamesave-browser-panel-delete = Eliminar
button-gamesave-browser-panel-rename = Renombrar
button-gamesave-browser-panel-load = Cargar
button-gamesave-browser-panel-save = Guardar
label-load-game-browser-panel-title = Cargar partida
label-load-game-browser-panel-choose-save = Elegir partida guardada
button-load-game-browser-panel-load = Cargar
label-replaybrowser-panel-title = Visor de repeticiones
button-replaybrowser-panel-watch = Ver

## Menú en partida e interfaz (In-Game Menu & HUD)
label-menu-buttons-title = Opciones
button-top-buttons-options-tooltip = Opciones
button-top-buttons-beacon-tooltip = Colocar baliza
button-top-buttons-sell-tooltip = Vender
button-top-buttons-power-tooltip = Cortar energía
button-top-buttons-repair-tooltip = Reparar
button-production-types-building-tooltip = Edificios
button-production-types-defense-tooltip = Defensa
button-production-types-infantry-tooltip = Infantería
button-production-types-vehicle-tooltip = Vehículos
button-production-types-aircraft-tooltip = Aviación
button-production-types-naval-tooltip = Naval
label-mute-indicator = Audio silenciado
label-paused = En pausa

supportpowers-support-powers-palette =
    .ready = LISTO
    .hold = EN ESPERA

productionpalette-sidebar-production-palette =
    .ready = LISTO
    .hold = EN ESPERA

menu-ingame =
    .leave = Salir
    .abort = Abortar misión
    .restart = Reiniciar
    .surrender = Rendirse
    .load-game = Cargar partida
    .save-game = Guardar partida
    .music = Música
    .settings = Ajustes
    .return-to-map = Volver al mapa
    .resume = Reanudar
    .save-map = Guardar mapa
    .exit-map = Salir del editor
    .next-mission = Siguiente misión

menu-game-info =
    .objectives = Objetivos
    .briefing = Informe
    .options = Opciones
    .debug = Trucos
    .chat = Chat

label-mission-objectives = Misión:
label-mission-objective = Misión:
checkbox-stats-objective = ¡Destruye a toda la oposición!
label-stats-player = Jugador
label-stats-faction = Facción
label-stats-score = Puntuación
label-stats-actions = Acciones
label-mission-in-progress = En curso
label-mission-accomplished = Cumplida
label-mission-failed = Fracasada

dialog-leave-mission =
    .title = Salir de la misión
    .prompt = ¿Salir de esta partida y volver al menú?
    .confirm = Salir
    .cancel = Quedarse

dialog-restart-mission =
    .title = Reiniciar
    .prompt = ¿Seguro que quieres reiniciar la misión?
    .confirm = Reiniciar
    .cancel = Quedarse

dialog-surrender =
    .title = Rendirse
    .prompt = ¿Seguro que quieres rendirte?
    .confirm = Rendirse
    .cancel = Quedarse

label-profile-link-desc-a = Vincula una cuenta del foro para identificarte
label-profile-link-desc-b = ante otros jugadores, unirte a servidores
label-profile-link-desc-c = privados y mostrar insignias.
button-profile-link = Vincular cuenta del foro OpenRA
button-profile-unlink = Desvincular cuenta del foro
label-forum-profile-description = Vincula una cuenta del foro para identificarte ante otros jugadores y mostrar insignias.
label-forum-profile-result-unlinked = La cuenta no está vinculada a un perfil del foro de OpenRA.
label-sendsysinfo-checkbox-container-desc = Los datos anónimos del sistema ayudan a los desarrolladores a mejorar OpenRA.
label-debug-hidden-container-a = Se pueden habilitar opciones adicionales para desarrolladores
label-debug-hidden-container-b = mediante la línea de comandos o en el archivo settings.yaml.
