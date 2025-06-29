# Claude Code Monitor for tmux

A tmux plugin that monitors Claude Code processes and displays their status in the tmux status bar.

## Features

- Display count of running Claude Code processes
- Show active vs total processes (active = processes with CPU usage above threshold)
- Configurable CPU threshold for determining "active" processes
- Configurable update interval

## Installation

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/yuucu/tmux-ccmonitor ~/.tmux/plugins/tmux-ccmonitor
```

2. Add to your `~/.tmux.conf`:
```bash
run-shell "~/.tmux/plugins/tmux-ccmonitor/ccmonitor_tmux.tmux"
```

3. Reload tmux configuration:
```bash
tmux source-file ~/.tmux.conf
```

### Using TPM (Tmux Plugin Manager)

1. Add plugin to your `~/.tmux.conf`:
```bash
set -g @plugin 'yuucu/tmux-ccmonitor'
```

2. Install with `prefix + I`

## Configuration

Add these options to your `~/.tmux.conf` to customize the plugin:

```bash
# CPU threshold for determining active processes (default: 1.0)
set -g @ccmonitor_cpu_threshold "2.0"

# Update interval in seconds (default: 5)
set -g @ccmonitor_interval "3"
```

### Status Bar Configuration

The plugin automatically interpolates the following placeholders in your `status-left` and `status-right`:

- `#{ccmonitor_active}` - Shows only active process count
- `#{ccmonitor_total}` - Shows only total process count

Just add these placeholders to your tmux configuration:

```bash
# Add to status-right
set -g status-right 'Claude: #{ccmonitor_active}/#{ccmonitor_total} | %Y-%m-%d %H:%M'

# Add to status-left
set -g status-left 'CC:#{ccmonitor_active}/#{ccmonitor_total} | #S'

# With emoji and colors
set -g status-right '🤖#{ccmonitor_active}/#{ccmonitor_total} | %H:%M'
```


## Usage

Once the plugin is loaded, it automatically replaces the placeholders in your status bar:

- `#{ccmonitor_active}` - Number of active processes (CPU > threshold)
- `#{ccmonitor_total}` - Total number of processes

The status updates automatically based on your configured interval.

## Manual Testing

You can test the monitor script directly:

```bash
# Show current status (active/total format)
./ccmonitor_tmux.sh status

# Show only active count
./ccmonitor_tmux.sh active

# Show only total count  
./ccmonitor_tmux.sh total

# Show detailed information
./ccmonitor_tmux.sh info

# Run test mode
./ccmonitor_tmux.sh test

# Show help
./ccmonitor_tmux.sh help
```

## Environment Variables

The monitor script accepts these environment variables:

- `CCMONITOR_CPU_THRESHOLD` - CPU threshold percentage (default: 1.0)
- `CCMONITOR_UPDATE_INTERVAL` - Update interval in seconds (default: 5)

## Requirements

- tmux
- Standard UNIX utilities (ps, grep, awk)
- Claude Code installed and running

## Troubleshooting

### Status not updating
- Check if the plugin is loaded: `tmux show-options -g | grep ccmonitor`
- Verify Claude Code processes are detected: `./ccmonitor_tmux.sh info`
- Check tmux status-interval: `tmux show-options -g status-interval`

### No Claude Code processes detected
- Verify Claude Code is running: `ps aux | grep claude`
- Check if process name matches: The script looks for processes containing "claude"

## License

MIT License