# ZSH Theme - Modified from bira and half-life
# ╭─⟦3:24⟧ user@host ~/.oh-my-zsh ⟦master▴⟧
# ╰─◼

# refresh clock in prompt every 10 sec
TMOUT=10
TRAPALRM() {
  zle reset-prompt
}

setopt prompt_subst

autoload -U add-zsh-hook
autoload -Uz vcs_info

#use extended color palette if available
if [[ $TERM = *256color* || $TERM = *rxvt* ]]; then
    snowwhite="%F{250}"
    turquoise="%F{81}"
    orange="%F{166}"
    brown="%F{215}"
    purple="%F{135}"
    hotpink="%F{161}"
    limegreen="%F{118}"
    grey="%F{241}"
else
    snowwhite="$fg[white]"
    turquoise="$fg[cyan]"
    orange="$fg[yellow]"
    brown="$fg[yellow]"
    purple="$fg[magenta]"
    hotpink="$fg[red]"
    limegreen="$fg[green]"
    grey="$fg[black]"
fi

# enable VCS systems you use
zstyle ':vcs_info:*' enable git

# check-for-changes can be really slow.
# you should disable it, if you work with large repositories
zstyle ':vcs_info:*:prompt:*' check-for-changes true

# set formats
# %b - branchname
# %u - unstagedstr (see below)
# %c - stagedstr (see below)
# %a - action (e.g. rebase-i)
# %R - repository path
# %S - path in the repository
PR_RST="%{${reset_color}%}"
FMT_BRANCH=" on %{$limegreen%}%b%u%c${PR_RST}"
FMT_ACTION=" performing a %{$limegreen%}%a${PR_RST}"
FMT_UNSTAGED="%{$orange%} ▴"
FMT_STAGED="%{$limegreen%} ▴"

zstyle ':vcs_info:*:prompt:*' unstagedstr   "${FMT_UNSTAGED}"
zstyle ':vcs_info:*:prompt:*' stagedstr     "${FMT_STAGED}"
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   ""

function farr_precmd {
    # check for untracked files or updated submodules, since vcs_info doesn't
    if [[ ! -z $(git ls-files --other --exclude-standard 2> /dev/null) ]]; then
        FMT_BRANCH="${PM_RST}⟦%{$limegreen%}%b%u%c%{$hotpink%} ▴${PR_RST}⟧"
    else
        FMT_BRANCH="${PM_RST}⟦%{$limegreen%}%b%u%c${PR_RST}⟧"
    fi
    zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"

    vcs_info 'prompt'
}
add-zsh-hook precmd farr_precmd

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]%{$hotpink%}%}%n@%m%{$reset_color%}'
    local user_symbol='%{$snowwhite%}➤ %{$reset_color%}'
else
    local user_host='%{$terminfo[bold]%{$grey%}%}%n@%m%{$reset_color%}'
    local user_symbol='%{$snowwhite%}◼ %{$reset_color%}'
fi

local return_code="%(?..%{$hotpink%}%? ◩%f)"
local current_time='⟦%D{%L:%M}⟧%{$reset_color%}'  # add :%S if you want seconds too
local current_dir='%{$terminfo[bold]%{$brown%}%}%~%{$reset_color%}'
local git_branch='$vcs_info_msg_0_%{$reset_color%}'
local bg_job='$(job_status)%{$reset_color%}'

fuction job_status() {
  if [[ $(jobs -l | wc -l) -gt 0 ]]; then
    echo "⬙"
  fi
}

PROMPT="
╭─${bg_job} ${current_time} ${user_host} ${current_dir} ${git_branch}
╰─%B${user_symbol}%b$snowwhite "
RPS1="%B${return_code}%b"
