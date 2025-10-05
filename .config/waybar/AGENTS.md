# Waybar Configuration - Agent Guidelines

## Project Overview
This is a Waybar configuration directory containing JSONC config and CSS styling files for the Waybar status bar (used with Hyprland/Wayland).

## Build/Test Commands
- **Apply changes**: Restart Waybar: `pkill waybar && waybar &` or `killall -SIGUSR2 waybar` (reload)
- **Validate config**: `waybar --config config.jsonc --style style.css --log-level debug`
- No automated tests - changes require manual verification

## Code Style Guidelines

### config.jsonc
- Use JSONC format with C-style comments (`//`)
- Indent with 4 spaces
- Keep commented-out options as examples for reference
- Module order: left (workspaces) → center (clock) → right (tray, audio, etc.)
- Use double quotes for strings
- Format: `"key": value` with space after colon

### style.css
- Use Gruvbox Dark color palette (defined at top with `@define-color`)
- Reference colors with `@colorname` syntax
- Consistent border-radius: `1rem` for rounded elements
- Padding: `0.3rem 0.8rem` for modules, `0.3rem` for buttons
- Margin: `3px` standard spacing
- Font: JetBrainsMono Nerd Font Propo at 14px
- Group selectors with commas for shared styles
