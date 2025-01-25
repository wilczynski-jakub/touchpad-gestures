#!/bin/bash

# a function to call the ydotool programme (to emulate key clicks) 
ydt() {
    if [[ "$1" =~ ^-?[0-9]+$ ]]; then
        local first="$1"

        # press the first key
        ydt key "$first:1"

        # recursively handling remaining arguments
        shift
        if [ -n "$1" ]; then
            ydt "$@"
        fi

        # release the first key
        ydt key "$first:0"
    else
        sudo -n YDOTOOL_SOCKET=/tmp/.ydotool_socket ydotool "$@" || notify-send "ydt" "sudo ydotool requires password"
    fi
}

# a function to check the current window (for app-specific gestures)
getwindow() {
    python getwindow.py
}

# listening for events from libinput
stdbuf -oL libinput debug-events | while read -r line; do
    
    ############################ turn on on-screen keyboard when touching the screen #############################
    
    if [[ "$line" == *"TOUCH_"* ]]; then
        if [[ "$(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)" != "true" ]]; then
            gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true
        fi
    else
        if [[ "$(gsettings get org.gnome.desktop.a11y.applications screen-keyboard-enabled)" != "false" ]]; then
            gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled false
        fi
    fi
    

    ########################### 1 finger hold gesture ############################
    
    if [[ "$line" =~ GESTURE_HOLD_BEGIN.*1$ ]]; then
    
        hold_1_start=$(echo "$line" | awk '{print $3}' | sed 's/+//;s/s//')
        echo "hold_1_start = $hold_1_start"
        
        # after 0.5s: mouse down
        (sleep 0.5 && ydt 97 && ydt click 0x40 && is_mouse_down=1) &
        delayed_mousedown="$!"
    
    elif [[ "$line" =~ GESTURE_HOLD_END.*1(\ cancelled)?$ ]]; then
        
        hold_1_end=$(echo "$line" | awk '{print $3}' | sed 's/+//;s/s//')
        echo "hold_1_end = $hold_1_end"

        if [[ -n "$hold_1_start" ]]; then
            time_diff=$(echo "$hold_1_end - $hold_1_start" | bc -l)
            if (( $(echo "$time_diff <= 0.5" | bc -l) )); then
                kill $delayed_mousedown
            fi
            hold_1_start=""
        fi; echo
        
    elif [[ "$line" =~ POINTER_MOTION ]] && ((is_mouse_down)); then

        # counting for how long is the mouse down without pointer moving
        # if not moving for 0.5s, the mouse will be released
        while true; do
            sleep 0.1

            if ps -p "$last_counting_process"; then
                kill "$last_counting_process"
            fi

            if ((is_mouse_down++ >= 5)); then
                ydt click 0x80 # mouse up
                is_mouse_down=0
                break
            fi
        done &
        last_counting_process="$!"

    fi

    
    ############################### 2 fingers swipe gestures ##############################
    
    threshold_swipe_2=7
    
    if [[ "$line" == *"POINTER_SCROLL_FINGER"*"vert 0.00/0.0"* ]] && [[ "$line" != *"horiz 0.00"* ]]; then
        
        # been swiping left for long enough
        if ((swiping_2_fingers <= -threshold_swipe_2)); then
            
            case "$(getwindow)" in
                "org.kde.dolphin")
                    # alt left
                    ydt 56 105
                    ;;
                *"term"*)
                    # pageup -> previous command
                    ydt 104
                    ;;
                "code"|"firefox"|"org.gnome.Software")
                    # not doing anything
                    ;;
                *)
                    # alt right
                    ydt 56 106
                    ;;
            esac

            swiping_2_fingers=0
            
        # been swiping right for long enough
        elif ((swiping_2_fingers >= threshold_swipe_2)); then
            
            case "$(getwindow)" in
                "org.kde.dolphin"|"org.gnome.FileRoller")
                    # alt up
                    ydt 56 103
                    ;;
                *"term"*)
                    # down -> next command
                    ydt 108
                    ;;
                "code"|"firefox"|"org.gnome.Software")
                    # not doing anything
                    ;;
                *)
                    # alt left
                    ydt 56 105
                    ;;
            esac
            
            swiping_2_fingers=0
            
        else
            # check the direction - this can be an independent if but I've put it here to save CPU a bit
            if [[ "$line" == *"horiz -"* ]]; then
                # swiping left
                ((--swiping_2_fingers))
            else
                # swiping right
                ((++swiping_2_fingers))
            fi
        fi
        
    elif ((swiping_2_fingers)); then
        swiping_2_fingers=0
    fi
    

    ########################### 3 fingers hold gesture ############################
    
    if [[ "$line" =~ GESTURE_HOLD_BEGIN.*3$ ]]; then
    
        hold_3_start=$(echo "$line" | awk '{print $3}' | sed 's/+//;s/s//')
        echo "hold_3_start = $hold_3_start"
        
        # after 1.1s: meta , -> resize window
        (sleep 0.1 && ydt 97 && sleep 1 && ydt 125 51) &
        delayed_resize="$!"
        
    elif [[ "$line" =~ GESTURE_HOLD_END.*3$ ]]; then
        
        hold_3_end=$(echo "$line" | awk '{print $3}' | sed 's/+//;s/s//')
        echo "hold_3_end = $hold_3_end"

        if [[ -n "$hold_3_start" ]]; then
            time_diff=$(echo "$hold_3_end - $hold_3_start" | bc -l)
            if (( $(echo "$time_diff <= 1.1" | bc -l) )); then
                kill $delayed_resize
                if (( $(echo "$time_diff >= 0.1" | bc -l) )); then
                    if (( $(echo "$time_diff < 0.6" | bc -l) )); then
                        ydt 29 47 # ctrl v -> paste
                    else
                        ydt 125 46 # meta c -> show clipboard
                    fi
                fi
            fi
            hold_3_start=""
        fi; echo
        
    fi


    ############################### 3 fingers swipe gestures ##############################
    
    threshold_swipe_3=10
    if [[ "$line" =~ GESTURE_SWIPE_UPDATE.*[^0-9]3[^0-9] ]]; then
        
        # been swiping left for long enough
        if ((++swiping_3_fingers > threshold_swipe_3)); then
            if ! ps -p "$release_alt"; then
                ydt key 56:1 # press alt
            else
                kill "$release_alt"
            fi

            ydt 15 # click tab
            swiping_3_fingers=0

            (sleep 0.25 && ydt key 56:0) & # release alt
            release_alt="$!"
        fi
        
    elif ((swiping_3_fingers)); then
        swiping_3_fingers=0
    fi  


    ########################### 4 fingers hold gesture ###########################
    
    if [[ "$line" =~ GESTURE_HOLD_BEGIN.*4$ ]]; then
    
        # immediately

        ydt 28 # enter
        

        hold_4_start=$(echo "$line" | awk '{print $3}' | sed 's/+//;s/s//')
        echo "hold_4_start = $hold_4_start"

        # after 0.3s: meta space -> fly pie
        (sleep 0.3 && ydt 29 44 && ydt 125 57) &
        fly_pie="$!"
        
    elif [[ "$line" =~ GESTURE_HOLD_END.*4$ ]]; then
        
        hold_4_end=$(echo "$line" | 
        awk '{print $3}' | sed 's/+//;s/s//')
        echo "hold_4_end = $hold_4_end"

        if [[ -n "$hold_4_start" ]]; then
            time_diff=$(echo "$hold_4_end - $hold_4_start" | bc -l)
            echo "= $time_diff"
            if (( $(echo "$time_diff < 0.5" | bc -l) )); then
                kill $fly_pie
                fly_pie=""
            fi
            hold_4_start=""
        fi; echo
        
    fi

done
