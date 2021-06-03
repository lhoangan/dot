cd ~/dot
xmodmap CLockToCntr
xcape -e 'Control_L=Escape;Control_L=Control_L'
xrandr --output VGA-1 --rotate left
xrandr --output VGA-1 --left-of LVDS-1
cd
