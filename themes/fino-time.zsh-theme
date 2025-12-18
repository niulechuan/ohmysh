# fino-time.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} ⭕️"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%} 🟢"
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"

# --- 辅助工具函数 ---
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo 'GIT' && return
    echo '○'
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

function conda_env_prompt {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        echo "(Conda: %{$fg_bold[green]%}${CONDA_DEFAULT_ENV}%{$reset_color%}) "
    fi
}

function nvm_prompt_info {
    if type node >/dev/null 2>&1; then
        echo "(NVM: %{$fg_bold[cyan]%}$(node -v)%{$reset_color%}) "
    fi
}

function days_remaining {
    local target=$(date -j -f "%Y-%m-%d" "2026-12-31" +%s)
    local now=$(date +%s)
    local diff=$(( (target - now) / 86400 ))
    echo "%{$FG[242]%}📅 ${diff}d%{$reset_color%} "
}

# --- PROMPT 配置 ---
# 第一行末尾添加了 days_remaining，第二行保持之前的 Conda 和 NVM
PROMPT="╭─ %{$FG[040]%}%n%{$reset_color%} 🤙 %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info)\$(ruby_prompt_info) \$(days_remaining)
╰─ \$(virtualenv_info)\$(prompt_char)\$(conda_env_prompt)\$(nvm_prompt_info)"

# --- Git & Ruby 样式 ---
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} ⭕️"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%} 🟢"
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
