---
name: python-script-generator
description: Standards for Python scripts to enforce consistent structure, typing, logging, and tooling.
---

# Architecture

- All logic lives in functions; no loose code in global scope (constants and initial setup are allowed).
- Every function has a single, clear responsibility.
- No private functions — no `_` prefix; all functions must be directly callable.
- **Avoid `try...except`** — use "Easier to Ask Forgiveness than Permission"/fail-fast; let exceptions propagate naturally. Only use `try...except` when exceptions are not handled implicitly by the libraries in use.
- Use `dataclasses` when a class structure is needed.

# If/Else Anti-Patterns

**Arrow anti-pattern** — deeply nested `if/else` blocks. Invert conditions and return early instead.

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

**If/else return bool** — never use a conditional block to return a boolean; return the expression directly.

```python
# Bad
if x > 0:
    return True
else:
    return False

# Good
return x > 0
```

**Excessive `if/elif` chains** — replace value-mapping chains with a dictionary lookup.

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

**Boolean flags as policies** — a function that branches on multiple boolean arguments should be split into focused functions.

```python
# Bad
def notify(user, send_email: bool, send_sms: bool): ...

# Good
def notify_by_email(user): ...
def notify_by_sms(user): ...
```

**Missing or unrelated `else`** — always handle the default case explicitly; never use `else` when it has no logical relation to the `if` condition.

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

# Code Structure

- `main()` is always the **first** function defined; remaining functions are ordered by first reference.
- Imports sorted via `ruff check --select I --fix <script.py>`.
- Indentation: **4 spaces** (no tabs).
- Max line length: **125 characters**.

# Dependency Management & Shebang

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

# Typing & Docstrings

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

- Use `collections.abc` for generic types (e.g., `collections.abc.Sequence` instead of `list` for input arguments).
- Every function has a concise docstring describing **only its purpose**.

# CLI

Use `click` for argument parsing.

# Logging

**Small scripts** — use a `log` helper writing to `stderr`:

```python
import click

def log(message: str) -> None:
    """Write a message to stderr."""
    click.echo(message, err=True)
```

**Larger scripts** — use `logging` + `colorlog`:

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

# Linting

Every script must pass:

```bash
ruff check --select ALL -v <script.py>
```
