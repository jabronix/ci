eval "$(starship init zsh)"
eval "$(direnv hook zsh)"

export GREEN='\033[0;32m'
export RED='\033[0;31m'
export NC='\033[0m' # No Color

printf "${GREEN}Your localhost home directory has been mounted at /localhost${NC}"

VIM_PLUGINS="/.vim/pack/dev"
if test -f "/localhost/${VIM_PLUGINS}"; then
    ln -s "/localhost/${VIM_PLUGINS}" "~/${VIM_PLUGINS}"
else
    echo "\n${GREEN}.vimrc and/or ~/.vim will be sourced into your profile${NC}"
fi

EXTRA_PROFILE=/localhost/.profile_shared
if test -f "$EXTRA_PROFILE"; then
    . $EXTRA_PROFILE
else
    echo "\n${GREEN}If you have a file named ~/.profile_shared it will be sourced into your profile${NC}"
fi

alias da="direnv allow"
