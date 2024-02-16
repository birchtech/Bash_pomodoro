
#!/bin/bash

# Customizable settings
work_time=25   # Work duration in minutes
break_time=5   # Break duration in minutes
long_break_time=20  # Long break duration in minutes 
cycles_before_long_break=4  # Number of cycles before a long break

# Sound files (replace with your preferred sounds)
tick_sound="tick.wav"
work_end_sound="tone1.wav"
break_end_sound="tone1.wav"

# Helper functions
play_sound() {
  # Choose audio player based on your system (e.g., mpg123, vlc, paplay)
  paplay "$1" > /dev/null 2>&1& 
}

timer() {
  local minutes=$(( $1 * 60 ))
  local seconds=$minutes

  while [ $seconds -gt 0 ]; do
      printf "\r%02d:%02d remaining " $((seconds / 60)) $((seconds % 60))
      sleep 1
      seconds=$((seconds - 1))

      # Optional ticking sound
      if [ $((seconds % 5)) -eq 0 ]; then
        play_sound "$tick_sound" 
      fi
  done
  printf "\n"
}

# Main Pomodoro loop
cycle_count=0
while true; do
  echo "Starting work session..."
  timer $work_time
  play_sound "$work_end_sound"

  cycle_count=$((cycle_count + 1))

  if [ $((cycle_count % cycles_before_long_break)) -eq 0 ]; then
    echo "Time for a long break!"
    timer $long_break_time
    play_sound "$break_end_sound"
  else
    echo "Time for a short break!"
    timer $break_time
    play_sound "$break_end_sound"
  fi
done
