---
name: python-script-standardizer
description: This SKILL provides the comprehensive set of rules and best practices for creating, updating, and reviewing Python scripts. It ensures all scripts are high-quality, maintainable, and conform to a unified standard. The AI assistant must adhere to these rules at all times.
---

# Architecture & Design

## Function-Based Approach

All scripts must be architected using functions. Avoid loose code in the global scope, with the exception of constants and initial setup.

## Single Responsibility Principle

Every function must have one, and only one, clear responsibility.

## Public Functions Only

Do not use "private" functions (e.g., prefixed with an underscore `_`). All functions should be treated as part of the public API of the script.

## EAFP Error Handling

Employ a "fail-fast" approach aligned with the EAFP philosophy. **Do not explicitly handle exceptions with `try...except` blocks.** You should let exceptions propagate naturally to terminate the script, making any errors immediately and clearly visible.

## Dataclasses for Classes

When a class structure is needed, it **must** be implemented using `dataclasses`.

# Code Structure & Order

## Function Order

The `main` function (the entry point) must be the first function defined in the script. Subsequent utility functions should be sorted following the order in which they are first referenced.

## Import Sorting

All import statements must be sorted using `ruff`. The assistant should assume the execution of the following command to format imports:

```bash
ruff check --select I --fix <script.py>
```

## Indentation

All code must be indented using **4 spaces** per level. Tab characters are not allowed.

## Max Line Length

The maximum line length for code and comments is **125 characters**.

# Dependency Management & Shebang

## Tooling

Use `uv` for managing dependencies and running the script.

## Shebang and Dependencies

Every script must start with the following shebang and dependency block format. Versions must not be pinned.

```python
#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "azure-identity",
#     "azure-keyvault-certificates",
#     "azure-keyvault-keys",
#     "azure-keyvault-secrets",
#     "azure-mgmt-keyvault",
#     "click",
#     "colorlog",
#     "requests",
# ]
# ///
```

# Typing, Docstrings, and CLI

## Docstrings

Every function must have a clear and concise docstring explaining **only its purpose**.

## Type Hinting

All function arguments and variables must have type hints. All functions must have a return type hint. Use the `collections.abc` library for generic type hinting (e.g., `list` -> `collections.abc.Sequence`).

## Argument Parsing

Use the `click` library to parse all command-line arguments. For scripts using `click`, the `pylint: disable=no-value-for-parameter` comment must be added immediately before the `main()` function call in the `if __name__ == "__main__":` block:

```python
if __name__ == "__main__":
    # pylint: disable=no-value-for-parameter
    main()
```

# Logging

The logging strategy depends on the script's complexity.

## For Small Scripts

Use a simple `log` function that writes to `stderr` using `click.echo`. This function must be included in the script.

```python
import click

def log(message: str) -> None:
    """Write a message to stderr."""
    click.echo(message, err=True)
```

## For Larger Scripts

Use the standard `logging` library configured with `colorlog`. The setup must be as follows:

```python
import logging
from colorlog import ColoredFormatter

logger = logging.getLogger(__name__)

def setup_logging() -> None:
    """Set up a custom logger."""
    handler = logging.StreamHandler()
    formatter = ColoredFormatter(
        "%(log_color)s%(asctime)s %(levelname)-8s%(reset)s %(blue)s%(message)s",
        datefmt="%Y-%m-%dT%H:%M:%S%z",  # ISO-8601 format
        reset=True,
        log_colors={"DEBUG": "cyan", "INFO": "green", "WARNING": "yellow", "ERROR": "red"},
        style="%",
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel("INFO")
```

# Linting & Quality Assurance

All scripts must be checked for issues using `ruff`. The assistant must ensure the script passes the following check:

```bash
ruff check -v <script.py>
```
