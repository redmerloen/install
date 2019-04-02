#!/bin/sh

CURRENT_DIR=`pwd`

# install zsh
brew install zsh zsh-completions

# install oh my zsh
curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh

# install iterm2
brew cask install iterm2

# download ZSH theme
cd ~/.oh-my-zsh/themes
curl -O "https://raw.githubusercontent.com/redmerloen/install/master/.oh-my-zsh/themes/cobalt2.zsh-theme"

# download zsh configration
cd ~/.
curl -O "https://raw.githubusercontent.com/redmerloen/install/master/.zshrc"
curl -O "https://raw.githubusercontent.com/redmerloen/install/master/.aliasses"
curl -O "https://raw.githubusercontent.com/redmerloen/install/master/.path_exports"

# install shell integration & utilities
curl -L https://iterm2.com/misc/install_shell_integration.sh | bash

# ZSH plugins
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search


brew install rbenv
rbenv init

cd "$CURRENT_DIR"
