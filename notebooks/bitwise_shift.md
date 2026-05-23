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

# Bitwise shift

:::{danger} Draft
TODO: explain right shift is a division by 2 and left shift a
multiplication.
:::

Examples of right shift:

```{code-cell} rust
(16u8 >> 3, 16i8 >> 3, -16i8 >> 3)
```

```{code-cell} rust
let c = -16i8 >> 3;
println!("{c:b}");
let c = 16i8 >> 3;
println!("{c:b}");
let c = 16u8 >> 3;
println!("{c:b}");
```
