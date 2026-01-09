#!/bin/bash

# 喝水记录文件
WATER_FILE="$HOME/.water_count"
# 日期记录文件
DATE_FILE="$HOME/.water_date"

# 检查是否需要重置（简化的版本）
check_reset() {
    local today=$(date +%Y-%m-%d)
    
    # 如果日期文件不存在，创建它
    if [ ! -f "$DATE_FILE" ]; then
        echo "$today" > "$DATE_FILE"
        echo "0" > "$WATER_FILE"
        return
    fi
    
    # 检查日期是否是今天
    local last_date=$(cat "$DATE_FILE" 2>/dev/null)
    if [ "$last_date" != "$today" ]; then
        # 新的一天，重置计数
        echo "$today" > "$DATE_FILE"
        echo "0" > "$WATER_FILE"
    fi
}

# 在所有操作前检查重置
check_reset

# 获取当前杯数
get_water_count() {
    cat "$WATER_FILE" 2>/dev/null || echo "0"
}

# 设置杯数
set_water_count() {
    echo "$1" > "$WATER_FILE"
}

# 增加杯数
add_water() {
    check_reset
    local current=$(get_water_count)
    local new=$((current + 1))
    set_water_count "$new"
    echo "✅ 喝水量：$new 杯"
}

# 减少杯数
sub_water() {
    check_reset
    local current=$(get_water_count)
    local new=$((current - 1))
    if [ $new -lt 0 ]; then
        new=0
    fi
    set_water_count "$new"
    echo "➖ 喝水量：$new 杯"
}

# 重置杯数
reset_water() {
    set_water_count "0"
    echo "🔄 喝水量已重置为 0"
}

# 显示杯数
show_water() {
    check_reset
    local count=$(get_water_count)
    if [ $count -ge 6 ]; then
        echo "🎉 今日已喝 $count 杯水（目标达成）"
    else
        echo "💧 今日已喝 $count 杯水"
    fi
}

# 主函数
main() {
    case "$1" in
        "-1"|"--minus"|"-")
            sub_water
            ;;
        "--reset"|"-r")
            reset_water
            ;;
        "--help"|"-h")
            echo "喝水追踪命令："
            echo "  he           - 增加一杯水"
            echo "  he -1        - 减少一杯水"
            echo "  he --reset   - 重置计数器"
            echo "  he --status  - 显示当前状态"
            ;;
        "--status"|"-s")
            show_water
            ;;
        "")
            add_water
            ;;
        *)
            echo "未知参数: $1"
            echo "使用 'he --help' 查看帮助"
            ;;
    esac
}

# 如果直接执行脚本
if [[ "${BASH_SOURCE[0]}" = "${0}" ]]; then
    main "$@"
fi
