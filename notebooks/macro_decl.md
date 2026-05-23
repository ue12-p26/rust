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

# Declarative macros

*Declarative* macros are used to transform an expression into another code.
They end with an exclamation mark (`!`).
In the following example, the `vec!` macro is used to create a vector of
integers:

```{code-cell} rust
let v: Vec<u32> = vec![1, 2, 3];
v
```
