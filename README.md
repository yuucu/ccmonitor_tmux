# Claude Code Monitor for tmux

A tmux plugin that monitors Claude Code processes and displays their status in the tmux status bar.

## Features

- Display count of running Claude Code processes
- Show active vs total processes (active = processes with CPU usage above threshold)
- Configurable CPU threshold for determining "active" processes
- Configurable display format (simple numbers or fancy with emojis)
- Configurable update interval

## Installation

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/yourusername/tmux-ccmonitor ~/.tmux/plugins/tmux-ccmonitor
```

2. Add to your `~/.tmux.conf`:
```bash
run-shell "~/.tmux/plugins/tmux-ccmonitor/ccmonitor.tmux"
```

3. Reload tmux configuration:
```bash
tmux source-file ~/.tmux.conf
```

### Using TPM (Tmux Plugin Manager)

1. Add plugin to your `~/.tmux.conf`:
```bash
set -g @plugin 'yourusername/tmux-ccmonitor'
```

2. Install with `prefix + I`

## Configuration

Add these options to your `~/.tmux.conf` to customize the plugin:

```bash
# CPU threshold for determining active processes (default: 1.0)
set -g @ccmonitor_cpu_threshold "2.0"

# Update interval in seconds (default: 5)
set -g @ccmonitor_interval "3"

# Display format: simple or fancy (default: simple)
set -g @ccmonitor_display_format "fancy"

# Automatically add to status-right (default: false)
# If false, you need to manually add the status variable to your status-right
set -g @ccmonitor_auto_status "false"
```

### Manual Status Bar Configuration

By default, this plugin provides the Claude Code status as a tmux variable `@ccmonitor_status` that you can use in your status bar configuration. This gives you full control over where and how to display it.

To add the Claude Code monitor to your status bar, use the variable in your `~/.tmux.conf`:

```bash
# Example: Add to the right side of status bar
set -g status-right '#{@ccmonitor_status} | %Y-%m-%d %H:%M'

# Example: Add to the left side of status bar
set -g status-left '#{@ccmonitor_status} | #S'

# Example: Custom formatting
set -g status-right 'Claude: #{@ccmonitor_status} | CPU: #{cpu_percentage}'
```

If you prefer automatic setup, set `@ccmonitor_auto_status` to `"true"` and the plugin will automatically add the status to your `status-right`.

## Display Formats

### Simple Format (default)
- Shows `active/total` (e.g., `2/4`)

### Fancy Format
- Shows emoji indicators with counts:
  - 🔴 `0/0` - No processes running
  - ⚪ `0/2` - Processes running but none active
  - 🟢 `2/4` - Some processes are active

## Usage

Once configured, the Claude Code status will appear in your tmux status bar showing:
```
CC:2/4
```

Where:
- `2` = Number of active Claude Code processes (CPU > threshold)
- `4` = Total number of Claude Code processes

The status is available as `#{@ccmonitor_status}` variable that you can place anywhere in your status bar configuration.

## Manual Testing

You can test the monitor script directly:

```bash
# Show current status
./ccmonitor.sh status

# Show detailed information
./ccmonitor.sh info

# Run test mode
./ccmonitor.sh test

# Show help
./ccmonitor.sh help
```

## Environment Variables

The monitor script accepts these environment variables:

- `CCMONITOR_CPU_THRESHOLD` - CPU threshold percentage (default: 1.0)
- `CCMONITOR_UPDATE_INTERVAL` - Update interval in seconds (default: 5)
- `CCMONITOR_DISPLAY_FORMAT` - Display format: simple|fancy (default: simple)

## Requirements

- tmux
- Standard UNIX utilities (ps, grep, awk)
- Claude Code installed and running

## Troubleshooting

### Status not updating
- Check if the plugin is loaded: `tmux show-options -g | grep ccmonitor`
- Verify Claude Code processes are detected: `./ccmonitor.sh info`
- Check tmux status-interval: `tmux show-options -g status-interval`

### No Claude Code processes detected
- Verify Claude Code is running: `ps aux | grep claude`
- Check if process name matches: The script looks for processes containing "claude"

## License

MIT License