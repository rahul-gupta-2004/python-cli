#!/usr/bin/env python3

import readline
import rlcompleter
import traceback
import sys
import os
import atexit
import io
from datetime import datetime

WHITE = '\033[97m'
GREEN = '\033[92m'
CYAN = '\033[96m'
RED = '\033[91m'
YELLOW = '\033[93m'
RESET = '\033[0m'

def format_command(command):
    return command.strip().lower()

def handle_error(error):
    error_type = type(error).__name__
    print(YELLOW + "Error:", error_type + RESET)

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
    
    print(RESET, end = "")

prev_command = None

readline.parse_and_bind("tab: complete")

# Get the current date and time
current_datetime = datetime.now().strftime("%b %d %Y, %H:%M:%S")

print(f"Python 3.10.12 (main, {current_datetime}) [GCC 11.4.0] on linux\nType \"help\", \"copyright\", \"credits\" or \"license\" for more information.")

history_file = os.path.expanduser("~/.pyhistory")
try:
    readline.read_history_file(history_file)
except FileNotFoundError:
    pass

def save_history():
    readline.write_history_file(history_file)

atexit.register(save_history)

try:
    while True:
        try:
            command = input(WHITE + ">>> " + RESET)
        except EOFError:
            print()
            break
        formatted_command = format_command(command)
        if formatted_command != prev_command:
            try:
                if '=' in command or 'import' in command or 'def' in command or 'print' in command:
                    exec(command)
                    print(GREEN + "Command executed" + RESET)
                elif command.startswith('exec '):  # Handle file execution with colorized output
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
                else:
                    output = eval(command)
                    if output is not None:
                        print(CYAN + str(output) + RESET)
            except Exception as e:
                print(RED + "Error:", e)
                exc_type, exc_value, exc_traceback = sys.exc_info()
                if exc_traceback is not None:
                    exc_traceback = exc_traceback.tb_next
                exc_value.filename = "<stdin>"
                traceback.print_exception(exc_type, exc_value, exc_traceback, limit=2, file=sys.stdout)
                handle_error(e)
        prev_command = formatted_command
except KeyboardInterrupt:
    print()
    pass
