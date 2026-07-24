#!/bin/bash
# if-firefox-fix.sh - Corrige a integração do Firefox com o tema IF-XFCE
# Versão: 1.0
# Descrição: Aplica correções visuais para o Firefox funcionar com o tema IF
# Uso: curl -fsSL https://seu-servidor/if-firefox-fix.sh | bash

set -e

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

# --- Verifica se o Firefox está instalado ---
check_firefox() {
    if ! command -v firefox &> /dev/null; then
        log_error "Firefox não encontrado. Instale com: sudo apt install firefox-esr"
        exit 1
    fi
    log_success "Firefox encontrado!"
}

# --- Detecta o perfil do Firefox ---
find_firefox_profile() {
    local profile_dir
    
    # Tenta encontrar o perfil padrão
    if [ -d "$HOME/.mozilla/firefox" ]; then
        # Pega o primeiro perfil com extensão .default
        profile_dir=$(find "$HOME/.mozilla/firefox" -maxdepth 1 -type d -name "*.default*" 2>/dev/null | head -1)
        if [ -n "$profile_dir" ] && [ -d "$profile_dir" ]; then
            echo "$profile_dir"
            return 0
        fi
    fi
    
    log_warn "Perfil do Firefox não encontrado. Criando diretório padrão..."
    mkdir -p "$HOME/.mozilla/firefox/default"
    echo "$HOME/.mozilla/firefox/default"
    return 0
}

# --- Cria o arquivo userChrome.css ---
create_user_chrome() {
    local profile_dir="$1"
    local theme_type="${2:-admin}"
    local chrome_dir="$profile_dir/chrome"
    
    mkdir -p "$chrome_dir"
    
    log_info "Criando userChrome.css para o perfil: $profile_dir"
    
    # Define cores baseadas no perfil
    local bg_color="#f8f9fa"
    local text_color="#1e222b"
    local url_bg="#ffffff"
    local primary_color="#005ea2"
    local primary_hover="#0072c3"
    local border_color="rgba(0,0,0,0.08)"
    
    case "$theme_type" in
        academic)
            bg_color="#1a1a1a"
            text_color="#ffffff"
            url_bg="#2d2d2d"
            primary_color="#cd191e"
            primary_hover="#e0191e"
            border_color="rgba(255,255,255,0.08)"
            ;;
        community)
            bg_color="#f0f2f5"
            text_color="#1e222b"
            url_bg="#ffffff"
            primary_color="#005ea2"
            primary_hover="#0072c3"
            border_color="rgba(0,0,0,0.08)"
            ;;
        admin|*)
            bg_color="#f8f9fa"
            text_color="#1e222b"
            url_bg="#ffffff"
            primary_color="#005ea2"
            primary_hover="#0072c3"
            border_color="rgba(0,0,0,0.08)"
            ;;
    esac
    
    cat > "$chrome_dir/userChrome.css" << EOF
/* ============================================================
   userChrome.css - Firefox integrado ao tema IF-XFCE
   Perfil: ${theme_type}
   ============================================================ */

/* ---------- BARRA DE FERRAMENTAS PRINCIPAL ---------- */
#navigator-toolbox {
    background-color: ${bg_color} !important;
    border-bottom: 1px solid ${border_color} !important;
}

/* ---------- BARRA DE MENUS ---------- */
#toolbar-menubar {
    background-color: ${bg_color} !important;
    color: ${text_color} !important;
}

#toolbar-menubar menubar {
    background-color: ${bg_color} !important;
    color: ${text_color} !important;
}

#toolbar-menubar menubar menuitem:hover {
    background-color: rgba(0, 0, 0, 0.08) !important;
    color: ${text_color} !important;
}

/* ---------- BARRA DE ABAS ---------- */
#TabsToolbar {
    background-color: ${bg_color} !important;
    color: ${text_color} !important;
}

.tabbrowser-tab {
    background-color: transparent !important;
    color: ${text_color} !important;
}

.tabbrowser-tab:hover {
    background-color: rgba(0, 0, 0, 0.05) !important;
}

.tabbrowser-tab[selected="true"] {
    background-color: ${url_bg} !important;
    color: ${text_color} !important;
}

.tabbrowser-tab .tab-label {
    color: ${text_color} !important;
}

/* ---------- BARRA DE ENDEREÇOS ---------- */
#urlbar,
#urlbar-background {
    background-color: ${url_bg} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 6px !important;
    color: ${text_color} !important;
}

#urlbar[focused="true"] > #urlbar-background,
#searchbar:focus-within {
    outline: none !important;
    border-color: ${primary_color} !important;
    box-shadow: 0 0 0 2px rgba($(echo ${primary_color} | sed 's/#//'), 0.3) !important;
}

#urlbar .urlbar-input-box {
    color: ${text_color} !important;
}

#urlbar .urlbar-input-box input {
    color: ${text_color} !important;
}

/* ---------- BARRA DE FERRAMENTAS ---------- */
#nav-bar {
    background-color: ${bg_color} !important;
    color: ${text_color} !important;
}

#nav-bar toolbaritem {
    background-color: transparent !important;
}

/* ---------- BOTÕES DA BARRA DE FERRAMENTAS ---------- */
.toolbarbutton-1 {
    background-color: transparent !important;
    border: none !important;
    color: ${text_color} !important;
    border-radius: 4px !important;
    padding: 4px 6px !important;
}

.toolbarbutton-1:hover {
    background-color: rgba(0, 0, 0, 0.08) !important;
}

.toolbarbutton-1[checked="true"] {
    background-color: rgba($(echo ${primary_color} | sed 's/#//'), 0.15) !important;
}

/* ---------- MENUS ---------- */
menupopup {
    background-color: ${url_bg} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 6px !important;
    box-shadow: 0 4px 12px rgba(0, 0, 0, 0.15) !important;
}

menupopup menuitem {
    color: ${text_color} !important;
    padding: 4px 12px !important;
}

menupopup menuitem:hover {
    background-color: rgba($(echo ${primary_color} | sed 's/#//'), 0.08) !important;
    color: ${primary_color} !important;
}

/* ---------- BARRAS DE ROLAGEM ---------- */
scrollbar {
    background-color: ${bg_color} !important;
}

scrollbar thumb {
    background-color: rgba(0, 0, 0, 0.2) !important;
    border-radius: 6px !important;
}

scrollbar thumb:hover {
    background-color: ${primary_color} !important;
}

/* ---------- CAMPOS DE ENTRADA ---------- */
input, textarea {
    background-color: ${url_bg} !important;
    color: ${text_color} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 4px !important;
}

input:focus, textarea:focus {
    border-color: ${primary_color} !important;
    box-shadow: 0 0 0 2px rgba($(echo ${primary_color} | sed 's/#//'), 0.15) !important;
}

/* ---------- SELECT E DROPDOWN ---------- */
select {
    background-color: ${url_bg} !important;
    color: ${text_color} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 4px !important;
}

/* ---------- BARRA DE STATUS ---------- */
#status-bar {
    background-color: ${bg_color} !important;
    color: ${text_muted_color} !important;
}

/* ---------- POPUPS E MODAIS ---------- */
.popup-notification-panel {
    background-color: ${url_bg} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 8px !important;
    box-shadow: 0 4px 16px rgba(0, 0, 0, 0.15) !important;
}

.popup-notification-panel .popup-notification-body {
    color: ${text_color} !important;
}

.popup-notification-panel .popup-notification-button {
    border-radius: 4px !important;
    padding: 6px 14px !important;
}

.popup-notification-panel .popup-notification-button:hover {
    background-color: rgba(0, 0, 0, 0.05) !important;
}

.popup-notification-panel .popup-notification-button.primary {
    background-color: ${primary_color} !important;
    color: #ffffff !important;
}

.popup-notification-panel .popup-notification-button.primary:hover {
    background-color: ${primary_hover} !important;
}

/* ---------- FIND BAR (CTRL+F) ---------- */
#findbar {
    background-color: ${bg_color} !important;
    border-top: 1px solid ${border_color} !important;
    color: ${text_color} !important;
}

#findbar input {
    background-color: ${url_bg} !important;
    color: ${text_color} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 4px !important;
}

/* ---------- ABAS DE CONFIGURAÇÃO ---------- */
.tabpanel {
    background-color: ${url_bg} !important;
    color: ${text_color} !important;
}

/* ---------- NOTIFICAÇÕES ---------- */
.notificationbox {
    background-color: ${bg_color} !important;
    color: ${text_color} !important;
}

.notificationbox .notification {
    background-color: ${url_bg} !important;
    border: 1px solid ${border_color} !important;
    border-radius: 4px !important;
}

/* ---------- CORREÇÃO PARA TEMA ACADÊMICO (DARK) ---------- */
$([ "$theme_type" = "academic" ] && cat << 'DARK'
/* Força fundo escuro em elementos quebrados */
#main-window {
    background-color: #1a1a1a !important;
}

/* Corrige texto em campos de entrada */
input[type="text"], input[type="password"], textarea {
    background-color: #2d2d2d !important;
    color: #ffffff !important;
}

/* Corrige fundo de selects e dropdowns */
select option {
    background-color: #2d2d2d !important;
    color: #ffffff !important;
}

/* Corrige popups de autocomplete */
.autocomplete-richlistbox {
    background-color: #2d2d2d !important;
    color: #ffffff !important;
}
DARK
)
EOF
    
    log_success "userChrome.css criado para o perfil ${theme_type}"
}

# --- Cria o arquivo policies.json para configurações do about:config ---
create_policies() {
    local firefox_dir="/usr/lib/firefox"
    local policies_dir="$firefox_dir/distribution"
    
    if [ ! -d "$policies_dir" ]; then
        sudo mkdir -p "$policies_dir"
    fi
    
    log_info "Criando policies.json para configurações persistentes..."
    
    sudo cat > "$policies_dir/policies.json" << 'EOF'
{
  "policies": {
    "Preferences": {
      "widget.gtk.non-native-titlebar-buttons.enabled": {
        "Value": false,
        "Status": "locked"
      },
      "toolkit.legacyUserProfileCustomizations.stylesheets": {
        "Value": true,
        "Status": "locked"
      },
      "widget.content.gtk-theme-override": {
        "Value": "Adwaita:light",
        "Status": "default"
      },
      "ui.systemUsesDarkTheme": {
        "Value": 0,
        "Status": "default"
      }
    }
  }
}
EOF
    
    log_success "policies.json criado em $policies_dir"
}

# --- Cria um script de inicialização para o Firefox ---
create_launcher() {
    local launcher_path="/usr/local/bin/firefox-if"
    
    log_info "Criando launcher personalizado para o Firefox..."
    
    sudo cat > "$launcher_path" << 'EOF'
#!/bin/bash
# Firefox com tema IF-XFCE

# Detecta o tema atual do XFCE
CURRENT_THEME=$(xfconf-query -c xfce4-desktop -p /gtk-theme 2>/dev/null || echo "IF-Theme-admin")

# Define o override baseado no tema
case "$CURRENT_THEME" in
    *academic*)
        export GTK_THEME=IF-Theme-academic
        ;;
    *community*)
        export GTK_THEME=IF-Theme-community
        ;;
    *)
        export GTK_THEME=IF-Theme-admin
        ;;
esac

# Executa o Firefox com o tema correto
exec /usr/bin/firefox "$@"
EOF
    
    sudo chmod +x "$launcher_path"
    log_success "Launcher criado em $launcher_path"
    
    # Cria um atalho no menu de aplicativos
    if [ -d "/usr/share/applications" ]; then
        sudo cat > "/usr/share/applications/firefox-if.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Name=Firefox IF
Comment=Navegador Firefox com tema IF
Exec=/usr/local/bin/firefox-if %u
Icon=firefox
Terminal=false
Type=Application
Categories=Network;WebBrowser;
MimeType=text/html;text/xml;application/xhtml+xml;application/xml;application/vnd.mozilla.xul+xml;application/rss+xml;application/rdf+xml;image/gif;image/jpeg;image/png;x-scheme-handler/http;x-scheme-handler/https;
StartupNotify=true
EOF
        log_success "Atalho criado em /usr/share/applications/firefox-if.desktop"
    fi
}

# --- Aplica as correções para todos os usuários ---
apply_for_all_users() {
    local theme_type="${1:-admin}"
    local users=$(ls /home 2>/dev/null)
    
    log_step "Aplicando correções para todos os usuários..."
    
    for user in $users; do
        local user_home="/home/$user"
        if [ -d "$user_home" ]; then
            log_info "Processando usuário: $user"
            
            # Encontra o perfil do Firefox
            local profile_dir=$(find "$user_home/.mozilla/firefox" -maxdepth 1 -type d -name "*.default*" 2>/dev/null | head -1)
            if [ -n "$profile_dir" ]; then
                create_user_chrome "$profile_dir" "$theme_type"
                # Ajusta permissões
                chown -R "$user:$user" "$profile_dir/chrome" 2>/dev/null || true
            fi
        fi
    done
}

# --- Detecta o tema atual para aplicar o perfil correto ---
detect_current_theme() {
    local current_theme=$(xfconf-query -c xfce4-desktop -p /gtk-theme 2>/dev/null || echo "IF-Theme-admin")
    
    case "$current_theme" in
        *academic*) echo "academic" ;;
        *community*) echo "community" ;;
        *) echo "admin" ;;
    esac
}

# --- Função principal ---
main() {
    clear
    echo -e "${CYAN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${CYAN}║                                                                  ║${NC}"
    echo -e "${CYAN}║     🦊 CORRETOR DO FIREFOX PARA O TEMA IF-XFCE                  ║${NC}"
    echo -e "${CYAN}║                                                                  ║${NC}"
    echo -e "${CYAN}║     Integração perfeita entre Firefox e o tema IF                ║${NC}"
    echo -e "${CYAN}║                                                                  ║${NC}"
    echo -e "${CYAN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    log_step "Verificando dependências"
    
    # Verifica se o Firefox está instalado
    if ! command -v firefox &> /dev/null; then
        log_warn "Firefox não encontrado. Deseja instalar? (s/N)"
        read -n 1 -r
        echo ""
        if [[ $REPLY =~ ^[Ss]$ ]]; then
            if command -v apt &> /dev/null; then
                sudo apt update -qq && sudo apt install -y firefox-esr -qq
                log_success "Firefox instalado!"
            else
                log_error "APT não disponível. Instale o Firefox manualmente."
                exit 1
            fi
        else
            log_error "Firefox é necessário para esta correção."
            exit 1
        fi
    fi
    log_success "Firefox encontrado!"

    # Detecta o tema atual
    CURRENT_THEME=$(detect_current_theme)
    log_info "Tema atual detectado: $CURRENT_THEME"

    # 1. Cria o policies.json (para todos os usuários)
    log_step "Configurando políticas do Firefox"
    create_policies

    # 2. Cria o launcher personalizado
    log_step "Criando launcher personalizado"
    create_launcher

    # 3. Aplica para o usuário atual
    log_step "Aplicando correções para o usuário atual"
    PROFILE_DIR=$(find_firefox_profile)
    create_user_chrome "$PROFILE_DIR" "$CURRENT_THEME"

    # 4. Pergunta se deseja aplicar para todos os usuários
    echo ""
    read -p "Deseja aplicar as correções para todos os usuários do sistema? (s/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        apply_for_all_users "$CURRENT_THEME"
    else
        log_info "Aplicando apenas para o usuário atual."
    fi

    # 5. Configuração manual para o usuário atual
    log_step "Configurando preferências do Firefox"
    
    # Cria um arquivo de configuração com as preferências recomendadas
    local prefs_file="$PROFILE_DIR/user.js"
    if [ -n "$PROFILE_DIR" ] && [ -d "$PROFILE_DIR" ]; then
        cat > "$prefs_file" << 'EOF'
// Preferências do Firefox para integração com o tema IF
user_pref("widget.gtk.non-native-titlebar-buttons.enabled", false);
user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);
user_pref("widget.content.gtk-theme-override", "Adwaita:light");
EOF
        log_success "Arquivo de preferências criado: $prefs_file"
    fi

    # ============================================================
    # 5. RESUMO FINAL
    # ============================================================
    
    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  ✅ CORREÇÕES APLICADAS COM SUCESSO!                            ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  📁 Launcher criado em: /usr/local/bin/firefox-if               ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  📝 Para usar o Firefox com o tema IF:                          ║${NC}"
    echo -e "${GREEN}║     firefox-if                                                  ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  🖥️  Ou através do menu:                                        ║${NC}"
    echo -e "${GREEN}║     Firefox IF (atalho adicionado ao menu)                      ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}║  ⚠️  Reinicie o Firefox para ver as mudanças                    ║${NC}"
    echo -e "${GREEN}║                                                                  ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════╝${NC}"
    echo ""

    # Pergunta se deseja abrir o Firefox agora
    read -p "Deseja abrir o Firefox agora para verificar? (s/N) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Ss]$ ]]; then
        firefox-if &
    else
        log_info "Para abrir o Firefox com o tema IF: firefox-if"
    fi
}

# --- Executa ---
main "$@"
