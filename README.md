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

# Display format: simple or fancy (default: simple)
set -g @ccmonitor_display_format "fancy"

# Custom status format (default: "CC:{active}/{total}")
# Available placeholders: {active}, {total}
set -g @ccmonitor_format "🤖{active}/{total}"
```

### Status Bar Configuration

The plugin automatically interpolates the following placeholders in your `status-left` and `status-right`:

- `#{ccmonitor_status}` - Shows formatted status (default: "CC:active/total")
- `#{ccmonitor_active}` - Shows only active process count
- `#{ccmonitor_total}` - Shows only total process count

Just add these placeholders to your tmux configuration:

```bash
# Add to status-right
set -g status-right '🤖#{ccmonitor_status} | %Y-%m-%d %H:%M'

# Or use individual values
set -g status-right 'Claude: #{ccmonitor_active}/#{ccmonitor_total} | %H:%M'

# Add to status-left
set -g status-left '#{ccmonitor_status} | #S'
```

#### Customizing the Format

You can customize the `#{ccmonitor_status}` format using the `@ccmonitor_format` option:

```bash
# Default format
set -g @ccmonitor_format "CC:{active}/{total}"

# With emoji
set -g @ccmonitor_format "🤖{active}/{total}"

# Verbose format
set -g @ccmonitor_format "Claude: {active} active / {total} total"

# Only show active count
set -g @ccmonitor_format "Active: {active}"

# With colors (tmux formatting)
set -g @ccmonitor_format "#[fg=green]CC:{active}#[default]/{total}"
```

## Display Formats

The `display_format` configuration only affects the `status` command output:

### Simple Format (default)
- Shows `active/total` (e.g., `2/4`)

### Fancy Format
- Shows emoji indicators with counts:
  - 🔴 `0/0` - No processes running
  - ⚪ `0/2` - Processes running but none active
  - 🟢 `2/4` - Some processes are active

**Note:** The `display_format` setting only affects the output of the `status` command when run directly from the command line.

## Usage

Once the plugin is loaded, it automatically replaces the placeholders in your status bar:

- `#{ccmonitor_status}` - Formatted status using `@ccmonitor_format`
- `#{ccmonitor_active}` - Raw number of active processes
- `#{ccmonitor_total}` - Raw number of total processes

The `@ccmonitor_format` option supports these placeholders:
- `{active}` - Number of active processes (CPU > threshold)
- `{total}` - Total number of processes

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
- `CCMONITOR_DISPLAY_FORMAT` - Display format: simple|fancy (default: simple)

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