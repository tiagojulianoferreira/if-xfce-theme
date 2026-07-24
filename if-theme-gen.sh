#!/bin/bash
# if-theme-gen.sh - Gerador do Tema IF para XFCE
# Version: 2.0
# Autor: Tiago Juliano Ferreira
# Descrição: Gera e instala o tema visual com a identidade da Rede Federal

set -e  # Interrompe o script em caso de erro

# --- Configurações de Cores para o Terminal ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly MAGENTA='\033[0;35m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m' # No Color

# --- Função de Log (com timestamp) ---
log() {
    local level=$1
    local message=$2
    local timestamp=$(date '+%H:%M:%S')
    
    case $level in
        "INFO")  echo -e "${BLUE}[${timestamp}] ℹ️  ${message}${NC}" ;;
        "SUCCESS") echo -e "${GREEN}[${timestamp}] ✅ ${message}${NC}" ;;
        "WARN")  echo -e "${YELLOW}[${timestamp}] ⚠️  ${message}${NC}" ;;
        "ERROR") echo -e "${RED}[${timestamp}] ❌ ${message}${NC}" >&2 ;;
        "STEP")  echo -e "\n${CYAN}[${timestamp}] 🚀 ${BOLD}${message}${NC}" ;;
        *)       echo "[${timestamp}] ${message}" ;;
    esac
}

# --- Função para verificar dependências ---
check_dependencies() {
    local deps=("xfconf-query" "xfce4-appearance-settings" "xfwm4-settings")
    local missing=()
    
    for dep in "${deps[@]}"; do
        if ! command -v "$dep" &> /dev/null; then
            missing+=("$dep")
        fi
    done
    
    if [ ${#missing[@]} -ne 0 ]; then
        log "WARN" "Algumas ferramentas do XFCE não foram encontradas: ${missing[*]}"
        log "INFO" "Certifique-se de que o XFCE está instalado. Continuando mesmo assim..."
    fi
}

# --- Função Principal de Geração do Tema ---
generate_theme() {
    log "STEP" "Iniciando geração do Tema IF..."
    
    # Verifica se está rodando como root
    if [[ $EUID -ne 0 ]]; then
        log "ERROR" "Este script precisa ser executado como root (sudo)."
        log "INFO" "Tente: sudo $0"
        exit 1
    fi

    local THEME_NAME="IF-Theme"
    local THEME_DIR="/usr/share/themes/${THEME_NAME}"
    
    # 1. Preparação do Ambiente
    log "INFO" "Preparando ambiente de instalação..."
    
    # Cria diretórios com permissões corretas
    mkdir -p "${THEME_DIR}"/{gtk-3.0,gtk-4.0,xfwm4,xfce-notify-4.0}
    
    # Verifica se é uma atualização e faz backup
    if [ -f "${THEME_DIR}/gtk-3.0/gtk.css" ]; then
        log "WARN" "Tema já existe. Criando backup..."
        cp -r "${THEME_DIR}" "${THEME_DIR}.backup.$(date +%Y%m%d%H%M%S)"
        log "SUCCESS" "Backup criado."
    fi

    # 2. Geração dos Arquivos do Tema
    log "INFO" "Gerando arquivos de configuração do tema..."

    # --- index.theme ---
    log "INFO" "Criando index.theme..."
    cat > "${THEME_DIR}/index.theme" << 'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=IF-Theme
Comment=Tema para XFCE com identidade visual do IF e Gov.br
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=IF-Theme
MetacityTheme=IF-Theme
IconTheme=Papirus
CursorTheme=Adwaita
FontName=Rawline, Noto Sans 10
EOF

    # --- gtk-3.0/gtk.css (com comentários para fácil manutenção) ---
    log "INFO" "Criando gtk-3.0/gtk.css..."
    cat > "${THEME_DIR}/gtk-3.0/gtk.css" << 'EOF'
/* ============================================================
   IF-Theme - Estilos para GTK 3
   Baseado na identidade visual da Rede Federal
   ============================================================ */

/* ---------- Cores Oficiais ---------- */
@define-color if_verde #359830;
@define-color if_vermelho #c90c0f;
@define-color gov_azul #005ea2;
@define-color if_preto #000000;
@define-color if_branco #ffffff;
@define-color if_cinza_escuro #454545;
@define-color if_cinza_claro #6f6f6f;
@define-color if_cinza_fundo #f8f9fa;

/* ---------- Base ---------- */
* {
    font-family: "Rawline", "Helvetica", "Noto Sans", sans-serif;
}

window {
    background-color: @if_branco;
    color: @if_preto;
}

/* ---------- Cabeçalhos e Barras ---------- */
.header-bar,
.titlebar {
    background-color: @gov_azul;
    color: @if_branco;
    border-radius: 0;
    padding: 8px 12px;
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
}

.header-bar label,
.titlebar label {
    color: @if_branco;
    font-weight: bold;
}

/* ---------- Botões ---------- */
button {
    background-color: @if_branco;
    border: 1px solid @if_cinza_claro;
    border-radius: 6px;
    color: @if_preto;
    padding: 6px 14px;
    transition: all 0.2s ease;
}

button:hover {
    background-color: #f0f0f0;
    border-color: @if_cinza_escuro;
}

button:active {
    background-color: #e0e0e0;
}

/* Botão Primário (Ação Principal) */
button.suggested-action {
    background-color: @gov_azul;
    border-color: @gov_azul;
    color: @if_branco;
}

button.suggested-action:hover {
    background-color: #0072c3;
    border-color: #0072c3;
}

/* Botão de Destruição (Ação Perigosa) */
button.destructive-action {
    background-color: @if_vermelho;
    border-color: @if_vermelho;
    color: @if_branco;
}

button.destructive-action:hover {
    background-color: #e0191e;
    border-color: #e0191e;
}

/* Botão de Sucesso */
button.success-action {
    background-color: @if_verde;
    border-color: @if_verde;
    color: @if_branco;
}

button.success-action:hover {
    background-color: #3fb038;
    border-color: #3fb038;
}

/* ---------- Entradas de Texto ---------- */
entry {
    border: 1px solid @if_cinza_claro;
    border-radius: 6px;
    padding: 6px 10px;
    background-color: @if_branco;
}

entry:focus {
    border-color: @gov_azul;
    box-shadow: 0 0 0 3px rgba(0, 94, 162, 0.25);
}

entry:disabled {
    background-color: @if_cinza_fundo;
    color: @if_cinza_claro;
}

/* ---------- Links ---------- */
.link-button {
    color: @gov_azul;
}

.link-button:hover {
    color: #0072c3;
    text-decoration: underline;
}

/* ---------- Separadores ---------- */
separator {
    background-color: @if_cinza_claro;
}

/* ---------- Menus ---------- */
menu,
.menu {
    background-color: @if_branco;
    border: 1px solid @if_cinza_claro;
    border-radius: 8px;
    padding: 4px 0;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
}

menu item,
.menu item {
    padding: 6px 16px;
}

menu item:hover,
.menu item:selected {
    background-color: @gov_azul;
    color: @if_branco;
}

/* ---------- Barras de Rolagem ---------- */
scrollbar slider {
    background-color: @if_cinza_claro;
    border-radius: 10px;
    min-width: 8px;
    min-height: 8px;
}

scrollbar slider:hover {
    background-color: @gov_azul;
}

scrollbar trough {
    background-color: @if_cinza_fundo;
    border-radius: 10px;
    border: 1px solid #e0e0e0;
}

/* ---------- Abas (Notebook) ---------- */
notebook tab {
    padding: 8px 16px;
    background-color: @if_cinza_fundo;
    border: 1px solid @if_cinza_claro;
    border-bottom: none;
    border-radius: 6px 6px 0 0;
}

notebook tab:checked {
    background-color: @if_branco;
    border-color: @gov_azul;
    border-bottom-color: @if_branco;
    color: @gov_azul;
}

notebook tab:hover {
    background-color: #e8e8e8;
}

/* ---------- Notificações (xfce4-notifyd) ---------- */
#XfceNotifyWindow {
    background-color: @if_preto;
    border-radius: 12px;
    padding: 16px;
    border: 2px solid @if_verde;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.3);
}

#XfceNotifyWindow .osd {
    background-color: rgba(0, 0, 0, 0.92);
}

#XfceNotifyWindow label#summary {
    color: @if_branco;
    font-weight: bold;
    font-size: 15px;
}

#XfceNotifyWindow label#body {
    color: #cccccc;
    font-size: 13px;
}

#XfceNotifyWindow button {
    background-color: @gov_azul;
    border: none;
    color: @if_branco;
    border-radius: 6px;
    padding: 6px 16px;
}

#XfceNotifyWindow button:hover {
    background-color: #0072c3;
}

#XfceNotifyWindow progressbar {
    background-color: @if_cinza_escuro;
    border-radius: 6px;
}

#XfceNotifyWindow progressbar progress {
    background-color: @if_verde;
    border-radius: 6px;
}

/* ---------- Scrollbars do XFCE (Específico) ---------- */
.xfce4-panel {
    background-color: @gov_azul;
    color: @if_branco;
}

.xfce4-panel button {
    background-color: transparent;
    border: none;
    color: @if_branco;
}

.xfce4-panel button:hover {
    background-color: rgba(255, 255, 255, 0.15);
}

/* ---------- Gerenciador de Arquivos (Thunar) ---------- */
.thunar .sidebar {
    background-color: @if_cinza_fundo;
}

.thunar .sidebar row:selected {
    background-color: @gov_azul;
    color: @if_branco;
}

/* ---------- Terminal (xfce4-terminal) ---------- */
.terminal-window {
    background-color: @if_preto;
}

.terminal-window .terminal-screen {
    color: @if_branco;
}
EOF

    # --- xfwm4/themerc ---
    log "INFO" "Criando xfwm4/themerc..."
    cat > "${THEME_DIR}/xfwm4/themerc" << 'EOF'
# ============================================================
# Tema para o Gerenciador de Janelas do XFCE (xfwm4)
# ============================================================

# ----- Cores -----
title_text_active=#ffffff
title_text_inactive=#cccccc

title_bg_active=#005ea2
title_bg_inactive=#6f6f6f

border_color_active=#359830
border_color_inactive=#454545

# ----- Dimensões -----
frame_border_top=14
title_vertical_offset_active=6
title_vertical_offset_inactive=6
button_offset=6
button_spacing=4

# ----- Layout dos Botões (O=Menu, H=Minimizar, M=Maximizar, C=Fechar) -----
# Layout padrão: Direita (estilo Windows)
button_layout=O|HMC

# ----- Sombras -----
shadow_delta_x=4
shadow_delta_y=4
shadow_radius=8
shadow_color=#000000
shadow_opacity=30
EOF

    # --- xfce-notify-4.0/gtk.css ---
    log "INFO" "Criando xfce-notify-4.0/gtk.css..."
    cat > "${THEME_DIR}/xfce-notify-4.0/gtk.css" << 'EOF'
#XfceNotifyWindow {
    background-color: #000000;
    border-radius: 12px;
    padding: 16px;
    border: 2px solid #359830;
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.4);
}

#XfceNotifyWindow .osd {
    background-color: rgba(0, 0, 0, 0.92);
}

#XfceNotifyWindow .osd:hover {
    background-color: rgba(0, 0, 0, 0.96);
}

#XfceNotifyWindow label#summary {
    color: #ffffff;
    font-weight: bold;
    font-size: 15px;
    font-family: "Rawline", sans-serif;
}

#XfceNotifyWindow label#body {
    color: #cccccc;
    font-size: 13px;
    font-family: "Rawline", sans-serif;
}

#XfceNotifyWindow button {
    background-color: #005ea2;
    border: none;
    color: white;
    border-radius: 6px;
    padding: 6px 16px;
}

#XfceNotifyWindow button:hover {
    background-color: #0072c3;
}

#XfceNotifyWindow progressbar {
    background-color: #454545;
    border-radius: 6px;
}

#XfceNotifyWindow progressbar progress {
    background-color: #359830;
    border-radius: 6px;
}
EOF

    # --- gtk-4.0/gtk.css (Link Simbólico) ---
    ln -sf ../gtk-3.0/gtk.css "${THEME_DIR}/gtk-4.0/gtk.css"

    # 3. Aplicação das Permissões
    log "INFO" "Ajustando permissões..."
    chmod -R 755 "${THEME_DIR}"
    chown -R root:root "${THEME_DIR}"

    log "SUCCESS" "Tema gerado com sucesso em ${THEME_DIR}"

    # 4. Tentar aplicar o tema automaticamente
    log "STEP" "Tentando aplicar o tema..."
    apply_theme
}

# --- Função para Aplicar o Tema ---
apply_theme() {
    local current_user=$(who am i | awk '{print $1}')
    
    # Se o script foi executado com sudo, usa o usuário que chamou o sudo
    if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
        current_user="$SUDO_USER"
    fi

    # Caso não seja possível detectar, usa o primeiro usuário com home
    if [ -z "$current_user" ] || [ "$current_user" = "root" ]; then
        current_user=$(ls /home/ | head -n 1)
    fi

    if [ -z "$current_user" ]; then
        log "WARN" "Não foi possível detectar um usuário para aplicar o tema."
        log "INFO" "Aplique manualmente via: Configurações > Aparência > IF-Theme"
        return 0
    fi

    log "INFO" "Aplicando tema para o usuário: ${current_user}"

    # Aplica via xfconf-query para o usuário
    local user_home="/home/${current_user}"
    if [ -d "$user_home/.config" ]; then
        # GTK Theme
        sudo -u "$current_user" xfconf-query -c xfce4-desktop -p /gtk-theme -s "IF-Theme" 2>/dev/null || {
            log "WARN" "Não foi possível aplicar o tema GTK via xfconf-query."
            log "INFO" "Aplique manualmente: Configurações > Aparência"
        }
        
        # Xfwm4 Theme
        sudo -u "$current_user" xfconf-query -c xfwm4 -p /general/theme -s "IF-Theme" 2>/dev/null || {
            log "WARN" "Não foi possível aplicar o tema do gerenciador de janelas."
            log "INFO" "Aplique manualmente: Configurações > Gerenciador de Janelas"
        }
        
        log "SUCCESS" "Tema aplicado para ${current_user}"
    else
        log "WARN" "Diretório .config não encontrado para ${current_user}"
        log "INFO" "Aplique manualmente após o primeiro login."
    fi
}

# --- Função Principal ---
main() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║  ${BOLD}🏛️  GERADOR DE TEMA IF-XFCE v2.0${NC}                                         ${CYAN}║${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}║  Identidade Visual da Rede Federal + Design System Gov.br                     ║${NC}"
    echo -e "${CYAN}║                                                                              ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log "INFO" "Verificando dependências..."
    check_dependencies

    generate_theme

    echo ""
    log "STEP" "Instalação concluída!"
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                              ║${NC}"
    echo -e "${GREEN}║  ✅  Tema instalado com sucesso!                                             ║${NC}"
    echo -e "${GREEN}║                                                                              ║${NC}"
    echo -e "${GREEN}║  📁  Localização: /usr/share/themes/IF-Theme                                ║${NC}"
    echo -e "${GREEN}║                                                                              ║${NC}"
    echo -e "${GREEN}║  Caso o tema não tenha sido aplicado automaticamente:                        ║${NC}"
    echo -e "${GREEN}║    1. Abra: Configurações > Aparência                                       ║${NC}"
    echo -e "${GREEN}║    2. Selecione: IF-Theme                                                   ║${NC}"
    echo -e "${GREEN}║                                                                              ║${NC}"
    echo -e "${GREEN}║  Para reaplicar manualmente:                                                 ║${NC}"
    echo -e "${GREEN}║     xfconf-query -c xfce4-desktop -p /gtk-theme -s \"IF-Theme\"              ║${NC}"
    echo -e "${GREEN}║     xfconf-query -c xfwm4 -p /general/theme -s \"IF-Theme\"                  ║${NC}"
    echo -e "${GREEN}║                                                                              ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Pergunta se deseja reiniciar o painel para aplicar mudanças imediatas
    read -p "Deseja reiniciar o painel do XFCE agora? (s/N) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        log "INFO" "Reiniciando painel..."
        if [ -n "$current_user" ]; then
            sudo -u "$current_user" xfce4-panel -r 2>/dev/null || {
                log "WARN" "Não foi possível reiniciar o painel automaticamente."
                log "INFO" "Reinicie manualmente com: xfce4-panel -r"
            }
            log "SUCCESS" "Painel reiniciado. O tema deve ser aplicado imediatamente."
        fi
    else
        log "INFO" "Lembre-se de reiniciar o painel manualmente para ver as mudanças: xfce4-panel -r"
    fi
}

# --- Executa a função principal ---
main "$@"
