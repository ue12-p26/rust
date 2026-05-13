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

# Constant

When defining a *constant* in Rust, a type *must* be set (i.e.: there is no
inference by the compiler):

```{code-cell} rust
const N: u8 = 10;
N
```

:::{note} Book chapter
See
[Declaring Constants](https://doc.rust-lang.org/stable/book/ch03-01-variables-and-mutability.html#declaring-constants).
:::
