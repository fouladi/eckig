# ZSH Theme - Modified from bira.zsh-theme
# ╭─user@host ~/.oh-my-zsh ⟦master▴⟧
# ╰─◼

local return_code="%(?..%F{red}%? ◩%f)"

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m%{$reset_color%}'
    local user_symbol='➤ '
else
    local user_host='%{$terminfo[bold]$fg[cyan]%}%n@%m%{$reset_color%}'
    local user_symbol='◼ '
fi

local current_dir='%{$terminfo[bold]$fg[yellow]%}%~%{$reset_color%}'
local git_branch='$(git_prompt_info)%{$reset_color%}'

function git_prompt_info() {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return

  # Checks if working tree is dirty
  local STATUS=''
  local FLAGS
  FLAGS=('--porcelain')
  if [[ "$(command git config --get oh-my-zsh.hide-dirty)" != "1" ]]; then
    if [[ $POST_1_7_2_GIT -gt 0 ]]; then
      FLAGS+='--ignore-submodules=dirty'
    fi
    if [[ "$DISABLE_UNTRACKED_FILES_DIRTY" == "true" ]]; then
      FLAGS+='--untracked-files=no'
    fi
    STATUS=$(command git status ${FLAGS} 2> /dev/null | tail -n1)
  fi

  if [[ -n $STATUS ]]; then
    GIT_PROMPT_COLOR="$ZSH_THEME_GIT_PROMPT_DIRTY"
    GIT_DIRTY_STAR="▴"
  else
    GIT_PROMPT_COLOR="$ZSH_THEME_GIT_PROMPT_CLEAN"
    unset GIT_DIRTY_STAR
  fi

  echo "$GIT_PROMPT_COLOR$ZSH_THEME_GIT_PROMPT_PREFIX$(current_branch)$GIT_DIRTY_STAR$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

PROMPT="
╭─${user_host} ${current_dir} ${git_branch}
╰─%B${user_symbol}%b "
RPS1="%B${return_code}%b"


ZSH_THEME_GIT_PROMPT_PREFIX="⟦"
ZSH_THEME_GIT_PROMPT_SUFFIX="⟧$reset_color"
ZSH_THEME_GIT_PROMPT_DIRTY="$fg[red]"
ZSH_THEME_GIT_PROMPT_CLEAN="$fg[green]"
