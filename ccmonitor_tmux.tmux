#!/bin/bash

# Claude Code Monitor tmux plugin
# Displays Claude Code process status in tmux status bar

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Default values
DEFAULT_INTERVAL="5"
DEFAULT_CPU_THRESHOLD="1.0"
DEFAULT_DISPLAY_FORMAT="simple"

# Get tmux option with default fallback
get_tmux_option() {
    local option="$1"
    local default_value="$2"
    local option_value=$(tmux show-option -gqv "$option")
    if [ -z "$option_value" ]; then
        echo "$default_value"
    else
        echo "$option_value"
    fi
}

# Set tmux option
set_tmux_option() {
    local option="$1"
    local value="$2"
    tmux set-option -g "$option" "$value"
}

# Main function to setup the plugin
main() {
    # Get configuration options
    local update_interval=$(get_tmux_option "@ccmonitor_interval" "$DEFAULT_INTERVAL")
    local cpu_threshold=$(get_tmux_option "@ccmonitor_cpu_threshold" "$DEFAULT_CPU_THRESHOLD")
    local display_format=$(get_tmux_option "@ccmonitor_display_format" "$DEFAULT_DISPLAY_FORMAT")
    
    # Set script path with environment variables
    local script_path="CCMONITOR_CPU_THRESHOLD='$cpu_threshold' CCMONITOR_DISPLAY_FORMAT='$display_format' $CURRENT_DIR/ccmonitor_tmux.sh status"
    
    # Update tmux status bar update interval
    local current_interval=$(get_tmux_option "status-interval" "15")
    if [ "$current_interval" -gt "$update_interval" ]; then
        set_tmux_option "status-interval" "$update_interval"
    fi
    
    # Set script paths for active and total counts
    local active_script="CCMONITOR_CPU_THRESHOLD='$cpu_threshold' CCMONITOR_DISPLAY_FORMAT='$display_format' $CURRENT_DIR/ccmonitor_tmux.sh active"
    local total_script="CCMONITOR_CPU_THRESHOLD='$cpu_threshold' CCMONITOR_DISPLAY_FORMAT='$display_format' $CURRENT_DIR/ccmonitor_tmux.sh total"
    
    # Set tmux variables for active and total process counts
    set_tmux_option "@ccmonitor_active" "#($active_script)"
    set_tmux_option "@ccmonitor_total" "#($total_script)"
}

# Load the plugin
main "$@"