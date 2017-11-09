# This file is maintained by Salt!
# local modifications to this file will be preserved - if this file exists,
# salt will not overwrite it.

ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"
plugins=(gitfast redis-cli spryker sudo)
source $ZSH/oh-my-zsh.sh
[ -f $HOME/.zsh_prompt ] && source $HOME/.zsh_prompt
export PATH=/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin:/home/vagrant/.composer/vendor/bin:/home/vagrant/bin
export PS1='%n@${prompt_hostname} ${ret_status}%{$fg_bold[green]%}%p %{$fg[cyan]%}%c %{$fg_bold[blue]%}$(git_prompt_info)%{$fg_bold[blue]%} % %{$reset_color%}'
export LC_ALL="en_US.UTF-8"
if [ "$LC_CTYPE" = "UTF-8" ]; then export LC_CTYPE=C; fi

set-vm-name() {
  echo "prompt_hostname=\"$1\"" > $HOME/.zsh_prompt
  echo "OK, changes will be visible after next login"
}
