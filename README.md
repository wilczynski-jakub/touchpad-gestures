# Touchpad Gestures

A brief description of the project goes here.

## • On-screen keyboard

When touching the screen, the on-screen keyboard appears automatically.

![on-screen-keyboard.gif](on-screen-keyboard.gif)

## • One finger hold

This gesture simulates mouse dragging, as it may be sometimes difficult to perform on a touchpad. The mouse's left button is pressed after holding one finger for half a second, and is released only after you stop the cursor - which means you can adjust how long will the dragging last.

![1-finger-hold.gif](1-finger-hold.gif)

## • Two fingers swipe

This gesture has different effects, depending on the app:

| **Terminal** | **File manager** | 
| switching between older and newer commands, when in terminal | navigating between inner or outer directories, when in a file manager |
| ------------------------------------------------------------ | --------------------------------------------------------------- |
| ![2-fingers-swipe-terminal.gif](2-fingers-swipe-terminal.gif) | ![2-fingers-swipe-navigation.gif](2-fingers-swipe-navigation.gif) |

## • Three fingers hold

The "three fingers hold" gesture adds versatility to window management and text manipulation. Depending on how long you hold the gesture:  
- a short hold pastes the clipboard content into the active window.  
- a slightly longer hold displays the clipboard history to let you choose what to paste.  

![3-fingers-hold-paste.gif](3-fingers-hold-paste.gif)  
![3-fingers-hold-longer.gif](3-fingers-hold-longer.gif)

## • Three fingers swipe

Swiping with three fingers is used to switch between applications. Holding this gesture for some time triggers the "Alt + Tab" window switcher. After navigating through windows, lifting your fingers confirms the selection.

![3-fingers-swipe.gif](3-fingers-swipe.gif)

## • Four fingers hold

The "four fingers hold" gesture is multifunctional:  
- a short press immediately triggers the "Enter" key.  
- a longer hold activates "Fly Pie," allowing efficient navigation through application menus.  

![4-fingers-hold-enter.gif](4-fingers-hold-enter.gif)  
![4-fingers-hold-flypie.gif](4-fingers-hold-flypie.gif)

These intuitive touchpad gestures make everyday operations smoother and significantly enhance usability for devices where traditional mouse or touchscreen gestures might be challenging to execute.

## Dependencies

To use the touchpad gestures effectively, make sure the following tools are installed on your system:

- **libinput**: Required for capturing touchpad events.  
- **ydotool**: Used to emulate key presses and mouse clicks.
- **gnome-settings-daemon** (or equivalent for your desktop environment): Needed for enabling/disabling the on-screen keyboard dynamically.  

Ensure that `ydotool` is properly configured to run without a password by allowing `sudo` access to the necessary socket. Also, Python is required if using the `getwindow.py` script for app-specific gesture behavior.
