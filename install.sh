#!/usr/bin/env bash

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

print_header() {
    echo -e "${CYAN}"
    echo "╔══════════════════════════════════════════════════════════════════════════════╗"
    echo "║                           DOTFILES INSTALLER                                 ║"
    echo "╚══════════════════════════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_step() {
    echo -e "${GREEN}▶ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# DETECT OS & PACKAGE MANAGER
detect_os() {
    if [[ "$OSTYPE" == "darwin"* ]]; then
        OS="macos"
        PKG_MANAGER="brew"
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        OS="linux"
        # Detect package manager
        if command -v apt &>/dev/null; then
            PKG_MANAGER="apt"
            DISTRO="debian"
        elif command -v dnf &>/dev/null; then
            PKG_MANAGER="dnf"
            DISTRO="fedora"
        elif command -v pacman &>/dev/null; then
            PKG_MANAGER="pacman"
            DISTRO="arch"
        else
            print_error "Unsupported Linux distribution"
            exit 1
        fi
    else
        print_error "Unsupported OS: $OSTYPE"
        exit 1
    fi
    print_step "Detected OS: $OS ($PKG_MANAGER)"
}

# INSTALL HOMEBREW (macOS) or HOMEBREW ON LINUX
install_homebrew() {
    if ! command -v brew &>/dev/null; then
        print_step "Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        # Add to PATH for Linux
        if [[ "$OS" == "linux" ]]; then
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.bashrc
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
        fi
    else
        print_success "Homebrew already installed"
    fi
}

# INSTALL PACKAGES - macOS
install_packages_macos() {
    print_step "Installing packages via Homebrew..."

    # Core tools
    brew install git neovim tmux starship zoxide atuin fzf bat eza fd ripgrep jq yq stow

    # Shell
    brew install zsh-autosuggestions zsh-syntax-highlighting

    # DevOps tools
    brew install kubectl helm k9s kubectx stern kustomize terraform

    # Git tools
    brew install git-delta gh lazygit

    # System monitoring
    brew install btop fastfetch

    # GUI apps (macOS only)
    brew install --cask ghostty karabiner-elements
    brew install nikitabobko/tap/aerospace

    # Fonts
    brew install --cask font-jetbrains-mono-nerd-font

    print_success "macOS packages installed"
}

# INSTALL PACKAGES - Ubuntu/Debian
install_packages_debian() {
    print_step "Installing packages via apt..."

    sudo apt update
    sudo apt install -y \
        git curl wget unzip \
        zsh stow fzf bat fd-find ripgrep jq \
        tmux btop

    # Install Neovim (latest)
    print_step "Installing Neovim..."
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux64.tar.gz
    sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/nvim
    rm nvim-linux64.tar.gz

    # Install Starship
    print_step "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    # Install zoxide
    print_step "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    # Install atuin
    print_step "Installing atuin..."
    curl -sSfL https://setup.atuin.sh | bash

    # Install eza (modern ls)
    print_step "Installing eza..."
    sudo mkdir -p /etc/apt/keyrings
    wget -qO- https://raw.githubusercontent.com/eza-community/eza/main/deb.asc | sudo gpg --dearmor -o /etc/apt/keyrings/gierens.gpg
    echo "deb [signed-by=/etc/apt/keyrings/gierens.gpg] http://deb.gierens.de stable main" | sudo tee /etc/apt/sources.list.d/gierens.list
    sudo apt update
    sudo apt install -y eza

    # Install yq
    print_step "Installing yq..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq

    # Install delta (git diff)
    print_step "Installing delta..."
    DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d '"' -f 4)
    wget -q "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta_${DELTA_VERSION}_amd64.deb"
    sudo dpkg -i "git-delta_${DELTA_VERSION}_amd64.deb"
    rm "git-delta_${DELTA_VERSION}_amd64.deb"

    # Install lazygit
    print_step "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep tag_name | cut -d '"' -f 4 | tr -d 'v')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit lazygit.tar.gz

    # Install DevOps tools
    install_devops_tools_linux

    # Install Nerd Font
    install_nerd_font_linux

    # Zsh plugins
    print_step "Installing zsh plugins..."
    sudo apt install -y zsh-autosuggestions zsh-syntax-highlighting 2>/dev/null || {
        git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
        git clone https://github.com/zsh-users/zsh-syntax-highlighting ~/.zsh/zsh-syntax-highlighting
    }

    print_success "Debian/Ubuntu packages installed"
}

# INSTALL PACKAGES - Fedora/RHEL
install_packages_fedora() {
    print_step "Installing packages via dnf..."

    sudo dnf install -y \
        git curl wget unzip \
        zsh stow fzf bat fd-find ripgrep jq \
        tmux neovim btop \
        zsh-autosuggestions zsh-syntax-highlighting

    # Install Starship
    print_step "Installing Starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y

    # Install zoxide
    print_step "Installing zoxide..."
    curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

    # Install atuin
    print_step "Installing atuin..."
    curl -sSfL https://setup.atuin.sh | bash

    # Install eza
    print_step "Installing eza..."
    sudo dnf install -y eza 2>/dev/null || cargo install eza

    # Install yq
    print_step "Installing yq..."
    sudo wget -qO /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
    sudo chmod +x /usr/local/bin/yq

    # Install delta
    print_step "Installing delta..."
    sudo dnf install -y git-delta 2>/dev/null || {
        DELTA_VERSION=$(curl -s https://api.github.com/repos/dandavison/delta/releases/latest | grep tag_name | cut -d '"' -f 4)
        sudo dnf install -y "https://github.com/dandavison/delta/releases/download/${DELTA_VERSION}/git-delta-${DELTA_VERSION}-x86_64.rpm"
    }

    # Install lazygit
    print_step "Installing lazygit..."
    sudo dnf copr enable atim/lazygit -y
    sudo dnf install -y lazygit

    # Install DevOps tools
    install_devops_tools_linux

    # Install Nerd Font
    install_nerd_font_linux

    print_success "Fedora packages installed"
}

# INSTALL DEVOPS TOOLS (Linux)
install_devops_tools_linux() {
    print_step "Installing DevOps tools..."

    # kubectl
    if ! command -v kubectl &>/dev/null; then
        curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
        sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl
        rm kubectl
    fi

    # helm
    if ! command -v helm &>/dev/null; then
        curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash
    fi

    # k9s
    if ! command -v k9s &>/dev/null; then
        K9S_VERSION=$(curl -s https://api.github.com/repos/derailed/k9s/releases/latest | grep tag_name | cut -d '"' -f 4)
        curl -Lo k9s.tar.gz "https://github.com/derailed/k9s/releases/download/${K9S_VERSION}/k9s_Linux_amd64.tar.gz"
        tar xf k9s.tar.gz k9s
        sudo install k9s /usr/local/bin
        rm k9s k9s.tar.gz
    fi

    # kubectx & kubens
    if ! command -v kubectx &>/dev/null; then
        sudo git clone https://github.com/ahmetb/kubectx /opt/kubectx
        sudo ln -sf /opt/kubectx/kubectx /usr/local/bin/kubectx
        sudo ln -sf /opt/kubectx/kubens /usr/local/bin/kubens
    fi

    # terraform
    if ! command -v terraform &>/dev/null; then
        curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null || true
        wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg 2>/dev/null || true

        # Try apt first, then dnf
        if command -v apt &>/dev/null; then
            echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
            sudo apt update && sudo apt install -y terraform
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y dnf-plugins-core
            sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo
            sudo dnf install -y terraform
        fi
    fi

    # stern (log tailing)
    if ! command -v stern &>/dev/null; then
        STERN_VERSION=$(curl -s https://api.github.com/repos/stern/stern/releases/latest | grep tag_name | cut -d '"' -f 4)
        curl -Lo stern.tar.gz "https://github.com/stern/stern/releases/download/${STERN_VERSION}/stern_${STERN_VERSION#v}_linux_amd64.tar.gz"
        tar xf stern.tar.gz stern
        sudo install stern /usr/local/bin
        rm stern stern.tar.gz
    fi

    # kustomize
    if ! command -v kustomize &>/dev/null; then
        curl -s "https://raw.githubusercontent.com/kubernetes-sigs/kustomize/master/hack/install_kustomize.sh" | bash
        sudo mv kustomize /usr/local/bin/
    fi

    print_success "DevOps tools installed"
}

# INSTALL NERD FONT (Linux)
install_nerd_font_linux() {
    print_step "Installing JetBrains Mono Nerd Font..."

    FONT_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONT_DIR"

    curl -Lo JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
    unzip -o JetBrainsMono.zip -d "$FONT_DIR"
    rm JetBrainsMono.zip

    fc-cache -fv
    print_success "Nerd Font installed"
}

# INSTALL PACKAGES (Router)
install_packages() {
    if [[ "$OS" == "macos" ]]; then
        install_homebrew
        install_packages_macos
    elif [[ "$OS" == "linux" ]]; then
        if [[ "$DISTRO" == "debian" ]]; then
            install_packages_debian
        elif [[ "$DISTRO" == "fedora" ]]; then
            install_packages_fedora
        elif [[ "$DISTRO" == "arch" ]]; then
            print_warning "Arch Linux: Please install packages via pacman manually"
            print_warning "Required: git neovim tmux starship zoxide atuin fzf bat eza fd ripgrep jq yq stow"
        fi
    fi
}

# BACKUP EXISTING CONFIGS
backup_configs() {
    print_step "Backing up existing configs..."

    BACKUP_DIR="$HOME/.config-backup-$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    configs=(
        "$HOME/.zshrc"
        "$HOME/.gitconfig"
        "$HOME/.config/nvim"
        "$HOME/.config/tmux"
        "$HOME/.config/starship"
        "$HOME/.config/ghostty"
        "$HOME/.config/atuin"
        "$HOME/.config/fastfetch"
        "$HOME/.config/mise"
    )

    # macOS specific
    if [[ "$OS" == "macos" ]]; then
        configs+=(
            "$HOME/.config/aerospace"
            "$HOME/.config/karabiner"
            "$HOME/.config/sketchybar"
        )
    fi

    for config in "${configs[@]}"; do
        if [[ -e "$config" ]]; then
            cp -r "$config" "$BACKUP_DIR/" 2>/dev/null || true
            print_success "Backed up: $config"
        fi
    done

    print_success "Backups saved to: $BACKUP_DIR"
}

# INSTALL DOTFILES
install_dotfiles() {
    print_step "Installing dotfiles with GNU Stow..."

    cd "$HOME/dotfiles"

    # Core packages (both macOS & Linux)
    packages=(
        "zshrc"
        "git"
        "nvim"
        "tmux"
        "starship"
        "atuin"
        "fastfetch"
        "mise"
        "scripts"
    )

    # macOS specific packages
    if [[ "$OS" == "macos" ]]; then
        packages+=(
            "ghostty"
            "aerospace"
            "karabiner"
            "sketchybar"
        )
    fi

    for pkg in "${packages[@]}"; do
        if [[ -d "$pkg" ]]; then
            stow -v --restow "$pkg" 2>/dev/null || true
            print_success "Stowed: $pkg"
        fi
    done
}

# INSTALL TMUX PLUGINS
install_tmux_plugins() {
    print_step "Installing tmux plugins..."

    TPM_DIR="$HOME/.tmux/plugins/tpm"
    if [[ ! -d "$TPM_DIR" ]]; then
        git clone https://github.com/tmux-plugins/tpm "$TPM_DIR"
    fi

    # Install plugins
    "$TPM_DIR/bin/install_plugins" || true
    print_success "Tmux plugins installed"
}

# SET ZSH AS DEFAULT SHELL
set_zsh_default() {
    if [[ "$SHELL" != *"zsh"* ]]; then
        print_step "Setting zsh as default shell..."
        chsh -s "$(which zsh)" || print_warning "Could not change shell. Run: chsh -s \$(which zsh)"
    fi
}

# POST INSTALL
post_install() {
    print_step "Running post-install tasks..."

    # Make scripts executable
    chmod +x "$HOME/.local/bin/"* 2>/dev/null || true

    # Create .config directory if needed
    mkdir -p "$HOME/.config"

    # Add ~/.local/bin to PATH if not already
    if ! grep -q '.local/bin' "$HOME/.zshrc" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
    fi

    # Set zsh as default
    set_zsh_default

    print_success "Post-install complete"
}

# MAIN
main() {
    print_header

    echo "This script will:"
    echo "  1. Detect your OS (macOS/Linux)"
    echo "  2. Install Homebrew (macOS) or native packages (Linux)"
    echo "  3. Install required tools (neovim, tmux, kubectl, terraform...)"
    echo "  4. Backup existing configs"
    echo "  5. Symlink dotfiles with Stow"
    echo "  6. Install tmux plugins"
    echo "  7. Set zsh as default shell"
    echo ""

    read -p "Continue? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi

    detect_os
    install_packages
    backup_configs
    install_dotfiles
    install_tmux_plugins
    post_install

    echo ""
    echo -e "${GREEN}╔══════════════════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║                         INSTALLATION COMPLETE!                               ║${NC}"
    echo -e "${GREEN}╚══════════════════════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo "Next steps:"
    echo "  1. Restart your terminal or run: source ~/.zshrc"
    echo "  2. Open nvim to install plugins: nvim"
    echo "  3. In tmux, press Ctrl+A then I to install tmux plugins"
    echo ""
    echo "Done."
}

main "$@"
