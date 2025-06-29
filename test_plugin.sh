#!/bin/bash

# Test script for Claude Code Monitor tmux plugin

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "=== Claude Code Monitor Plugin Test ==="
echo

# Test 1: Monitor script functionality
echo "1. Testing monitor script..."
echo "   Current status: $(${SCRIPT_DIR}/ccmonitor_tmux.sh status)"
echo "   Fancy format: $(CCMONITOR_DISPLAY_FORMAT=fancy ${SCRIPT_DIR}/ccmonitor_tmux.sh status)"
echo

# Test 2: Plugin loading simulation
echo "2. Testing plugin configuration..."
cd "$SCRIPT_DIR"

# Simulate tmux plugin loading
echo "   Loading plugin..."
if [ -f "ccmonitor_tmux.tmux" ]; then
    echo "   ✓ Plugin file exists"
    if [ -x "ccmonitor_tmux.tmux" ]; then
        echo "   ✓ Plugin file is executable"
    else
        echo "   ✗ Plugin file is not executable"
    fi
else
    echo "   ✗ Plugin file not found"
fi

# Test 3: Monitor script with different thresholds
echo
echo "3. Testing different CPU thresholds..."
echo "   Threshold 0.1%: $(CCMONITOR_CPU_THRESHOLD=0.1 ${SCRIPT_DIR}/ccmonitor_tmux.sh status)"
echo "   Threshold 5.0%: $(CCMONITOR_CPU_THRESHOLD=5.0 ${SCRIPT_DIR}/ccmonitor_tmux.sh status)"
echo "   Threshold 50.0%: $(CCMONITOR_CPU_THRESHOLD=50.0 ${SCRIPT_DIR}/ccmonitor_tmux.sh status)"

# Test 4: Detailed process information
echo
echo "4. Detailed process information:"
${SCRIPT_DIR}/ccmonitor_tmux.sh info

# Test 5: Manual tmux integration test
echo
echo "5. Manual tmux integration instructions:"
echo "   To test in tmux session, run:"
echo "   1. Start tmux: tmux new-session -d -s test"
echo "   2. Load plugin: tmux run-shell '${SCRIPT_DIR}/ccmonitor_tmux.tmux'"
echo "   3. Check status: tmux show-options -g status-right"
echo "   4. Attach to session: tmux attach -t test"
echo

echo "=== Test Complete ==="