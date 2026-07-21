---
name: python-script-generator
description: "Standards and conventions for Python scripts — structure, typing, logging, tooling, and if/else anti-patterns. Use when creating, updating, or reviewing any Python CLI/automation script, or enforcing the Python style guide."
---

## Architecture

- All logic lives in functions; no loose code in global scope (constants and initial setup are allowed).
- Every function has a single, clear responsibility.
- No private functions — no `_` prefix; all functions must be directly callable.
- **Prefer fail-fast over `try...except`** — use "Easier to Ask Forgiveness than Permission"; let exceptions propagate naturally. Only use `try...except` when exceptions are not handled implicitly by the libraries in use.
- Use `dataclasses` when a class structure is needed.

## If/Else Anti-Patterns

### Arrow anti-pattern

Deeply nested `if/else` blocks. Invert conditions and return early instead.

```python
# Bad
def process(data):
    if data:
        if data.is_valid():
            if not data.is_expired():
                return data.value

# Good
def process(data):
    if not data:
        return None
    if not data.is_valid():
        return None
    if data.is_expired():
        return None
    return data.value
```

### If/else return bool

Never use a conditional block to return a boolean; return the expression directly.

```python
# Bad
if x > 0:
    return True
else:
    return False

# Good
return x > 0
```

### Excessive `if/elif` chains

Replace value-mapping chains with a dictionary lookup.

```python
# Bad
if command == "start":
    action = start
elif command == "stop":
    action = stop
elif command == "restart":
    action = restart

# Good
COMMANDS: dict[str, Callable] = {"start": start, "stop": stop, "restart": restart}
action = COMMANDS[command]
```

### Boolean flags as policies

A function that branches on multiple boolean arguments should be split into focused functions.

```python
# Bad
def notify(user, send_email: bool, send_sms: bool): ...

# Good
def notify_by_email(user): ...
def notify_by_sms(user): ...
```

### Missing or unrelated `else`

Always handle the default case explicitly; never use `else` when it has no logical relation to the `if` condition.

```python
# Bad
if status == "active":
    process()
else:
    # unrelated cleanup that always runs
    cleanup()

# Good
if status == "active":
    process()
cleanup()
```

## Code Structure

- `main()` is always the **first** function defined; if a `log()` helper exists, it is the **second**; remaining functions are ordered by first reference.
- `main()` is invoked from the standard entrypoint guard at the end of the file:

```python
if __name__ == "__main__":
    main()
```

- Imports sorted via `ruff check --select I --fix <script.py>`.
- Indentation: **4 spaces** (no tabs).
- Max line length: **125 characters**.

## Dependency Management & Shebang

Use `uv` for dependencies. Every script starts with this block (no pinned versions):

```python
#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = [
#     "click",
#     "colorlog",
#     "requests",
# ]
# ///
```

## Typing & Docstrings

- All function arguments and return values must have type hints.
- Rely on Type Inference for Variables: Do not explicitly specify types for local variables during assignment when the type can be automatically inferred. Only use explicit type hints on variables when initializing an empty collection or when the inferred type is ambiguous.

```python
# Bad
user_count: int = 0
api_url: str = "https://api.example.com"
results: list[int] = [1, 2, 3]

# Good
user_count = 0
api_url = "https://api.example.com"
results = [1, 2, 3]
processed_ids: list[str] = []  # Allowed: Type cannot be inferred from an empty list
```

- Use concrete types in input arguments (e.g., `list` instead of `collections.abc.Sequence`, `dict` instead of `collections.abc.Mapping`). Prefer strict types over generic ABCs so the expected shape is unambiguous; reach for an ABC only when deliberately accepting any matching iterable/collection.
- Every function has a concise docstring describing **only its purpose**.
- The script must have **no module-level docstring**. `main()` carries that documentation instead — its docstring describes what the script does, taking the place of a module docstring.

## CLI

Use `click` for argument parsing.

## Logging

### Small scripts

Use a `log` helper writing to `stderr`. Pick the implementation based on whether `click` is already in use for argument parsing; do not add `click` solely for logging.

### With `click`

Script already uses it for argument parsing:

```python
import click

def log(message: str) -> None:
    """Write a message to stderr."""
    click.echo(message, err=True)
```

### Without `click`

No argument parsing — use the standard library:

```python
import sys

def log(message: str) -> None:
    """Write a message to stderr."""
    print(message, file=sys.stderr)
```

### Larger scripts

Use `logging` + `colorlog`:

```python
import logging
from colorlog import ColoredFormatter

logger = logging.getLogger(__name__)

def setup_logging() -> None:
    """Set up a custom logger."""
    handler = logging.StreamHandler()
    formatter = ColoredFormatter(
        "%(log_color)s%(asctime)s %(levelname)-8s%(reset)s %(blue)s%(message)s",
        datefmt="%Y-%m-%dT%H:%M:%S%z",
        reset=True,
        log_colors={"DEBUG": "cyan", "INFO": "green", "WARNING": "yellow", "ERROR": "red"},
        style="%",
    )
    handler.setFormatter(formatter)
    logger.addHandler(handler)
    logger.setLevel("INFO")
```

## Linting

Every script must pass **pycodestyle errors (`E`) and Pyflakes (`F`)** via ruff:

```bash
ruff check --select E,F -v <script.py>
```

Only these two rule categories are enforced. Broader rule sets (`ALL`, `UP`, `B`, etc.) are intentionally not enabled.

Additionally, ensure imports are sorted (handled separately):

```bash
ruff check --select I --fix <script.py>
```

## Canonical Minimal Script

A small script using `click` for argument parsing. Use this as the starting point and extend as needed.

```python
#!/usr/bin/env -S uv run --script
#
# /// script
# requires-python = ">=3.12"
# dependencies = ["click"]
# ///

import click

def main() -> None:
    """Send a friendly greeting to a name."""
    name = click.prompt("Name", type=str)
    log(greet(name))


def log(message: str) -> None:
    """Write a message to stderr."""
    click.echo(message, err=True)


def greet(name: str) -> str:
    """Return a greeting for the given name."""
    return f"Hello, {name}!"


if __name__ == "__main__":
    main()
```

For a script without argument parsing, replace `click.prompt(...)` with whatever input source applies (env vars, `sys.argv`, none).
