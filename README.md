# Mac Title Menu
A Mac-like window title and context menu applet built natively for KDE Plasma 6.

## Features
- **Mac-Style App Menu**: Left-click the active window's title in the panel to open a native context menu with window management actions (Minimize, Maximize, Close, Keep Above, etc.).
- **Native Plasma 6 Architecture**: Built on `PlasmaExtras.Menu` to ensure robust Wayland support, focus management, and flawless C++ backend integration.
- **Pixel-Perfect Aesthetic**: Mathematically centered layouts and 2px tight vertical panel margins seamlessly mirror the native Plasma 6 Global Menu button contour and styling.
- **Dynamic Substitutions**: Highly customizable text display using variables like `%a` (App Name) and `%w` (Window Title).

## Credits & Acknowledgments
This project was heavily refactored and expanded from the fantastic foundational work of:
- **[Dhruvesh Surolia](https://github.com/dhruv8sh/plasma6-window-title-applet)** (who ported the original concept to Plasma 6)
- **[Psifidotos](https://github.com/psifidotos)** (creator of the original Active Window Control applet)

## Substitutions
- **%a** : Application Name
- **%w** : Window Title
- **%q** : Activity Name
- `<b>`..`</b>` : Selective bold
- `<i>`..`</i>` : Selective Italics
- `<br>`/`<p>` : New line ([Text will not be elided with multi-line text](https://bugreports.qt.io/browse/QTBUG-16567))

## Images
<div align="center">
<p>
<img src="./combined_screenshots.png" alt="Hover State Themes" width="600"/>
<br/>
<i>Hover states across different Plasma themes</i>
<br/><br/>
</p>

<p>
<img src="./combined_pressed_screenshots.png" alt="Pressed State Themes" width="600"/>
<br/>
<i>Pressed states across different Plasma themes</i>
<br/><br/>
</p>

<p>
<img src="./combined_settings_screenshots.png" alt="Settings Configuration" width="800"/>
<br/>
<i>Applet Settings (Appearance, Behavior, Substitutions, Keyboard Shortcuts)</i>
<br/><br/>
</p>

</div>


## Installation

### Via KDE Store (Recommended)
You can easily install this directly through your Plasma Desktop:
1. Right-click your panel and select **Add Widgets...**
2. Click **Get New Widgets...**
3. Search for **Mac Title Menu** and hit install!

### Manual Installation
If you've cloned this repository, you can easily install and test it using the provided script:
```bash
./install.sh
```
*Note: This script copies the contents to `~/.local/share/plasma/plasmoids/com.ajxcodes.macappmenu` and automatically restarts the Plasma shell.*

Alternatively, you can build and install it using Plasma's native package tool:
```bash
kpackagetool6 -t Plasma/Applet -i ./
```
