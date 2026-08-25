# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time Oh My Zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME=robbyrussell

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git kube-ps1)

source $ZSH/oh-my-zsh.sh

# Display kube-ps1 plugin on the right side of the terminal
RPROMPT='$(kube_ps1)'

# Ensure uv is added to the PATH
source "$HOME/.local/bin/env"

# Add Homebrew to the PATH
export PATH="$PATH:/home/linuxbrew/.linuxbrew/bin"

# Dotnet-related ENV variable
export DOTNET_ROOT="/home/linuxbrew/.linuxbrew/opt/dotnet/libexec"
