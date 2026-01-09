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
        echo "(P: %{$fg_bold[green]%}$(python -c 'import platform; print(platform.python_version())')%{$reset_color%}) "
    fi
}

function nvm_prompt_info {
    if type node >/dev/null 2>&1; then
        echo "(N: %{$fg_bold[cyan]%}$(node -v)%{$reset_color%}) "
    fi
}

function java_prompt_info {
    if type java >/dev/null 2>&1; then
        local java_ver=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}')
        echo "(J: %{$fg_bold[red]%}${java_ver}%{$reset_color%}) "
    fi
}

function days_remaining {
    local target=$(date -j -f "%Y-%m-%d" "2026-12-31" +%s)
    local now=$(date +%s)
    local diff=$(( (target - now) / 86400 ))
    echo "%{$FG[242]%}📅 ${diff}d%{$reset_color%} "
}

# --- 喝水状态函数 ---
function water_prompt_info {
    local water_file="$HOME/.water_count"
    local count=0

    # 读取喝水记录
    if [ -f "$water_file" ]; then
        count=$(cat "$water_file" 2>/dev/null)
    fi

    # 如果文件不存在或内容为空
    if [ -z "$count" ] || ! [[ "$count" =~ ^[0-9]+$ ]]; then
        count=0
    fi

    # 根据杯数设置颜色
    if [ $count -ge 6 ]; then
        # 大于等于6杯，绿色
        echo "(%{$FG[046]%}W: ${count}杯🟢%{$reset_color%})"
    else
        # 小于6杯，红色
        echo "(%{$FG[196]%}W: ${count}杯⭕️%{$reset_color%})"
    fi
}

# --- 最终 PROMPT 定义 ---
PROMPT="╭─ %{$FG[040]%}%n%{$reset_color%} 🤙 %{$FG[033]%}$(box_name)%{$reset_color%} %{$FG[239]%}in%{$reset_color%} %{$terminfo[bold]$FG[226]%}%~%{$reset_color%}\$(git_prompt_info) \$(days_remaining)
|    \$(prompt_char)\$(python_prompt_info)\$(nvm_prompt_info)\$(java_prompt_info)\$(virtualenv_info)\$(water_prompt_info)
╰─ >>> "

# --- Git & Ruby 样式 (保持不变) ---
ZSH_THEME_GIT_PROMPT_PREFIX=" %{$FG[239]%}on%{$reset_color%} %{$fg[255]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$FG[202]%} ⭕️"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$FG[040]%} 🟢"
ZSH_THEME_RUBY_PROMPT_PREFIX=" %{$FG[239]%}using%{$FG[243]%} ‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="›%{$reset_color%}"
