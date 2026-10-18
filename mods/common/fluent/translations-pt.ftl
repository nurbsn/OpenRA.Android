## ====================================================================
## Tradução em Português para OpenRA (nOpenRA Mobile)
## ====================================================================

## Botões gerais (Common Buttons)
button-cancel = Cancelar
button-retry = Tentar novamente
button-back = Voltar
button-continue = Continuar
button-quit = Sair
button-ok = OK
button-close = Fechar
button-prompt-confirm = Confirmar
button-prompt-other = Reiniciar
button-text-input-prompt-accept = OK
button-container-ok = OK

## Gestor de Mods e Conteúdo (Mod Manager)
label-mod-manager-title = Gestor de Mods e Conteúdo
button-tab-installed-mods = Mods instalados
button-tab-download-mods = Baixar Mods
button-tab-storage-folder = Pasta de Dados e Mapas
button-mod-active = Ativo
button-mod-switch = Alternar
label-mod-active-tag = [ATIVO]
label-mod-version = versão
button-refresh-list = Atualizar lista
label-download-desc = Insira o URL direto do arquivo do mod (.zip ou .oramod):
button-paste-link = Colar link
button-download-install = Baixar e Instalar
label-ready-download = Pronto para baixar
label-popular-mods = Mods populares do OpenRA (toque para preencher o link):
label-storage-desc-1 = Diretório raiz para mods (/mods) e mapas (/maps):
label-storage-desc-2 = No Android recente, /Android/data/ é bloqueado. Escolha uma pasta compartilhada:
label-storage-presets = Locais rápidos (toque para selecionar):
button-storage-shared = Armazenamento interno (/storage/emulated/0/OpenRA)
button-storage-download = Pasta Downloads (/storage/emulated/0/Download/OpenRA)
button-storage-documents = Pasta Documentos (/storage/emulated/0/Documents/OpenRA)
button-storage-default = Diretório padrão do aplicativo
button-save-create-folders = Salvar e Criar Pastas
button-mods-title = Mods
label-storage-error-empty = Erro: o caminho não pode estar vazio.
label-storage-saved = Salvo! Pastas /mods e /maps criadas.
label-download-error-url = Erro: URL inválido.
label-download-error-protocol = Erro: Apenas protocolos HTTP e HTTPS são suportados.
label-download-connecting = Conectando ao servidor...
label-download-installing = Instalando e extraindo...
label-download-success = Mod instalado com sucesso!

## Configurações de idioma (Language Settings)
button-panel-language = Idioma
label-language-section-header = IDIOMA E TRADUÇÕES
label-select-language = Idioma:
label-language-restart-info = Selecione o idioma do aplicativo. O gestor de mods, as configurações e a interface traduzida serão atualizados imediatamente.
button-language-en = English
button-language-pl = Polski
button-language-de = Deutsch
button-language-es = Español
button-language-fr = Français
button-language-pt = Português
button-language-it = Italiano
button-language-ru = Русский

## Menu principal (Main Menu)
label-singleplayer-title = Um jogador
label-multiplayer-title = Multijogador
button-settings-title = Configurações
button-extras-title = Extras
button-main-menu-content = Gerenciar conteúdo
button-singleplayer-menu-skirmish = Escaramuça
button-singleplayer-menu-load = Carregar jogo
label-missions-title = Missões
button-extras-menu-replays = Replays
label-music-title = Música
label-map-editor-title = Editor de mapas
button-extras-menu-assetbrowser = Explorador de recursos
label-credits-title = Créditos
button-map-editor-new-map = Novo mapa
button-map-editor-load-map = Carregar mapa
dropdownbutton-news-bg-button = Notícias do front
label-loading-news = Carregando notícias...

## Abas de configurações (Settings Tabs)
button-settings-panel-reset = Redefinir
button-panel-gameplay = Jogo
button-panel-input = Controles
button-panel-display = Vídeo
button-panel-audio = Áudio
button-panel-hotkeys = Atalhos
button-panel-advanced = Avançado

## Configurações - Controles (Input Settings)
label-input-section-header = Controles
label-touch-hold-duration-slider = Atraso do toque para caixa de seleção:
label-touch-navigation-title = Navegação por toque móvel
label-touch-desc-tap = - Toque simples: Selecionar unidades/estruturas, mover ou atacar
label-touch-desc-swipe = - Deslizar (Swipe): Mover a câmera suavemente pelo mapa (PAN)
label-touch-desc-pinch = - Pinça (Pinch): Aproximar e afastar o zoom com dois dedos
label-touch-desc-hold = - Segurar (Hold): Ativar seleção retangular de área
label-mouse-control-container = Esquema de controle:
label-zoom-modifier-container = Modificador de zoom:
checkbox-edgescroll-container = Rolagem nas bordas da tela
checkbox-alternate-scroll-container = Rolagem alternativa do mouse
checkbox-lockmouse-container = Travar mouse na janela
label-mouse-scroll-type-container = Comportamento da rolagem:
label-scrollspeed-slider-container-scroll-speed = Velocidade da câmera:
label-zoomspeed-slider-container-zoom-speed = Velocidade do zoom:
label-ui-scrollspeed-slider-container-scroll-speed = Velocidade de rolagem da UI:

options-mouse-scroll-type =
    .disabled = Desativado
    .standard = Padrão
    .inverted = Invertido
    .joystick = Joystick

options-control-scheme =
    .classic = Clássico
    .modern = Moderno
    .otherrts = Outro RTS

## Configurações - Jogo e Perfil (Gameplay & Profile Settings)
label-profile-section-header = Perfil
label-player-container = Nome do jogador:
label-playercolor-container-color = Cor preferida:
label-gameplay-section-header = Jogo
label-auto-save-interval = Frequência de salvamento auto:
label-auto-save-max-file-number = Limite de salvamentos auto:
checkbox-hide-replay-chat-container = Ocultar chat nos replays
label-forum-profile-section-header = Conta do Fórum OpenRA
label-forum-profile-username = Usuário:
label-forum-profile-password = Senha:
button-forum-profile-link = Vincular conta
button-forum-profile-unlink = Desvincular conta
button-forum-profile-retry = Tentar novamente
button-forum-visit-forum = Visitar fórum

auto-save-interval =
    .disabled = Desativado
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

auto-save-max-file-number = { $saves } salvamentos

## Configurações - Vídeo (Display Settings)
label-display-section-header = Exibição
label-battlefield-camera-dropdown = Câmera de batalha:
label-ui-scale-dropdown = Escala da interface (UI):
checkbox-cursordouble-container = Aumentar tamanho do cursor
label-target-lines-dropdown-container = Linhas de alvo:
label-status-bar-dropdown-container-bars = Barras de vida:

checkbox-player-stance-colors-container =
    .label = Cores de relação dos jogadores
    .tooltip = Altera as cores conforme a relação (próprio, inimigo, aliado, neutro)

checkbox-ui-feedback-container =
    .label = Mostrar notificações da interface
    .tooltip = Exibe notificações de texto para eventos da interface

checkbox-transients-container =
    .label = Mostrar notificações de eventos de jogo
    .tooltip = Exibe notificações de texto para eventos da partida

checkbox-pause-shellmap-container = Pausar fundo do menu
label-video-section-header = Vídeo
label-video-mode-dropdown-container = Modo de vídeo:
dropdownbutton-video-mode-dropdown-container = Em janela
label-window-resolution-container-size = Tamanho da janela:
label-resolution-preset = Predefinições:
dropdownbutton-resolution-select-preset = Selecionar predefinição
label-display-selection-container = Selecionar tela:
checkbox-vsync-container = Ativar VSync
checkbox-frame-limit-gamespeed-container = Limitar quadros à taxa do jogo
label-gl-profile-dropdown-container = Perfil OpenGL:
label-restart-required-container-video-desc = Alterações de tela e OpenGL exigem reinicialização
checkbox-frame-limiter = Limitador de quadros ({ $fps } FPS)

options-camera =
    .close = Perto
    .medium = Médio
    .far = Longe
    .furthest = Muito longe

options-display-mode =
    .windowed = Em janela
    .legacy-fullscreen = Tela cheia (Clássico)
    .fullscreen = Tela cheia

options-status-bars =
    .standard = Padrão
    .show-on-damage = Mostrar ao sofrer dano
    .always-show = Mostrar sempre

options-target-lines =
    .automatic = Automáticas
    .manual = Manuais
    .disabled = Desativadas

## Configurações - Áudio (Audio Settings)
label-audio-section-header = Áudio
label-no-audio-device-container = Os controles de áudio exigem um dispositivo ativo
checkbox-cash-ticks-container = Som do contador de créditos
checkbox-mute-sound-container = Silenciar som
label-sound-volume-container = Volume dos efeitos:

checkbox-mute-background-music-container =
    .label = Silenciar música do menu
    .tooltip = Silencia a música de fundo quando nenhuma faixa está tocando

label-music-title-volume-container = Volume da música:
label-audio-device-container = Dispositivo de áudio:
label-video-volume-container = Volume de vídeo:
label-restart-required-container-audio-desc = Alterações de dispositivo serão aplicadas após reiniciar

## Configurações - Avançado (Advanced Settings)
label-network-section-header = Avançado
checkbox-nat-discovery-container = Ativar descoberta UPnP/NAT-PMP
checkbox-fetch-news-container = Buscar notícias da comunidade
checkbox-perfgraph-container = Mostrar gráfico de desempenho
checkbox-check-version-container = Verificar atualizações
checkbox-perftext-container = Mostrar texto de desempenho (FPS)
checkbox-sendsysinfo-container = Enviar informações anônimas do sistema
checkbox-enable-discord-service-container = Ativar Discord Rich Presence
label-debug-section-header = Desenvolvedor

## Diálogos de confirmação (Confirmation Dialogs)
dialog-settings-save =
    .title = Reinicialização necessária
    .prompt = Algumas alterações só serão aplicadas após reiniciar o jogo.
    .cancel = Continuar

dialog-settings-restart =
    .title = Reiniciar agora?
    .prompt = Algumas alterações exigem reiniciar o jogo. Reiniciar agora?
    .confirm = Reiniciar agora
    .cancel = Reiniciar depois

dialog-settings-reset =
    .title = Redefinir { $panel }
    .prompt = Tem certeza de que deseja redefinir todas as configurações deste painel?
    .confirm = Redefinir
    .cancel = Cancelar

## Sala, Escaramuça e Multijogador (Lobby, Skirmish & Multiplayer)
dropdownbutton-server-lobby-slots = Gerenciar vagas
button-server-lobby-reset-options = Padrões
button-skirmish-tabs-players-tab = Jogadores
button-skirmish-tabs-options-tab = Opções
button-multiplayer-tabs-players-tab = Jogadores
button-multiplayer-tabs-options-tab = Opções
button-multiplayer-tabs-servers-tab = Servidores
button-server-lobby-changemap = Mudar mapa
button-server-lobby-start-game = Iniciar jogo
button-server-lobby-disconnect = Sair da sala
label-lobby-options-bin-title = Opções do mapa
label-lobby-players-name = Nome
label-lobby-players-color = Cor
label-lobby-players-faction = Facção
label-lobby-players-team = Equipe
label-lobby-players-handicap = Desvantagem
label-lobby-players-spawn = Início
label-lobby-players-ready = Pronto
button-lobby-players-join = Jogar nesta vaga
label-lobby-players-spectator = Espectador
checkbox-lobby-players-new-spectator-toggle = Permitir espectadores?
button-lobby-players-spectate = Assistir
label-bot-player = Jogador IA (Bot)

options-slot-admin =
    .add-bots = Adicionar bots
    .remove-bots = Remover bots
    .configure-bots = Configurar bots
    .teams-count = { $count } Equipes
    .humans-vs-bots = Humanos vs Bots
    .free-for-all = Todos contra todos
    .configure-teams = Configurar equipes

options-lobby-slot =
    .slot = Vaga
    .open = Aberta
    .closed = Fechada
    .bots = Bots
    .bots-disabled = Bots desativados

options-game-speed =
    .slowest = Muito lenta
    .slower = Lenta
    .normal = Normal
    .fast = Rápida
    .faster = Muito rápida
    .fastest = Máxima

options-time-limit =
    .no-limit = Sem limite
    .options =
        { $minutes ->
            [one] { $minutes } minuto
           *[other] { $minutes } minutos
        }

## Opções de regras (Rules Options in Lobby)
checkbox-fog-of-war =
    .label = Névoa de guerra
    .description = Linha de visão é necessária para ver as forças inimigas

checkbox-explored-map =
    .label = Mapa explorado
    .description = O mapa começa totalmente revelado

checkbox-debug-menu =
    .label = Trapaças (Cheats)
    .description = Ativa trapaças e comandos de desenvolvedor

checkbox-crates =
    .label = Caixas de bônus
    .description = Colete caixas com unidades para receber bônus aleatórios

checkbox-ally-build-radius =
    .label = Construir perto de aliados
    .description = Permite construir estruturas dentro da área de aliados

checkbox-build-radius =
    .label = Limitar área de construção
    .description = Limita construções ao redor do Pátio de Construção

checkbox-short-game =
    .label = Jogo curto
    .description = Os jogadores são derrotados quando suas bases são destruídas

dropdown-tech-level =
    .label = Nível tecnológico
    .description = Unidades e habilidades disponíveis na partida

dropdown-game-speed =
    .label = Velocidade do jogo
    .description = Controla a velocidade em que o tempo passa

checkbox-separate-team-spawns =
    .label = Separar início das equipes
    .description = Jogadores sem posição definida começam longe dos inimigos

dropdown-starting-units =
    .label = Unidades iniciais
    .description = Unidades com as quais os jogadores iniciam a partida

dropdown-time-limit =
    .label = Limite de tempo
    .description = O jogador ou equipe com maior pontuação ao final do tempo vence

## Seleção de mapa e Missões (Map Chooser & Mission Browser)
label-mapchooser-panel-title = Escolher mapa
label-filter-order-controls-desc = Filtrar:
label-filter-order-controls-orderby = Ordenar por:
button-mapchooser-panel-randommap = Mapa aleatório
button-mapchooser-panel-delete-map = Excluir mapa
button-mapchooser-panel-delete-all-maps = Excluir todos
button-mapchooser-panel-ok = OK
button-mapchooser-system-maps-tab = Mapas oficiais
button-mapchooser-remote-maps-tab = Mapas do servidor
button-mapchooser-user-maps-tab = Mapas personalizados
button-mapchooser-generated-maps-tab = Gerar mapa
label-all-maps = Todos os mapas
label-no-matches = Nenhum resultado
label-created-by = Criado por { $author }
label-map-size-huge = Enorme
label-map-size-large = Grande
label-map-size-medium = Médio
label-map-size-small = Pequeno

options-order-maps =
    .player-count = Jogadores
    .title = Título
    .date = Data
    .size = Tamanho

button-missionbrowser-panel-start-briefing-video = Ver instruções
button-missionbrowser-panel-stop-briefing-video = Parar vídeo
button-missionbrowser-panel-start-info-video = Vídeo informativo
button-missionbrowser-panel-stop-info-video = Parar vídeo
button-missionbrowser-panel-play = Jogar
button-missionbrowser-panel-mission-info = Info da missão
button-missionbrowser-panel-mission-options = Opções
dropdown-missionbrowser-difficulty =
    .label = Dificuldade
    .description = Nível de dificuldade da missão
dropdown-missionbrowser-gamespeed = Velocidade:
label-missionbrowser-normal-difficulty = Normal

## Salvar/Carregar e Replays (Save/Load & Replays)
label-gamesave-browser-panel-load-title = Carregar jogo
label-gamesave-browser-panel-save-title = Salvar jogo
button-gamesave-browser-panel-delete-all = Excluir tudo
button-gamesave-browser-panel-delete = Excluir
button-gamesave-browser-panel-rename = Renomear
button-gamesave-browser-panel-load = Carregar
button-gamesave-browser-panel-save = Salvar
label-load-game-browser-panel-title = Carregar jogo
label-load-game-browser-panel-choose-save = Escolher salvamento
button-load-game-browser-panel-load = Carregar
label-replaybrowser-panel-title = Visualizador de replays
button-replaybrowser-panel-watch = Assistir

## Menu no jogo e HUD (In-Game Menu & HUD)
label-menu-buttons-title = Opções
button-top-buttons-options-tooltip = Opções
button-top-buttons-beacon-tooltip = Colocar sinalizador
button-top-buttons-sell-tooltip = Vender
button-top-buttons-power-tooltip = Desligar energia
button-top-buttons-repair-tooltip = Reparar
button-production-types-building-tooltip = Estruturas
button-production-types-defense-tooltip = Defesa
button-production-types-infantry-tooltip = Infantaria
button-production-types-vehicle-tooltip = Veículos
button-production-types-aircraft-tooltip = Aeronaves
button-production-types-naval-tooltip = Naval
label-mute-indicator = Áudio silenciado
label-paused = Pausado

supportpowers-support-powers-palette =
    .ready = PRONTO
    .hold = EM ESPERA

productionpalette-sidebar-production-palette =
    .ready = PRONTO
    .hold = EM ESPERA

menu-ingame =
    .leave = Sair
    .abort = Abortar missão
    .restart = Reiniciar
    .surrender = Render-se
    .load-game = Carregar jogo
    .save-game = Salvar jogo
    .music = Música
    .settings = Configurações
    .return-to-map = Voltar ao mapa
    .resume = Continuar
    .save-map = Salvar mapa
    .exit-map = Sair do editor
    .next-mission = Próxima missão

menu-game-info =
    .objectives = Objetivos
    .briefing = Instruções
    .options = Opções
    .debug = Trapaças
    .chat = Chat

label-mission-objectives = Missão:
label-mission-objective = Missão:
checkbox-stats-objective = Destrua toda a oposição!
label-stats-player = Jogador
label-stats-faction = Facção
label-stats-score = Pontos
label-stats-actions = Ações
label-mission-in-progress = Em andamento
label-mission-accomplished = Concluída
label-mission-failed = Falhou

dialog-leave-mission =
    .title = Sair da missão
    .prompt = Sair deste jogo e voltar ao menu?
    .confirm = Sair
    .cancel = Ficar

dialog-restart-mission =
    .title = Reiniciar
    .prompt = Tem certeza de que deseja reiniciar a missão?
    .confirm = Reiniciar
    .cancel = Ficar

dialog-surrender =
    .title = Render-se
    .prompt = Tem certeza de que deseja se render?
    .confirm = Render-se
    .cancel = Ficar

label-profile-link-desc-a = Vincule uma conta do fórum para se identificar
label-profile-link-desc-b = perante outros jogadores, entrar em servidores
label-profile-link-desc-c = privados e exibir insígnias.
button-profile-link = Vincular conta do fórum OpenRA
button-profile-unlink = Desvincular conta do fórum
label-forum-profile-description = Vincule uma conta do fórum para se identificar perante outros jogadores e exibir insígnias.
label-forum-profile-result-unlinked = A conta não está vinculada a um perfil do fórum OpenRA.
label-sendsysinfo-checkbox-container-desc = Dados anônimos do sistema ajudam os desenvolvedores a melhorar o OpenRA.
label-debug-hidden-container-a = Opções adicionais de desenvolvedor podem ser ativadas
label-debug-hidden-container-b = via linha de comando ou no arquivo settings.yaml.
