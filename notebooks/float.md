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

# Floats

The
[Floating-Point Types](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#floating-point-types)
are available in 32 (`f32`) and 64 bits (`f64`).

{numref}`tab-float-op` presents the available floating-point operators.

## Default type

The default type for floats is `f64`:

```{code-cell} rust
let x = 10.0; // Default type: f64
x
```

## Specifying the type

As for integers, the type can be set either to the variable or the value:

```{code-cell} rust
let x: f32 = 3.0;
let y = 3.0f32;
(x, y)
```

## Operations

Example of computing a remainder:

```{code-cell} rust
34.56 % 3.6
```

A division:

```{code-cell} rust
34.56 / 3.6
```
