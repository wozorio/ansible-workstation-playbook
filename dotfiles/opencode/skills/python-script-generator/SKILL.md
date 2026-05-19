---
name: python-script-generator
description: Standards for writing, modifying, and reviewing Python scripts. Apply whenever creating or editing a Python script to enforce consistent structure, typing, logging, and tooling.
---

# Architecture

- All logic lives in functions; no loose code in global scope (constants and initial setup are allowed).
- Every function has a single, clear responsibility.
- No private functions — no `_` prefix; all functions must be directly callable.
- **Avoid `try...except`** — use "Easier to Ask Forgiveness than Permission"/fail-fast; let exceptions propagate naturally. Only use `try...except` when exceptions are not handled implicitly by the libraries in use.
- Use `dataclasses` when a class structure is needed.

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

- All function arguments, variables, and return values must have type hints.
- Use `collections.abc` for generic types (e.g., `collections.abc.Sequence` instead of `list`).
- Every function has a concise docstring describing **only its purpose**.

# CLI

Use `click` for argument parsing. Always add the `pylint` disable comment before `main()`:

```python
if __name__ == "__main__":
    # pylint: disable=no-value-for-parameter
    main()
```

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
ruff check -v <script.py>
```
