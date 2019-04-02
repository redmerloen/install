#
# Cobalt2 Theme - https://github.com/wesbos/Cobalt2-iterm
#
# # README
#
# In order for this theme to render correctly, you will need a
# [Powerline-patched font](https://gist.github.com/1595572).
##
### Segment drawing
# A few utility functions to make it easy and re-usable to draw segmented prompts

CURRENT_BG='NONE'
SEGMENT_SEPARATOR=''

# Begin a segment
# Takes two arguments, background and foreground. Both can be omitted,
# rendering default background/foreground.
prompt_segment() {
  local bg fg
  [[ -n $1 ]] && bg="%K{$1}" || bg="%k"
  [[ -n $2 ]] && fg="%F{$2}" || fg="%f"
  if [[ $CURRENT_BG != 'NONE' && $1 != $CURRENT_BG ]]; then
    echo -n " %{$bg%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR%{$fg%} "
  else
    echo -n "%{$bg%}%{$fg%} "
    # echo $(pwd | sed -e "s,^$HOME,~," | sed "s@\(.\)[^/]*/@\1/@g")
    # echo $(pwd | sed -e "s,^$HOME,~,")
  fi
  CURRENT_BG=$1
  [[ -n $3 ]] && echo -n $3
}

# End the prompt, closing any open segments
prompt_end() {
  if [[ -n $CURRENT_BG ]]; then
    echo -n " %{%k%F{$CURRENT_BG}%}$SEGMENT_SEPARATOR"
  else
    echo -n "%{%k%}"
  fi
  echo -n "%{%f%}"
  CURRENT_BG=''
}

### Prompt components
# Each component will draw itself, and hide itself if no information needs to be shown

# Context: user@hostname (who am I and where am I)
prompt_context() {
  local user=`whoami`

  if [[ "$user" != "$DEFAULT_USER" || -n "$SSH_CLIENT" ]]; then
    prompt_segment black default "%(!.%{%F{yellow}%}.)✝"
  fi
}

# Git: branch/detached head, dirty status
prompt_git() {
  local ref dirty mode repo_path git_prompt
  repo_path=$(git rev-parse --git-dir 2>/dev/null)

  if $(git rev-parse --is-inside-work-tree >/dev/null 2>&1); then
    ZSH_THEME_GIT_PROMPT_UNTRACKED=" %F{green}✭%F{black}"
    ZSH_THEME_GIT_PROMPT_DIRTY=' %F{red}✘%F{black}'
    ZSH_THEME_GIT_PROMPT_CLEAN=" %F{green}✔%F{black}"
    ZSH_THEME_GIT_PROMPT_ADDED=" %F{green}✚%F{black}"
    ZSH_THEME_GIT_PROMPT_MODIFIED=" %F{blue}✹%F{black}"
    ZSH_THEME_GIT_PROMPT_DELETED=" %F{red}✖%F{black}"
    ZSH_THEME_GIT_PROMPT_RENAMED=" ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED=" ═"
    ZSH_THEME_GIT_PROMPT_AHEAD=" ⬆"
    ZSH_THEME_GIT_PROMPT_BEHIND=" ⬇"
    ZSH_THEME_GIT_PROMPT_DIVERGED=" ⬍"
    ZSH_THEME_GIT_PROMPT_PREFIX=' '
    ZSH_THEME_GIT_PROMPT_SUFFIX=''

    dirty=$(parse_git_dirty)
    # ref=$(git symbolic-ref HEAD 2> /dev/null) || ref="➦ $(git show-ref --head -s --abbrev |head -n1 2> /dev/null)"

    if [[ -n $dirty ]]; then
      prompt_segment yellow black
    else
      prompt_segment green black
    fi

    eval git_prompt="\$(git_prompt_info)"

    echo -n "${git_prompt}${git_prompt_status}"
  fi
}

# Dir: current working directory
prompt_dir() {
  prompt_segment blue black '%3~'
  # prompt_segment blue black "…${PWD: -30}"
}

# Status:
# - was there an error
# - am I root
# - are there background jobs?
prompt_status() {
  local symbols
  symbols=()
  [[ $RETVAL -ne 0 ]] && symbols+="%{%F{red}%}✘ "
  [[ $UID -eq 0 ]] && symbols+="%{%F{yellow}%}⚡ "
  [[ $(jobs -l | wc -l) -gt 0 ]] && symbols+="%{%F{cyan}%}⚙"

  [[ -n "$symbols" ]] && prompt_segment black default "$symbols"
}

## Main prompt
build_prompt() {
  RETVAL=$?
  prompt_status
  prompt_context
  prompt_dir
  prompt_git
  prompt_end
}

PROMPT='%{%f%b%k%}$(build_prompt) '
