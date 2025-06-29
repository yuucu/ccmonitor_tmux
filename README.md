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
```

## Display Formats

### Simple Format (default)
- Shows `active/total` (e.g., `2/4`)

### Fancy Format
- Shows emoji indicators with counts:
  - 🔴 `0/0` - No processes running
  - ⚪ `0/2` - Processes running but none active
  - 🟢 `2/4` - Some processes are active

## Usage

The plugin automatically adds the Claude Code status to your tmux status bar. The format will be:
```
CC:2/4
```

Where:
- `2` = Number of active Claude Code processes (CPU > threshold)
- `4` = Total number of Claude Code processes

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