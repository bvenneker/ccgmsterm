#!/bin/bash

WINDOW_NAME="VICE (C64SC)"
            

# Wait 5 seconds
sleep 1.5

# Find the window (first match)
#WM_CLASS(STRING) = "x64sc", "X64sc"
WIN_ID=$(xdotool search --onlyvisible --class x64sc | head -n 1)
#WIN_ID=$(xdotool search --name "$WINDOW_NAME" | head -n 1)

if [ -z "$WIN_ID" ]; then
    echo "VICE window not found."
    exit 1
fi

# Activate the window
xdotool windowactivate --sync "$WIN_ID"

# Small delay to ensure focus
sleep 0.2

# Send Alt+W
xdotool key  Alt+w

echo "Sent Alt+W to $WINDOW_NAME"
