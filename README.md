# Touchpad Gestures

A brief description of the project goes here.


## • On-screen keyboard

When touching the screen, the on-screen keyboard appears automatically.

![on-screen-keyboard.gif](gif/on-screen-keyboard.gif)


## • One finger hold

This gesture simulates mouse dragging, as it can sometimes be difficult to perform on a touchpad. The mouse's left button is pressed after holding one finger for half a second and is released only after you stop moving the cursor, allowing you to adjust how long the dragging lasts.

![1-finger-hold.gif](gif/1-finger-hold.gif)


## • Two fingers swipe

This gesture has different effects depending on the app:

| **Terminal** | **File manager** | 
| ------------------------------------------------------------ | --------------------------------------------------------------- |
| <div align="center">Switching between older and newer commands in the terminal</div> | <div align="center">Navigating between inner and outer directories in a file manager</div> |
| ![2-fingers-swipe-termina==l.gif](gif/2-fingers-swipe-terminal.gif) | ![2-fingers-swipe-navigation.gif](gif/2-fingers-swipe-navigation.gif) |


## • Three fingers hold

This gesture has multiple actions. It is best to combine it with two native functions of **![GNOME Tweaks](https://gitlab.gnome.org/GNOME/gnome-tweaks)**: ***Middle Click Paste*** and ***Click the touchpad with three fingers for middle-click***.

Also, most ![clipboard managers](https://github.com/SUPERCILEX/gnome-clipboard-history) have the functionality to copy the text you select with your mouse. This allows you to paste different items on middle click, and others on standard paste (Ctrl+V) which this script emulates with a short hold of three fingers (less than half a seconds).

![3-fingers-hold-paste.gif](gif/3-fingers-hold-paste.gif)

Hold between 0.5 s and 1 s to emulate keys: Meta+C - my shortcut for clipboard view.

Hold longer to emulate Meta+comma - my shortcut for resizing a window.

![3-fingers-hold-longer.gif](gif/3-fingers-hold-longer.gif)


## • Three fingers swipe

Swiping with three fingers is used to switch between applications - by emulating Alt+Tab. Depending on how long you swipe, you can switch to different windows.

![3-fingers-swipe.gif](gif/3-fingers-swipe.gif)


## • Four fingers hold

A short press of four fingers immediately triggers the "Enter" key. It has to be a short hold though, just tapping the touchpad is not enough - due to ![libinput](https://wiki.archlinux.org/title/Libinput)'s limitations (otherwise I would change it to a tap for higher convenience).

![4-fingers-hold-enter.gif](gif/4-fingers-hold-enter.gif)

A longer hold of four fingers (at least 0.3 s) emualtes Meta+Space keys click - my shortcut for activiting the **![Fly Pie](https://extensions.gnome.org/extension/3433/fly-pie/)** menu.

![4-fingers-hold-flypie.gif](gif/4-fingers-hold-flypie.gif)


## Dependencies

To use the touchpad gestures effectively, make sure the following tools are installed on your system:

- **libinput**: Required for capturing touchpad events.  
- **ydotool**: Used to emulate key presses and mouse clicks.
- **gnome-settings-daemon** (or equivalent for your desktop environment): Needed for enabling/disabling the on-screen keyboard dynamically.  

Ensure that `ydotool` is properly configured to run without a password by allowing `sudo` access to the necessary socket. Also, Python is required if using the `getwindow.py` script for app-specific gesture behavior.
