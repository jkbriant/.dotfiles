#!/bin/sh

# slock is a simple lock screen, it doesn't support the logind lock file
# descriptor directly, so we use a wrapper script.

# Close the file descriptor (FD) once slock is running.
# This signals logind that the screen is locked and it can proceed with suspend/hibernate.

# Check if we were called due to a sleep event
if [ -n "$XSS_SLEEP_LOCK_FD" ]; then
    # Execute slock, wait for it to start, then close the FD
    slock &
    SLOCK_PID=$!
    
    # Close the file descriptor, telling logind that the lock is active.
    # Note the 'exec' here to correctly close the FD.
    exec {XSS_SLEEP_LOCK_FD}>&-
    
    # Wait for slock to exit (i.e., the user unlocked)
    wait "$SLOCK_PID"
else
    # Not a sleep event, just run slock normally
    exec slock
fi
