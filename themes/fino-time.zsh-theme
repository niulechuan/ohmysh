# fino-time.zsh-theme

# Use with a dark background and 256-color terminal!
# Meant for people with RVM and git. Tested only on OS X 10.7.

# You can set your computer name in the ~/.box-name file if you want.

# Borrowing shamelessly from these oh-my-zsh themes:
#   bira
#   robbyrussell
#
# Also borrowing from http://stevelosh.com/blog/2010/02/my-extravagant-zsh-prompt/

# --- 环境信息获取函数 ---
function virtualenv_info {
    [ $VIRTUAL_ENV ] && echo '('`basename $VIRTUAL_ENV`') '
}

function prompt_char {
    git branch >/dev/null 2>/dev/null && echo 'GIT ' && return
    echo '○ '
}

function box_name {
    [ -f ~/.box-name ] && cat ~/.box-name || echo ${SHORT_HOST:-$HOST}
}

function python_prompt_info {
    if type python >/dev/null 2>&1; then
        echo "(Py: %{$fg_bold[green]%}$(python -c 'import platform; print(platform.python_version())')%{$reset_color%}) "
    fi
}

function nvm_prompt_info {
    if type node >/dev/null 2>&1; then
        echo "(NVM: %{$fg_bold[cyan]%}$(node -v)%{$reset_color%}) "
    fi
}

function java_prompt_info {
    local sdk_java_dir="$HOME/.sdkman/candidates/java"
    if [ -d "$sdk_java_dir" ]; then
        local current=$(basename $(readlink "$sdk_java_dir/current") 2>/dev/null)
        # 获取所有文件夹并拼接成字符串
        local all_vers=$(ls -1 "$sdk_java_dir" | grep -v "current" | tr '\n' '|' | sed 's/|$//')

        # 将当前版本高亮
        all_vers=${all_vers//$current/%{$fg_bold[red]%}$current%{$reset_color%}}

        echo "(Java: ${all_vers}) "
    fi
}

function days_remaining {
    local target=$(date -j -f "%Y-%m-%d" "2026-12-31" +%s)
    local now=$(date +%s)
    local diff=$(( (target - now) / 86400 ))
    echo "%{$FG[242]%}📅 ${diff}d%{$reset_color%} "
}

# --- 最终 PROMPT 定义 ---
PROMPT="╭─ %{$FG[040]%}%n%{$reset_color%} 🤙 %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info) \$(days_remaining)
|    \$(prompt_char)\$(python_prompt_info)\$(nvm_prompt_info)\$(java_prompt_info)\$(virtualenv_info)
╰─ >>> "

# --- Git & Ruby 样式 (保持不变) ---
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} ⭕️"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%} 🟢"
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
