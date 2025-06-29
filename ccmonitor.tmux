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
    local script_path="CCMONITOR_CPU_THRESHOLD='$cpu_threshold' CCMONITOR_DISPLAY_FORMAT='$display_format' $CURRENT_DIR/ccmonitor.sh status"
    
    # Update tmux status bar update interval
    local current_interval=$(get_tmux_option "status-interval" "15")
    if [ "$current_interval" -gt "$update_interval" ]; then
        set_tmux_option "status-interval" "$update_interval"
    fi
    
    # Get current status-right
    local status_right=$(get_tmux_option "status-right" "")
    
    # Add ccmonitor to status-right if not already there
    if [[ "$status_right" != *"ccmonitor"* ]]; then
        if [ -z "$status_right" ]; then
            set_tmux_option "status-right" "#[fg=colour2]CC:#($script_path)#[default]"
        else
            set_tmux_option "status-right" "$status_right #[fg=colour2]CC:#($script_path)#[default]"
        fi
    fi
}

# Load the plugin
main "$@"