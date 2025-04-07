#!/bin/bash

# Function to clean up simulation files
clean() {
    echo "Cleaning up simulation files..."
    rm -rf csrc simv simv.daidir ucli.key run.saif *.fsdb *.vcd *.vdd
    echo "Cleanup complete!"
}

# Check if the user wants to clean
if [ "$1" == "clean" ]; then
    clean
    exit 0
fi

# Check if a filename is provided
if [ $# -lt 1 ]; then
    echo "Usage: ./run_vcs.sh <filename> OR ./run_vcs.sh clean"
    exit 1
fi

# Get the filename from the first argument
FILENAME=$1

# Run the VCS command
vcs -sverilog -f "$FILENAME" -full64 -R -debug_access+all

