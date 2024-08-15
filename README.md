# Python Interactive Command Line Interface

This project is a custom Python Interactive Command Line Interface (CLI) that enhances the default Python interpreter with features like command history, syntax highlighting, error handling, and more. It's designed to make running Python commands in an interactive session easier and more informative.

## Features

- **Command History**: Saves your command history to a file and reloads it when the script runs again.
- **Tab Completion**: Uses the `readline` library for tab completion, making it easier to complete commands and variable names.
- **Syntax Highlighting**: Custom color codes for different types of output (commands, errors, etc.).
- **Error Handling**: Detailed error messages with suggestions for common issues.
- **File Execution**: Execute a Python script from the CLI using the `exec` command, with output highlighted in green.
- **Custom Prompts**: Provides a custom prompt with the current date and time.

## Requirements

This script uses Python 3. Ensure you have Python 3.10 or higher installed on your system. It also relies on the following built-in libraries:

- `readline`
- `rlcompleter`
- `traceback`
- `sys`
- `os`
- `atexit`
- `io`
- `datetime`

## Installation

1. Clone the repository:
    ```bash
    git clone https://github.com/yourusername/python-interactive-cli.git
    cd python-interactive-cli
    ```

2. Make the script executable:
    ```bash
    chmod +x cli.py
    ```

3. Run the script:
    ```bash
    ./cli.py
    ```

## Usage

The CLI provides an interactive Python environment with enhanced features. Here are some common commands you can use:

1. **Execute a command**:
    ```python
    >>> print("Hello, World!")
    ```
    Output:
    ```text
    Hello, World!
    Command executed
    ```

2. **Execute a file**:
    ```python
    >>> exec script.py
    ```
    This will run the `script.py` file and print its output.

3. **Error handling**:
    If you make a mistake, the CLI will catch the error, display it in red, and provide a possible solution.
    ```python
    >>> print(unknown_var)
    ```
    Output:
    ```text
    Error: NameError
    Possible solution: Check if the variable is defined or spelled correctly.
    ```

4. **Custom colors**:
    - **Executed Commands**: Green
    - **Standard Output**: Cyan
    - **Errors**: Red
    - **Error Messages**: Yellow

## Example

Here's an example of using the interactive CLI:

```python
>>> import math
>>> result = math.sqrt(16)
>>> print(result)
Command executed
16.0
```

If you accidentally use an undefined variable:

```python
>>> print(unknown_var)
Error: NameError
Possible solution: Check if the variable is defined or spelled correctly.
