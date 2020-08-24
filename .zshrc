# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:"${PATH}:${HOME}/.local/bin/":$PATH

# make sure pyenv is in your $PATH
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# we want neovim as our editor
export VISUAL=nvim
export EDITOR="$VISUAL"

# Path to your oh-my-zsh installation.
export ZSH="/home/voekreb/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="mytheme"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

source $ZSH/oh-my-zsh.sh

# custom aliases 
alias cp="cp -i"                          # confirm before overwriting something
alias df='df -h'                          # human-readable sizes
alias free='free -m'                      # show sizes in MB

alias more=less

alias vim='nvim'
alias la='ls -a'

alias signal="signal-desktop"
alias ...="../.."
alias pmixer='python3 /usr/local/bin/pulsectl_mixer.py'
# for the workflow
alias guct="$HOME/GUCT/GuideCamTool-linux-2.1.0/bin/GuideCamTool"	 
alias qfits="$HOME/QFitsView/QFitsView_4.0"			
alias ds9="/usr/bin/ds9"
alias ciao="source $HOME/ciao_env/ciao-4.12/bin/ciao.bash"
# we'll need to sort out the virtual envs sometime...
# telassar python venv
alias telassar="source $HOME/Documents/telassar/env/bin/activate"

# pyreduc python venv
alias pyred="source $HOME/Docoments/pyreduc/pyreduce/bin/activate"

# make sure ipython loads the right instance, ie if in virtual env or not
alias ipy="python -c 'import IPython; IPython.terminal.ipapp.launch_new_instance()'"

# Some pywal stuff
# &   # run in the background
# ( ) # hide job messages
(cat ~/.cache/wal/sequences &)

# in case you want to use ttys
source ~/.cache/wal/colors-tty.sh

# for managing dotfiles
alias dotfig='/usr/bin/git --git-dir=/home/voekreb/.dotfiles/ --work-tree=/home/voekreb'

# from the pyenv/virtualenv github
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
eval "$(pyenv init -)"

eval "$(pyenv virtualenv-init -)"


