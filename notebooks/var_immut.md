---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# Immutability

Immutability is the default in Rust.
Trying to modify an immutable variable in Rust leads to a compiler error:

```{code-cell} rust
:tags: [raises-exception]

let x = 1;
x += 2;
x
```
