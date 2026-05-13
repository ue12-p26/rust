---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Expressions

An *expression* evaluates as a value and can be one of:

- A call to a function.
- A call to a macro.
- A code block.
- An `if`/`else` statement.
- A `match` statement.
- A `loop` statement.

Here is an example in the case of a *code block* denoted by curly brackets.
The last statement does not end with a semicolon, as it is the way in Rust
to mark a return value:

```{code-cell} rust
let y = {
  let x = 1;
  x + 5
};
y
```
