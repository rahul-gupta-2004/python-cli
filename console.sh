#!/usr/bin/env python3

import readline
import rlcompleter
import traceback
import sys
import os
import atexit
import io
from datetime import datetime

# ANSI color codes for terminal text formatting
WHITE = '\033[97m'
GREEN = '\033[92m'
CYAN = '\033[96m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'

# Function to format the command by stripping whitespace and converting to lowercase
def format_command(command):
    return command.strip().lower()

# Function to handle and print error messages with suggestions based on the error type
def handle_error(error):
    error_type = type(error).__name__
    print(YELLOW + "Error:", error_type + RESET)

    # Provide suggestions for common errors
    if isinstance(error, NameError):
        print("Possible solution: Check if the variable is defined or spelled correctly.")
    elif isinstance(error, SyntaxError):
        print("Possible solution: Check the syntax of your command or expression.")
    elif isinstance(error, TypeError):
        print("Possible solution: Ensure that you are using the correct data types or method signatures.")
    elif isinstance(error, ValueError):
        print("Possible solution: Verify that the input values are appropriate for the operation.")
    elif isinstance(error, IndexError):
        print("Possible solution: The index provided is out of range. Ensure that the index is within the bounds of the sequence.")
    else:
        print("No specific suggestion available for this error. Check the traceback for more information.")
    
    print(RESET, end="")

# Variable to store the previous command for comparison
prev_command = None

# Enable tab completion for input commands
readline.parse_and_bind("tab: complete")

# Get the current date and time for the header
current_datetime = datetime.now().strftime("%b %d %Y, %H:%M:%S")

# Print a Python version message similar to the Python interactive shell
print(f"Python 3.10.12 (main, {current_datetime}) [GCC 11.4.0] on linux\nType \"help\", \"copyright\", \"credits\" or \"license\" for more information.")

# Path to the command history file
history_file = os.path.expanduser("~/.pyhistory")

# Load command history if the file exists
try:
    readline.read_history_file(history_file)
except FileNotFoundError:
    pass

# Function to save the command history to the file when the program exits
def save_history():
    readline.write_history_file(history_file)

# Register the save_history function to be called at exit
atexit.register(save_history)

# Main loop to process user commands
try:
    while True:
        try:
            # Display the prompt and get user input
            command = input(WHITE + ">>> " + RESET)
        except EOFError:
            # Handle EOF (Ctrl+D) to exit the loop gracefully
            print()
            break

        # Format the command
        formatted_command = format_command(command)
        
        # Check if the command is different from the previous one
        if formatted_command != prev_command:
            try:
                # If the command is an assignment, import, function definition, or print statement, execute it
                if '=' in command or 'import' in command or 'def' in command or 'print' in command:
                    exec(command)
                    print(GREEN + "Command executed" + RESET)
                
                # Handle file execution using 'exec' with colorized output
                elif command.startswith('exec '):
                    filename = command.split()[1]
                    with open(filename, 'r') as f:
                        script_code = f.read()
                    
                    # Capture the output during file execution
                    old_stdout = sys.stdout
                    sys.stdout = io.StringIO()
                    try:
                        exec(script_code, globals())
                        output = sys.stdout.getvalue()
                    finally:
                        sys.stdout = old_stdout
                    
                    # Print captured output in green
                    print(GREEN + output + RESET)
                
                # For other expressions, evaluate and print the result
                else:
                    output = eval(command)
                    if output is not None:
                        print(CYAN + str(output) + RESET)
            
            # Handle and print exceptions, providing specific error handling
            except Exception as e:
                print(RED + "Error:", e)
                exc_type, exc_value, exc_traceback = sys.exc_info()
                if exc_traceback is not None:
                    exc_traceback = exc_traceback.tb_next
                exc_value.filename = "<stdin>"
                traceback.print_exception(exc_type, exc_value, exc_traceback, limit=2, file=sys.stdout)
                handle_error(e)
        
        # Store the current command as the previous one
        prev_command = formatted_command

# Handle the interruption (Ctrl+C) to exit the program gracefully
except KeyboardInterrupt:
    print()
    pass
