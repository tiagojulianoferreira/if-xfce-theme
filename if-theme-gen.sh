#!/bin/bash
# if-theme-gen.sh - Gerador do Tema IF para XFCE
# Version: 6.0 (Base Estrutural: Windows11-gtk-theme / Cores: Gov.br)
# Autor: Tiago Juliano Ferreira / Engenharia de Interface
# Descrição: Instala o tema visual com a arquitetura do Windows11-gtk-theme e cores do Gov.br.

set -e  # Interrompe o script em caso de erro

# --- Configurações de Cores para o Terminal ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

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
    esac
}

# --- Geração do Tema ---
generate_theme() {
    log "STEP" "Iniciando geração do Tema IF (Engine Windows11 + Gov.br)..."
    
    if [[ $EUID -ne 0 ]]; then
        log "ERROR" "Este script precisa ser executado como root (sudo)."
        exit 1
    fi

    # Garante a presença do unzip
    if ! command -v unzip &> /dev/null; then
        log "INFO" "Instalando a dependência 'unzip'..."
        apt-get update -qq && apt-get install -y unzip -qq >/dev/null || true
    fi

    local THEME_NAME="IF-Theme"
    local THEME_DIR="/usr/share/themes/${THEME_NAME}"
    
    mkdir -p "${THEME_DIR}"/{gtk-3.0,gtk-4.0,xfwm4,xfce-notify-4.0}

    # 1. index.theme
    cat > "${THEME_DIR}/index.theme" << 'EOF'
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=IF-Theme
Comment=Tema baseado na arquitetura do Windows11-gtk-theme com cores do Gov.br
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=IF-Theme
MetacityTheme=IF-Theme
IconTheme=Papirus
CursorTheme=Adwaita
FontName=Rawline, Noto Sans 10
EOF

    # 2. gtk-3.0/gtk.css (Base Estrutural do Windows11-gtk-theme + Cores Gov.br)
    log "INFO" "Construindo motor CSS baseado em Windows11-gtk-theme..."
    cat > "${THEME_DIR}/gtk-3.0/gtk.css" << 'EOF'
/* ============================================================
   WINDOWS 11 GTK THEME ENGINE - GOV.BR COLOR PALETTE
   Baseado em: https://github.com/yeyushengfan258/Windows11-gtk-theme
   Cores: Design System do Gov.br
   ============================================================ */

/* ---------- Cores Oficiais Gov.br ---------- */
@define-color gov_azul #005ea2;          /* Azul Primário */
@define-color gov_azul_claro #0072c3;    /* Azul Hover */
@define-color gov_verde #00a91c;         /* Verde Sucesso */
@define-color gov_amarelo #ffb703;       /* Amarelo Alerta */
@define-color gov_vermelho #d83933;      /* Vermelho Erro */
@define-color gov_cinza_escuro #414141;  /* Cinza Escuro */
@define-color gov_cinza_claro #6f6f6f;   /* Cinza Claro */
@define-color gov_cinza_fundo #f0f2f5;   /* Fundo Claro */
@define-color gov_branco #ffffff;        /* Branco */
@define-color gov_preto #000000;         /* Preto */

/* ---------- Cores Institucionais IF ---------- */
@define-color if_verde #359830;          /* Verde IF */
@define-color if_vermelho #c90c0f;       /* Vermelho IF */

/* ---------- Mapeamento de Cores ---------- */
@define-color theme_base_color @gov_branco;
@define-color theme_bg_color @gov_cinza_fundo;
@define-color theme_fg_color @gov_preto;
@define-color theme_text_color @gov_preto;
@define-color theme_selected_bg_color @gov_azul;
@define-color theme_selected_fg_color @gov_branco;

/* ---------- Base ---------- */
* {
    font-family: "Rawline", "Segoe UI", "Helvetica", sans-serif;
    padding: 0;
    margin: 0;
    -gtk-icon-style: regular;
}

window, .background {
    background-color: @theme_bg_color;
    color: @theme_fg_color;
}

/* ---------- Cabeçalhos e Barras (Fluent Design) ---------- */
.header-bar,
.titlebar,
headerbar {
    background-color: @theme_base_color;
    color: @theme_fg_color;
    border-radius: 8px 8px 0 0;
    padding: 8px 12px;
    border-bottom: 1px solid rgba(0, 0, 0, 0.06);
    box-shadow: 0 1px 3px rgba(0, 0, 0, 0.04);
}

.header-bar label,
.titlebar label,
headerbar label {
    color: @theme_fg_color;
    font-weight: 500;
}

/* ---------- Botões (Estilo Windows 11) ---------- */
button {
    background-color: @theme_base_color;
    color: @theme_fg_color;
    border: 1px solid rgba(0, 0, 0, 0.1);
    border-radius: 6px;
    padding: 6px 16px;
    box-shadow: 0 1px 2px rgba(0, 0, 0, 0.04);
    transition: all 100ms cubic-bezier(0.4, 0, 0.2, 1);
}

button:hover {
    background-color: @gov_cinza_fundo;
    border-color: rgba(0, 0, 0, 0.18);
    box-shadow: 0 2px 4px rgba(0, 0, 0, 0.06);
}

button:active, button:checked {
    background-color: #e5e7eb;
    box-shadow: inset 0 1px 2px rgba(0, 0, 0, 0.08);
}

/* Botão Primário (Azul Gov) */
button.suggested-action {
    background-color: @gov_azul;
    border-color: @gov_azul;
    color: @gov_branco;
}
button.suggested-action:hover {
    background-color: @gov_azul_claro;
    border-color: @gov_azul_claro;
}

/* Botão de Sucesso (Verde IF) */
button.success-action {
    background-color: @if_verde;
    border-color: @if_verde;
    color: @gov_branco;
}
button.success-action:hover {
    background-color: #3fb038;
    border-color: #3fb038;
}

/* Botão de Alerta (Amarelo Gov) */
button.warning-action {
    background-color: @gov_amarelo;
    border-color: @gov_amarelo;
    color: @gov_preto;
}
button.warning-action:hover {
    background-color: #ffc820;
    border-color: #ffc820;
}

/* Botão de Destruição (Vermelho IF) */
button.destructive-action {
    background-color: @if_vermelho;
    border-color: @if_vermelho;
    color: @gov_branco;
}
button.destructive-action:hover {
    background-color: #e0191e;
    border-color: #e0191e;
}

/* ---------- Entradas de Texto (Estilo Fluent) ---------- */
entry {
    background-color: @theme_base_color;
    color: @theme_fg_color;
    border: 1px solid rgba(0, 0, 0, 0.12);
    border-radius: 6px;
    padding: 6px 12px;
    box-shadow: inset 0 1px 1px rgba(0, 0, 0, 0.02);
    transition: all 150ms ease;
}

entry:focus {
    border-color: @gov_azul;
    box-shadow: 0 0 0 3px rgba(0, 94, 162, 0.15);
}

/* ---------- Menus (Arredondados, Estilo Windows 11) ---------- */
menu,
.menu,
.popup {
    background-color: @theme_base_color;
    border: 1px solid rgba(0, 0, 0, 0.04);
    border-radius: 10px;
    padding: 4px;
    box-shadow: 0 6px 20px rgba(0, 0, 0, 0.08);
}

menu item,
.menu item {
    padding: 8px 16px;
    border-radius: 6px;
    color: @theme_fg_color;
    margin: 2px 0;
    transition: background 100ms ease;
}

menu item:hover,
.menu item:selected {
    background-color: rgba(0, 94, 162, 0.08);
    color: @gov_azul;
}

/* ---------- Barras de Rolagem (Estilo Windows 11) ---------- */
scrollbar {
    background-color: transparent;
}

scrollbar slider {
    background-color: rgba(0, 0, 0, 0.15);
    border-radius: 10px;
    min-width: 6px;
    min-height: 6px;
    margin: 2px;
}

scrollbar slider:hover {
    background-color: @gov_azul;
}

scrollbar trough {
    background-color: transparent;
    border: none;
}

/* ---------- Abas (Notebook) ---------- */
notebook stack {
    background-color: @theme_base_color;
    border: 1px solid rgba(0, 0, 0, 0.06);
    border-radius: 0 0 8px 8px;
}

notebook tab {
    padding: 10px 18px;
    background-color: transparent;
    border: none;
    color: @gov_cinza_claro;
    font-weight: 500;
    border-bottom: 2px solid transparent;
}

notebook tab:hover {
    background-color: rgba(0, 0, 0, 0.02);
    color: @theme_fg_color;
}

notebook tab:checked {
    color: @gov_azul;
    border-bottom: 2px solid @gov_azul;
}

/* ---------- Painel do XFCE (Estilo Windows 11) ---------- */
.xfce4-panel {
    background-color: rgba(30, 34, 43, 0.95);
    color: @gov_branco;
    box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
}

.xfce4-panel button {
    background-color: transparent;
    border: none;
    color: @gov_branco;
    border-radius: 6px;
    padding: 2px 8px;
}

.xfce4-panel button:hover {
    background-color: rgba(255, 255, 255, 0.08);
}

.xfce4-panel button:checked {
    background-color: rgba(255, 255, 255, 0.12);
}

/* ---------- Gerenciador de Arquivos (Thunar) ---------- */
.thunar .sidebar {
    background-color: @gov_cinza_fundo;
}

.thunar .sidebar row:selected {
    background-color: rgba(0, 94, 162, 0.12);
    color: @gov_azul;
}

.thunar .standard-view .entry {
    background-color: @theme_base_color;
}
EOF

    # 3. xfwm4/themerc (Estilo Windows 11)
    log "INFO" "Criando engine do Xfwm4..."
    cat > "${THEME_DIR}/xfwm4/themerc" << 'EOF'
# Tema para o Gerenciador de Janelas do XFCE (xfwm4)
# Estilo: Windows 11

theme=IF-Theme

# Cores
title_text_active=#1e222b
title_text_inactive=#6b7280
title_bg_active=#ffffff
title_bg_inactive=#f8f9fa
border_color_active=#005ea2
border_color_inactive=rgba(0,0,0,0.08)

# Dimensões
frame_border_top=8
title_vertical_offset_active=6
title_vertical_offset_inactive=6
button_offset=8
button_spacing=6

# Layout dos Botões (O=Menu, H=Minimizar, M=Maximizar, C=Fechar)
button_layout=O|HMC

# Sombras (Estilo Windows)
shadow_delta_x=4
shadow_delta_y=4
shadow_radius=12
shadow_color=#000000
shadow_opacity=25
EOF

    # 4. xfce-notify-4.0/gtk.css (Estilo Windows 11)
    log "INFO" "Criando engine de notificações..."
    cat > "${THEME_DIR}/xfce-notify-4.0/gtk.css" << 'EOF'
#XfceNotifyWindow {
    background-color: #1e222b;
    border-radius: 12px;
    padding: 16px 20px;
    border: 1px solid rgba(255, 255, 255, 0.06);
    box-shadow: 0 10px 30px rgba(0, 0, 0, 0.3);
}

#XfceNotifyWindow .osd {
    background-color: rgba(30, 34, 43, 0.95);
}

#XfceNotifyWindow label#summary {
    color: #ffffff;
    font-weight: 600;
    font-size: 14px;
    font-family: "Rawline", "Segoe UI", sans-serif;
}

#XfceNotifyWindow label#body {
    color: #abb2bf;
    font-size: 13px;
    font-family: "Rawline", "Segoe UI", sans-serif;
}

#XfceNotifyWindow button {
    background-color: #005ea2;
    border: none;
    color: white;
    border-radius: 6px;
    padding: 6px 16px;
    font-weight: 500;
}

#XfceNotifyWindow button:hover {
    background-color: #0072c3;
}

#XfceNotifyWindow progressbar {
    background-color: #414141;
    border-radius: 6px;
}

#XfceNotifyWindow progressbar progress {
    background-color: #00a91c;
    border-radius: 6px;
}
EOF

    # 5. Link de portabilidade
    ln -sf ../gtk-3.0/gtk.css "${THEME_DIR}/gtk-4.0/gtk.css"

    # 6. Instalação da Fonte Rawline via CDNFonts
    local FONT_DIR="/usr/share/fonts/truetype/rawline"
    if mkdir -p "$FONT_DIR" 2>/dev/null; then
        log "INFO" "Iniciando download do pacote completo via CDNFonts..."
        
        local TEMP_DIR=$(mktemp -d)
        
        if curl -fsSL -o "${TEMP_DIR}/rawline.zip" "https://cdnfonts.com"; then
            log "INFO" "Extraindo a família de fontes Rawline..."
            unzip -q -j "${TEMP_DIR}/rawline.zip" "*.ttf" -d "$FONT_DIR" 2>/dev/null || true
            unzip -q -j "${TEMP_DIR}/rawline.zip" "*.otf" -d "$FONT_DIR" 2>/dev/null || true
            
            rm -rf "$TEMP_DIR"
            fc-cache -f "$FONT_DIR" 2>/dev/null || true
            log "SUCCESS" "Todas as variações do CDNFonts foram implantadas!"
        else
            rm -rf "$TEMP_DIR"
            log "WARN" "Incapaz de alcançar o servidor CDNFonts. Fallback nativo ativo."
        fi
    fi

    # 7. Aplicação do Tema
    if [ -n "$SUDO_USER" ] && [ "$SUDO_USER" != "root" ]; then
        log "INFO" "Aplicando tema para o usuário $SUDO_USER..."
        sudo -u "$SUDO_USER" xfconf-query -c xsettings -p /Net/ThemeName -s "IF-Theme" 2>/dev/null || true
        sudo -u "$SUDO_USER" xfconf-query -c xfwm4 -p /general/theme -s "IF-Theme" 2>/dev/null || true
        log "SUCCESS" "Tema aplicado. Reinicie o painel se necessário."
    fi

    log "SUCCESS" "Instalação finalizada com sucesso!"
}

generate_theme
