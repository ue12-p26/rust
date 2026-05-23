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

# Variable definition

Variables are defined with the `let` keyword:

```{code-cell} rust
let x = 1;
x
```

In Rust, variables are typed. However, most of time, the type is inferred by
the compiler. If we wish, we may explicitly set the type of a variable:

```{code-cell} rust
let x: i16 = 1;
x
```

:::{note} `i16`
The `i16` type designate a 16 bit integer.
:::
