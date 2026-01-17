This is my personal [Quickshell](https://quickshell.org) configuration.
As a result it is tailored entirely for my use and is intended more as a basic example than for distribution.

The configuration assumes the use of [Hyprland](https://hypr.land) and [Kitty](https://sw.kovidgoyal.net/kitty/),
and uses [app2unit](https://github.com/Vladimir-csp/app2unit) to launch applications.

<img width="1879" height="49" alt="2025-12-15-131931_hyprshot" src="https://github.com/user-attachments/assets/26787c1f-b2eb-472d-afc9-7133fb3d450b" />

## Features
- Hyprland workspace display
- Volume, brightness, and battery display with dynamic icons
    - Updating brightness is your responsibility to implement, use `qs ipc call brightness set <percent>`
    - With [brillo](https://gitlab.com/cameronnemo/brillo), for example, use `qs ipc call brightness set $(brillo)` on start and whenever you update your brightness
- Active window title
- System tray
    - Use `qs ipc call menu cycle` to interact with menus from keyboard
- Time display
- Fuzzy .desktop launcher (triggered by `qs ipc call menu toggle`)
    - Considering adding more launcher features
- **Very** simplistic notification display (click notifications to dismiss)
    - Considering adding keyboard interaction

May consider including the currently-separate wallpaper layer if it ends up integrating with the rest of the shell.
