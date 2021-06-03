current_dir=$(pwd)
cd ~/dot
xmodmap CLockToCntr
xcape -e 'Control_L=Escape;Control_L=Control_L'
cd ${current_dir}
