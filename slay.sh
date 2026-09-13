#!/bin/bash

# Script to kill a process running on a specified port
# Usage: ./slay.sh <port_number>

# Check if port argument is provided
if [ $# -eq 0 ]; then
    echo "Error: Port number is required"
    echo "Usage: $0 <port_number>"
    exit 1
fi

PORT=$1

# Validate that the argument is a number
if ! [[ "$PORT" =~ ^[0-9]+$ ]]; then
    echo "Error: Port must be a valid number"
    exit 1
fi

# Find the PID using lsof
PID=$(lsof -t -i :$PORT 2>/dev/null)

# Check if a process was found
if [ -z "$PID" ]; then
    echo "Error: No process found on port $PORT"
    exit 1
fi

# Get process information
PROCESS_INFO=$(ps -p $PID -o comm= 2>/dev/null)

if [ -z "$PROCESS_INFO" ]; then
    echo "Error: Could not retrieve process information for PID $PID"
    exit 1
fi

# Display process details
echo "=================================================="
echo "Process found on port $PORT:"
echo "  PID: $PID"
echo "  Process Name: $PROCESS_INFO"
echo "=================================================="

# Ask for confirmation
read -p "Do you want to kill this process? (y/n): " -r CONFIRM

if [[ $CONFIRM =~ ^[Yy]$ ]]; then
    # Kill the process
    kill -9 $PID 2>/dev/null
    
    if [ $? -eq 0 ]; then
        echo "Process killed successfully!"
        exit 0
    else
        echo "Error: Failed to kill process $PID"
        exit 1
    fi
else
    echo "Process not killed."
    exit 0
fi
