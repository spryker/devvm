# Customize default shell behaviour

# Setup ZSH with oh-my-zsh
ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
export DISABLE_UNTRACKED_FILES_DIRTY=true
plugins=(gitfast redis-cli spryker sudo composer docker npm)
source $ZSH/oh-my-zsh.sh

# Prompt
[ -f $HOME/.zsh_prompt ] && source $HOME/.zsh_prompt
export PS1='%n@${prompt_hostname} ${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'

# Check if running on vboxsf (windows)
if mount | grep /data/shop/development/current | grep -q vboxsf; then
  export PS1='%n@%m:~$ '
fi

# Local paths
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/.composer/vendor/bin:/home/vagrant/bin

# i18n
export LC_ALL="en_US.UTF-8"
if [ "$LC_CTYPE" = "UTF-8" ]; then export LC_CTYPE=C; fi

# NVM
if [ -f "/opt/nvm/nvm.sh" ]; then
  source /opt/nvm/nvm.sh
fi

# Spryker DevVM environment settings
if [ -f /etc/spryker-vm-env ]; then
  source /etc/spryker-vm-env
fi
export VM_PROJECT

# Spryker default environment
export APPLICATION_ENV=development

# Composer settings
export COMPOSER_PROCESS_TIMEOUT=3600

# Spryker aliases
set-vm-name() {
  echo "prompt_hostname=\"$1\"" > $HOME/.zsh_prompt
  echo "OK, changes will be visible after next login"
}

# Workaround for problem with number of open files, needed by ide-autogeneration
ulimit -n 65535
