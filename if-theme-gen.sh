#!/bin/bash
# if-theme-builder.sh - Constrói o tema IF-XFCE do zero
# Versão: 1.0
# Descrição: Cria toda a estrutura e arquivos do tema em um único comando
# Uso: curl -fsSL https://seu-servidor/if-theme-builder.sh | bash

set -e  # Interrompe em caso de erro

# --- Cores para output ---
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly BOLD='\033[1m'
readonly NC='\033[0m'

# --- Funções de log ---
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

log_step() {
    echo -e "\n${CYAN}▶ ${BOLD}$1${NC}"
}

# --- Função principal ---
main() {
    # Limpa a tela apenas se for um terminal interativo
    if [ -t 1 ]; then
        clear
    fi
    
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                  ║${NC}"
    echo -e "${CYAN}║     🏛️  CONSTRUTOR DO TEMA IF-XFCE v1.0                          ║${NC}"
    echo -e "${CYAN}║                                                                  ║${NC}"
    echo -e "${CYAN}║     Base: Windows11-gtk-theme + Identidade IF + Gov.br           ║${NC}"
    echo -e "${CYAN}║                                                                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # --- Verifica dependências ---
    log_step "Verificando dependências"
    if ! command -v sassc &> /dev/null; then
        log_warn "sassc não encontrado. Instalando..."
        if command -v apt &> /dev/null; then
            sudo apt update -qq && sudo apt install -y sassc -qq
            log_success "sassc instalado!"
        else
            log_error "sassc não encontrado e APT não disponível. Instale manualmente."
            exit 1
        fi
    else
        log_success "sassc encontrado!"
    fi

    # --- Cria estrutura de diretórios ---
    log_step "Criando estrutura de diretórios"
    
    BASE_DIR="if-xfce-theme"
    mkdir -p "$BASE_DIR"/src/{_sass/gtk,_sass/xfwm4,gtk-3.0,gtk-4.0,xfwm4,xfce-notify-4.0}
    cd "$BASE_DIR"
    log_success "Estrutura criada em: $(pwd)"

    # ============================================================
    # 1. ARQUIVOS DE CORES (SCSS)
    # ============================================================
    
    log_step "Criando arquivos de cores"

    # 1.1 Cores Base (comuns a todos os perfis)
    cat > "src/_sass/_colors.scss" << 'EOF'
// _colors.scss - Cores Base do Sistema
// Cores oficiais: IF + Gov.br

// Cores IF
$if_verde: #2f9e41;
$if_vermelho: #cd191e;
$if_preto: #000000;

// Cores Gov.br
$gov_azul: #005ea2;
$gov_azul_claro: #0072c3;
$gov_amarelo: #ffb703;
$gov_vermelho: #d83933;
$gov_verde: #00a91c;

// Cores de interface (mapeamento)
$base_color: #ffffff;
$text_color: #1e222b;
$bg_color: #f8f9fa;
$selected_bg_color: $gov_azul;
$selected_fg_color: #ffffff;
$border_color: rgba(0, 0, 0, 0.08);
$text_muted_color: #6b7280;

// Cores do gerenciador de janelas
$wm_bg: $bg_color;
$wm_unfocused_bg: #ffffff;
$wm_highlight: rgba(255,255,255,0.4);
$wm_title: $text_color;
$wm_unfocused_title: rgba(0,0,0,0.6);
$wm_button_close_hover_bg: #E57373;
$wm_button_close_active_bg: #E53935;
EOF
    log_info "Criado: src/_sass/_colors.scss"

    # 1.2 Cores - Perfil Administrativo
    cat > "src/_sass/_colors-if-admin.scss" << 'EOF'
// _colors-if-admin.scss - Perfil Administrativo
// Sobriedade, profissionalismo, foco em produtividade

@import "colors";

// Mapeamento para o Windows11-gtk-theme
$primary: $gov_azul;
$primary_bg_hover: $gov_azul_claro;
$success: $if_verde;
$success_bg_hover: #3fb038;
$warning: $gov_amarelo;
$danger: $gov_vermelho;
$link_color: $gov_azul;
$link_visited_color: #7c3aed;

// Fundos
$bg_color: #f8f9fa;
$view_color: #ffffff;
$text_color: #1e222b;
$text_muted_color: #6b7280;
$border_color: rgba(0,0,0,0.08);

// Seleção
$selected_bg_color: $gov_azul;
$selected_fg_color: #ffffff;
EOF
    log_info "Criado: src/_sass/_colors-if-admin.scss"

    # 1.3 Cores - Perfil Acadêmico
    cat > "src/_sass/_colors-if-academic.scss" << 'EOF'
// _colors-if-academic.scss - Perfil Acadêmico
// Energia, inovação, tecnologia (Dark Mode)

@import "colors";

// Mapeamento para o Windows11-gtk-theme
$primary: $if_vermelho;
$primary_bg_hover: #e0191e;
$success: $gov_verde;
$success_bg_hover: #00c420;
$warning: $gov_amarelo;
$danger: $gov_vermelho;
$link_color: $if_vermelho;
$link_visited_color: #ce93d8;

// Fundos (Dark)
$bg_color: #1a1a1a;
$view_color: #2d2d2d;
$text_color: #ffffff;
$text_muted_color: #abb2bf;
$border_color: rgba(255,255,255,0.08);

// Seleção
$selected_bg_color: $if_vermelho;
$selected_fg_color: #ffffff;
EOF
    log_info "Criado: src/_sass/_colors-if-academic.scss"

    # 1.4 Cores - Perfil Comunidade
    cat > "src/_sass/_colors-if-community.scss" << 'EOF'
// _colors-if-community.scss - Perfil Comunidade
// Amigável, acessível, cores vibrantes

@import "colors";

// Mapeamento para o Windows11-gtk-theme
$primary: $gov_azul;
$primary_bg_hover: $gov_azul_claro;
$success: $if_verde;
$success_bg_hover: #3fb038;
$warning: $gov_amarelo;
$danger: $gov_vermelho;
$link_color: $gov_azul;
$link_visited_color: #7c3aed;

// Fundos (Claro e vibrante)
$bg_color: #f0f2f5;
$view_color: #ffffff;
$text_color: #1e222b;
$text_muted_color: #6b7280;
$border_color: rgba(0,0,0,0.08);

// Seleção
$selected_bg_color: $gov_azul;
$selected_fg_color: #ffffff;
EOF
    log_info "Criado: src/_sass/_colors-if-community.scss"

    # ============================================================
    # 2. VARIÁVEIS ESTRUTURAIS
    # ============================================================
    
    log_step "Criando variáveis estruturais"

    cat > "src/_sass/_variables.scss" << 'EOF'
// _variables.scss - Variáveis estruturais
// Fonte oficial: Rawline (Gov.br)
$font-family: "Rawline", "Noto Sans", "Helvetica", "Segoe UI", sans-serif;
$font-size: 10pt;
$title-font-size: 11pt;
$compact-font-size: 9pt;

// Arredondamentos
$roundness: 4px;
$roundness-ext: 6px;

// Painel XFCE
$panel_radius: 0px;
$panel_height: 32px;

// Sombras
$shadow: 0 1px 2px rgba(0,0,0,0.12), 0 4px 5px rgba(0,0,0,0.16), 0 1px 6px rgba(0,0,0,0.1);
EOF
    log_info "Criado: src/_sass/_variables.scss"

    # ============================================================
    # 3. ARQUIVOS DE ENTRADA (GTK SCSS)
    # ============================================================
    
    log_step "Criando arquivos de entrada GTK"

    # 3.1 Administrativo
    cat > "src/gtk-3.0/gtk-admin.scss" << 'EOF'
// gtk-admin.scss - Perfil Administrativo
$variant: "light";
$topbar: "dark";
$compact: "false";

@import "../_sass/variables";
@import "../_sass/colors-if-admin";
@import "../_sass/gtk/drawing-4.0";
@import "../_sass/gtk/common-4.0";
@import "../_sass/gtk/apps-4.0";
@import "../_sass/gtk/colors-public";
EOF
    log_info "Criado: src/gtk-3.0/gtk-admin.scss"

    # 3.2 Acadêmico
    cat > "src/gtk-3.0/gtk-academic.scss" << 'EOF'
// gtk-academic.scss - Perfil Acadêmico
$variant: "dark";
$topbar: "dark";
$compact: "false";

@import "../_sass/variables";
@import "../_sass/colors-if-academic";
@import "../_sass/gtk/drawing-4.0";
@import "../_sass/gtk/common-4.0";
@import "../_sass/gtk/apps-4.0";
@import "../_sass/gtk/colors-public";
EOF
    log_info "Criado: src/gtk-3.0/gtk-academic.scss"

    # 3.3 Comunidade
    cat > "src/gtk-3.0/gtk-community.scss" << 'EOF'
// gtk-community.scss - Perfil Comunidade
$variant: "light";
$topbar: "dark";
$compact: "false";

@import "../_sass/variables";
@import "../_sass/colors-if-community";
@import "../_sass/gtk/drawing-4.0";
@import "../_sass/gtk/common-4.0";
@import "../_sass/gtk/apps-4.0";
@import "../_sass/gtk/colors-public";
EOF
    log_info "Criado: src/gtk-3.0/gtk-community.scss"

    # ============================================================
    # 4. ARQUIVOS DE ESTILO GTK (SCSS) - CORRIGIDOS
    # ============================================================
    
    log_step "Criando arquivos de estilo GTK"

    # 4.1 drawing-4.0.scss (CORRIGIDO - sem alpha(currentColor))
    cat > "src/_sass/gtk/drawing-4.0.scss" << 'EOF'
// drawing-4.0.scss - Desenhos e estados básicos
// Baseado no Windows11-gtk-theme

// Funções de desenho
@function alpha($color, $alpha) {
    @return rgba($color, $alpha);
}

@function shade($color, $amount) {
    @if $amount > 1 {
        @return mix(white, $color, ($amount - 1) * 100);
    } @else {
        @return mix(black, $color, (1 - $amount) * 100);
    }
}

// Estados básicos (usando variáveis de cor diretamente)
%state-hover {
    background-color: rgba(0, 0, 0, 0.08);
    color: $text_color;
}

%state-active {
    background-color: rgba(0, 0, 0, 0.16);
    color: $text_color;
}

%state-disabled {
    opacity: 0.5;
    filter: grayscale(1);
}

%state-selected {
    background-color: $selected_bg_color;
    color: $selected_fg_color;
}

// Mixins para estados com cores específicas
@mixin hover-bg($color) {
    background-color: rgba($color, 0.08);
}

@mixin active-bg($color) {
    background-color: rgba($color, 0.16);
}

// Cantos arredondados
@mixin rounded($radius: $roundness) {
    border-radius: $radius;
}

// Sombras
@mixin shadow($shadow) {
    box-shadow: $shadow;
}

// Transições
@mixin transition($properties...) {
    transition: $properties 150ms cubic-bezier(0.4, 0, 0.2, 1);
}
EOF
    log_info "Criado: src/_sass/gtk/drawing-4.0.scss"

    # 4.2 common-4.0.scss (CORRIGIDO)
    cat > "src/_sass/gtk/common-4.0.scss" << 'EOF'
// common-4.0.scss - Componentes comuns GTK
// Baseado no Windows11-gtk-theme

/* ============================================================
   BASE
   ============================================================ */

* {
    font-family: $font-family;
}

.background {
    background-color: $bg_color;
    color: $text_color;
}

.background.csd {
    @include rounded(10px);
}

.background.maximized, .background.tiled {
    border-radius: 0;
}

/* ============================================================
   BOTÕES
   ============================================================ */

button {
    background-color: $view_color;
    color: $text_color;
    border: 1px solid $border_color;
    @include rounded($roundness);
    padding: 6px 14px;
    @include transition(all);
    font-weight: 500;
    min-height: 24px;
}

button:hover {
    background-color: $bg_color;
    border-color: rgba(0, 0, 0, 0.2);
}

button:active, button:checked {
    background-color: rgba(0, 0, 0, 0.1);
}

button.suggested-action {
    background-color: $primary;
    border-color: $primary;
    color: $selected_fg_color;
}

button.suggested-action:hover {
    background-color: $primary_bg_hover;
}

button.destructive-action {
    background-color: $danger;
    border-color: $danger;
    color: $selected_fg_color;
}

button.destructive-action:hover {
    background-color: shade($danger, 0.9);
}

button.success-action {
    background-color: $success;
    border-color: $success;
    color: $selected_fg_color;
}

button.success-action:hover {
    background-color: $success_bg_hover;
}

/* ============================================================
   ENTRADAS
   ============================================================ */

entry {
    background-color: $view_color;
    color: $text_color;
    border: 1px solid $border_color;
    @include rounded($roundness);
    padding: 6px 10px;
    min-height: 28px;
    @include transition(all);
}

entry:focus {
    border-color: $primary;
    box-shadow: 0 0 0 2px rgba($primary, 0.15);
}

entry:disabled {
    opacity: 0.6;
}

/* ============================================================
   CABEÇALHOS E BARRAS
   ============================================================ */

.header-bar, .titlebar, headerbar {
    background-color: $view_color;
    color: $text_color;
    padding: 8px 12px;
    border-bottom: 1px solid $border_color;
    @include shadow(0 1px 3px rgba(0,0,0,0.03));
}

.header-bar label, .titlebar label, headerbar label {
    font-weight: 500;
}

/* ============================================================
   MENUS
   ============================================================ */

menu, .menu, popover.background > contents {
    background-color: $view_color;
    border: 1px solid $border_color;
    @include rounded($roundness-ext);
    padding: 4px;
    @include shadow($shadow);
}

menu item, .menu item {
    padding: 6px 14px;
    @include rounded($roundness);
    @include transition(background);
}

menu item:hover, .menu item:selected {
    background-color: rgba($primary, 0.08);
    color: $primary;
}

/* ============================================================
   BARRAS DE ROLAGEM
   ============================================================ */

scrollbar slider {
    background-color: rgba($text_color, 0.2);
    @include rounded(10px);
    min-width: 6px;
    min-height: 6px;
}

scrollbar slider:hover {
    background-color: $primary;
}

scrollbar trough {
    background-color: transparent;
}

/* ============================================================
   ABAS
   ============================================================ */

notebook tab {
    padding: 8px 16px;
    background-color: transparent;
    border: none;
    color: $text_muted_color;
    font-weight: 500;
    border-bottom: 2px solid transparent;
}

notebook tab:hover {
    color: $text_color;
}

notebook tab:checked {
    color: $primary;
    border-bottom: 2px solid $primary;
}

notebook stack {
    background-color: $view_color;
    border: 1px solid $border_color;
    @include rounded(0 0 $roundness $roundness);
}

/* ============================================================
   PAINEL DO XFCE
   ============================================================ */

.xfce4-panel {
    background-color: $text_color;
    color: $view_color;
    @include shadow(0 2px 8px rgba(0,0,0,0.15));
}

.xfce4-panel button {
    background-color: transparent;
    border: none;
    color: $view_color;
    padding: 2px 8px;
    @include rounded($roundness);
}

.xfce4-panel button:hover {
    background-color: rgba($view_color, 0.08);
}

.xfce4-panel button:checked {
    background-color: rgba($view_color, 0.12);
}

/* ============================================================
   NOTIFICAÇÕES
   ============================================================ */

#XfceNotifyWindow {
    background-color: $text_color;
    @include rounded(12px);
    padding: 14px 18px;
    border: 1px solid $border_color;
    @include shadow(0 10px 30px rgba(0,0,0,0.2));
}

#XfceNotifyWindow label#summary {
    color: $view_color;
    font-weight: 600;
    font-size: 13.5px;
}

#XfceNotifyWindow label#body {
    color: $text_muted_color;
    font-size: 12px;
}

#XfceNotifyWindow button {
    background-color: $primary;
    border: none;
    color: $selected_fg_color;
    @include rounded($roundness);
    padding: 4px 12px;
}

#XfceNotifyWindow button:hover {
    background-color: $primary_bg_hover;
}

/* ============================================================
   LINKS
   ============================================================ */

link, .link-button {
    color: $link_color;
}

link:visited, .link-button:visited {
    color: $link_visited_color;
}

link:hover, .link-button:hover {
    color: $primary_bg_hover;
    text-decoration: underline;
}

/* ============================================================
   COMBOBOXES
   ============================================================ */

combobox arrow, dropdown arrow {
    -gtk-icon-source: -gtk-icontheme("pan-down-symbolic");
    min-height: 16px;
    min-width: 16px;
}

/* ============================================================
   SCROLLBARS (Overlay)
   ============================================================ */

scrollbar.overlay-indicator:not(.dragging):not(.hovering) {
    background-color: transparent;
}

scrollbar.overlay-indicator:not(.dragging):not(.hovering) > range > trough > slider {
    min-width: 4px;
    min-height: 4px;
    margin: 3px;
    border: 1px solid rgba($view_color, 0.3);
}

/* ============================================================
   DIM LABEL
   ============================================================ */

.dim-label, row.expander:not(:checked) image.expander-row-arrow, row label.subtitle {
    color: $text_muted_color;
}

/* ============================================================
   VIEWS E LISTAS
   ============================================================ */

.view, iconview, listview, list {
    background-color: $view_color;
    color: $text_color;
}

.view:selected, iconview:selected, row:selected {
    background-color: rgba($primary, 0.1);
    color: $text_color;
}

/* ============================================================
   EXPANDERS
   ============================================================ */

expander {
    min-width: 16px;
    min-height: 16px;
    color: $text_muted_color;
    -gtk-icon-source: -gtk-icontheme("pan-end-symbolic");
}

expander:checked {
    -gtk-icon-source: -gtk-icontheme("pan-down-symbolic");
}

expander:hover {
    color: $text_color;
}
EOF
    log_info "Criado: src/_sass/gtk/common-4.0.scss"

    # 4.3 apps-4.0.scss
    cat > "src/_sass/gtk/apps-4.0.scss" << 'EOF'
// apps-4.0.scss - Estilos específicos de aplicações
// Baseado no Windows11-gtk-theme

/* ============================================================
   NAUTILUS (Gerenciador de Arquivos)
   ============================================================ */

.nautilus-window {
    background-color: $bg_color;
}

.nautilus-window .sidebar-pane placessidebar {
    background-color: $bg_color;
}

.nautilus-window .sidebar-pane placessidebar:dir(ltr) {
    border-right: 1px solid $border_color;
}

.nautilus-window .sidebar-pane placessidebar:dir(rtl) {
    border-left: 1px solid $border_color;
}

.nautilus-grid-view child.activatable:selected {
    background-color: rgba($primary, 0.1);
}

.nautilus-list-view listview.view > row.activatable:selected {
    background-color: rgba($primary, 0.12);
}

/* ============================================================
   THUNAR (XFCE File Manager)
   ============================================================ */

.thunar .sidebar {
    background-color: $bg_color;
}

.thunar .sidebar row:selected {
    background-color: rgba($primary, 0.1);
    color: $primary;
}

/* ============================================================
   TERMINAL
   ============================================================ */

.terminal-window {
    background-color: $text_color;
}

.terminal-window .terminal-screen {
    color: $view_color;
}

/* ============================================================
   ABOUT DIALOG
   ============================================================ */

window.aboutdialog .large-icons {
    -gtk-icon-size: 128px;
}

/* ============================================================
   FILE CHOOSER
   ============================================================ */

filechooser #pathbarbox {
    border-bottom: 1px solid $border_color;
    background-color: $bg_color;
}

filechooser .dialog-action-box {
    border-top: 1px solid $border_color;
}

/* ============================================================
   INFOBAR
   ============================================================ */

infobar.info > revealer > box {
    background-color: $view_color;
    color: $text_color;
}

infobar.action > revealer > box {
    background-color: $primary;
    color: $selected_fg_color;
}

infobar.warning > revealer > box {
    background-color: $warning;
    color: $text_color;
}

infobar.error > revealer > box {
    background-color: $danger;
    color: $selected_fg_color;
}

/* ============================================================
   TOOLBAR
   ============================================================ */

.toolbar, toolbar {
    padding: 6px;
    background-color: $bg_color;
}

.toolbar.osd, toolbar.osd {
    background-color: rgba($text_color, 0.65);
    color: $view_color;
    @include rounded(10px);
}

/* ============================================================
   STACKSWITCHER
   ============================================================ */

stackswitcher {
    padding: 0 3px;
    @include rounded($roundness);
    background-color: rgba($text_color, 0.05);
}

stackswitcher.linked:not(.vertical) > button:not(.suggested-action):not(.destructive-action) {
    background-color: transparent;
    border: none;
    @include rounded(0);
}

stackswitcher.linked:not(.vertical) > button:not(.suggested-action):not(.destructive-action):hover {
    box-shadow: inset 0 -2px $border_color;
}

stackswitcher.linked:not(.vertical) > button:not(.suggested-action):not(.destructive-action):checked {
    color: $text_color;
    box-shadow: inset 0 -2px $primary;
}

/* ============================================================
   PROGRESSBAR
   ============================================================ */

progressbar > trough {
    background-color: rgba($text_color, 0.1);
    @include rounded($roundness);
}

progressbar > trough > progress {
    background-color: $primary;
    @include rounded($roundness);
}
EOF
    log_info "Criado: src/_sass/gtk/apps-4.0.scss"

    # 4.4 colors-public.scss
    cat > "src/_sass/gtk/colors-public.scss" << 'EOF'
// colors-public.scss - Cores públicas do GTK
// Baseado no Windows11-gtk-theme

// Estas cores são exportadas para uso geral
@define-color theme_fg_color $text_color;
@define-color theme_text_color $text_color;
@define-color theme_bg_color $bg_color;
@define-color theme_base_color $view_color;
@define-color theme_selected_bg_color $selected_bg_color;
@define-color theme_selected_fg_color $selected_fg_color;
@define-color insensitive_bg_color $bg_color;
@define-color insensitive_fg_color $text_muted_color;
@define-color insensitive_base_color rgba($view_color, 0.6);

// Backdrop
@define-color theme_unfocused_fg_color $text_color;
@define-color theme_unfocused_text_color $text_color;
@define-color theme_unfocused_bg_color $bg_color;
@define-color theme_unfocused_base_color $view_color;
@define-color theme_unfocused_selected_bg_color $selected_bg_color;
@define-color theme_unfocused_selected_fg_color $selected_fg_color;

// Bordas
@define-color borders $border_color;
@define-color unfocused_borders $border_color;

// Estado
@define-color warning_color $warning;
@define-color error_color $danger;
@define-color success_color $success;

// WM
@define-color wm_title $wm_title;
@define-color wm_unfocused_title $wm_unfocused_title;
@define-color wm_highlight $wm_highlight;
@define-color wm_bg $wm_bg;
@define-color wm_unfocused_bg $wm_unfocused_bg;
@define-color wm_button_close_hover_bg $wm_button_close_hover_bg;
@define-color wm_button_close_active_bg $wm_button_close_active_bg;

// Outros
@define-color content_view_bg $view_color;
@define-color placeholder_text_color $text_muted_color;
@define-color text_view_bg $view_color;
EOF
    log_info "Criado: src/_sass/gtk/colors-public.scss"

    # ============================================================
    # 5. TEMA DO XFWM4
    # ============================================================
    
    log_step "Criando tema do gerenciador de janelas"

    cat > "src/xfwm4/themerc" << 'EOF'
# Tema para o XFWM4 (Gerenciador de Janelas)
# Estilo: Windows 11 com cores IF

# Cores dos títulos
title_text_active=#1e222b
title_text_inactive=#6b7280

# Cores dos fundos dos títulos
title_bg_active=#ffffff
title_bg_inactive=#f8f9fa

# Cores das bordas
border_color_active=#005ea2
border_color_inactive=rgba(0,0,0,0.08)

# Dimensões
frame_border_top=10
title_vertical_offset_active=6
title_vertical_offset_inactive=6
button_offset=8
button_spacing=6

# Layout dos botões (O=Menu, H=Minimizar, M=Maximizar, C=Fechar)
# Estilo Windows 11 (botões à direita)
button_layout=O|HMC

# Sombras (estilo Windows 11)
shadow_delta_x=4
shadow_delta_y=4
shadow_radius=12
shadow_color=#000000
shadow_opacity=25
EOF
    log_info "Criado: src/xfwm4/themerc"

    # ============================================================
    # 6. NOTIFICAÇÕES XFCE
    # ============================================================
    
    log_step "Criando tema de notificações"

    cat > "src/xfce-notify-4.0/gtk.css" << 'EOF'
/* Tema de Notificações XFCE */
/* Estilo Windows 11 com cores IF */

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
    log_info "Criado: src/xfce-notify-4.0/gtk.css"

    # ============================================================
    # 7. SCRIPT DE COMPILAÇÃO (parse-sass.sh)
    # ============================================================
    
    log_step "Criando script de compilação"

    cat > "parse-sass.sh" << 'EOF'
#!/bin/bash
# parse-sass.sh - Compila os arquivos SCSS para CSS

set -e

log_info() { echo -e "\033[0;34m[INFO]\033[0m $1"; }
log_success() { echo -e "\033[0;32m[SUCCESS]\033[0m $1"; }
log_error() { echo -e "\033[0;31m[ERROR]\033[0m $1"; }

if ! command -v sassc &> /dev/null; then
    log_error "sassc não encontrado. Instale com: sudo apt install sassc"
    exit 1
fi

compile_profile() {
    local profile=$1
    log_info "Compilando perfil: ${profile}"
    
    if [ -f "src/gtk-3.0/gtk-${profile}.scss" ]; then
        sassc -M -t expanded "src/gtk-3.0/gtk-${profile}.scss" "src/gtk-3.0/gtk-${profile}.css"
        log_success "  → src/gtk-3.0/gtk-${profile}.css"
    else
        log_error "  → src/gtk-3.0/gtk-${profile}.scss não encontrado"
        return 1
    fi
    
    # GTK 4.0 (se existir, senão usa link simbólico)
    if [ -f "src/gtk-4.0/gtk-${profile}.scss" ]; then
        sassc -M -t expanded "src/gtk-4.0/gtk-${profile}.scss" "src/gtk-4.0/gtk-${profile}.css"
        log_success "  → src/gtk-4.0/gtk-${profile}.css"
    else
        mkdir -p src/gtk-4.0
        ln -sf ../gtk-3.0/gtk-${profile}.css src/gtk-4.0/gtk-${profile}.css
        log_info "  → src/gtk-4.0/gtk-${profile}.css (link simbólico)"
    fi
}

echo "🚀 Compilando temas IF..."
echo ""

compile_profile "admin"
compile_profile "academic"
compile_profile "community"

# Versão padrão (link para admin)
ln -sf gtk-admin.css src/gtk-3.0/gtk.css 2>/dev/null || true
ln -sf gtk-admin.css src/gtk-4.0/gtk.css 2>/dev/null || true

echo ""
log_success "✅ Compilação concluída!"
EOF
    chmod +x parse-sass.sh
    log_info "Criado: parse-sass.sh (executável)"

    # ============================================================
    # 8. SCRIPT DE INSTALAÇÃO (install.sh)
    # ============================================================
    
    log_step "Criando script de instalação"

    cat > "install.sh" << 'EOF'
#!/bin/bash
# install.sh - Instala os temas IF no sistema

set -e

DEST_DIR="/usr/share/themes"
THEME_NAME="IF-Theme"
PROFILES=("admin" "academic" "community")

show_help() {
    cat << HELP
Uso: ./install.sh [OPÇÕES]

Opções:
  -d, --dest DIR      Diretório de destino (padrão: /usr/share/themes)
  -n, --name NAME     Nome base do tema (padrão: IF-Theme)
  -p, --profile PROFILE Instalar apenas um perfil específico
  -h, --help          Mostra esta ajuda
HELP
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--dest) DEST_DIR="$2"; shift 2 ;;
        -n|--name) THEME_NAME="$2"; shift 2 ;;
        -p|--profile) PROFILES=("$2"); shift 2 ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "❌ Opção desconhecida: $1"; show_help; exit 1 ;;
    esac
done

if [[ $EUID -ne 0 ]] && [[ "$DEST_DIR" == "/usr/share/themes" ]]; then
    echo "⚠️  Instalação em /usr/share/themes requer privilégios de root."
    echo "   Execute: sudo $0"
    exit 1
fi

install_profile() {
    local profile=$1
    local theme_dir="${DEST_DIR}/${THEME_NAME}-${profile}"
    
    echo "📦 Instalando: ${profile} em ${theme_dir}"
    
    mkdir -p "${theme_dir}"/{gtk-3.0,gtk-4.0,xfwm4,xfce-notify-4.0}
    
    # Copia CSS
    if [ -f "src/gtk-3.0/gtk-${profile}.css" ]; then
        cp "src/gtk-3.0/gtk-${profile}.css" "${theme_dir}/gtk-3.0/gtk.css"
    fi
    
    if [ -f "src/gtk-4.0/gtk-${profile}.css" ]; then
        cp "src/gtk-4.0/gtk-${profile}.css" "${theme_dir}/gtk-4.0/gtk.css"
    else
        ln -sf ../gtk-3.0/gtk.css "${theme_dir}/gtk-4.0/gtk.css"
    fi
    
    # Copia xfwm4
    if [ -f "src/xfwm4/themerc" ]; then
        cp "src/xfwm4/themerc" "${theme_dir}/xfwm4/themerc"
    fi
    
    # Copia notificações
    if [ -f "src/xfce-notify-4.0/gtk.css" ]; then
        cp "src/xfce-notify-4.0/gtk.css" "${theme_dir}/xfce-notify-4.0/gtk.css"
    fi
    
    # Cria index.theme
    cat > "${theme_dir}/index.theme" << INDEX
[Desktop Entry]
Type=X-GNOME-Metatheme
Name=${THEME_NAME} ${profile}
Comment=Tema IF - Perfil ${profile}
Encoding=UTF-8

[X-GNOME-Metatheme]
GtkTheme=${THEME_NAME}-${profile}
MetacityTheme=${THEME_NAME}-${profile}
IconTheme=Papirus
CursorTheme=Adwaita
FontName=Rawline, Noto Sans 10
INDEX
    
    chmod -R 755 "${theme_dir}"
    chown -R root:root "${theme_dir}" 2>/dev/null || true
    
    echo "✅ ${profile} instalado!"
}

echo "🚀 Instalando temas IF..."
echo ""

for profile in "${PROFILES[@]}"; do
    install_profile "$profile"
done

echo ""
echo "🎉 Instalação concluída!"
echo ""
echo "📝 Para aplicar:"
echo "   xfconf-query -c xfce4-desktop -p /gtk-theme -s \"${THEME_NAME}-admin\""
echo "   xfconf-query -c xfwm4 -p /general/theme -s \"${THEME_NAME}-admin\""
EOF
    chmod +x install.sh
    log_info "Criado: install.sh (executável)"

    # ============================================================
    # 9. SCRIPT DE CONSTRUÇÃO E INSTALAÇÃO UNIFICADO
    # ============================================================
    
    log_step "Criando script unificado"

    cat > "build.sh" << 'EOF'
#!/bin/bash
# build.sh - Compila e instala o tema

echo "╔═══════════════════════════════════════════════════════════╗"
echo "║                                                           ║"
echo "║     🏛️  IF-XFCE-THEME - CONSTRUTOR UNIFICADO             ║"
echo "║                                                           ║"
echo "║     Identidade IF + Gov.br                               ║"
echo "║                                                           ║"
echo "╚═══════════════════════════════════════════════════════════╝"
echo ""

# Verifica sassc
if ! command -v sassc &> /dev/null; then
    echo "📦 Instalando sassc..."
    sudo apt update -qq && sudo apt install -y sassc -qq
fi

# Compila
echo "📦 Compilando temas..."
./parse-sass.sh

# Instala
echo ""
if [[ $EUID -ne 0 ]]; then
    read -p "Instalar em /usr/share/themes requer sudo. Continuar? (s/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        sudo ./install.sh "$@"
    else
        echo "ℹ️  Instalação cancelada. Temas compilados em src/gtk-3.0/"
    fi
else
    ./install.sh "$@"
fi

echo ""
echo "🎉 Processo concluído!"
EOF
    chmod +x build.sh
    log_info "Criado: build.sh (executável)"

    # ============================================================
    # 10. COMPILAÇÃO
    # ============================================================
    
    log_step "Compilando os temas"
    ./parse-sass.sh

    # ============================================================
    # 11. RESUMO FINAL
    # ============================================================
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  ✅ TEMA IF-XFCE CONSTRUÍDO COM SUCESSO!                         ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  📁 Localização: $(pwd)${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  📦 Para instalar:                                               ║${NC}"
    echo -e "${GREEN}║     sudo ./install.sh                                            ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  📝 Ou com opções:                                               ║${NC}"
    echo -e "${GREEN}║     ./install.sh --profile admin                                 ║${NC}"
    echo -e "${GREEN}║     ./install.sh --dest ~/.themes                                ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    # Pergunta se deseja instalar
    if [ -t 0 ]; then
        read -p "Deseja instalar o tema agora? (s/N) " -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            if [[ $EUID -ne 0 ]]; then
                echo "⚠️  Instalação requer privilégios de root. Execute:"
                echo "   cd $(pwd) && sudo ./install.sh"
            else
                ./install.sh
            fi
        else
            echo "ℹ️  Para instalar depois: cd $(pwd) && sudo ./install.sh"
        fi
    fi
}

# --- Executa ---
main "$@"
