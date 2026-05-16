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

# Bitwise AND, OR and XOR

:::{danger} Draft
This section is still being written.
:::

Example of bitwise AND:

```{code-cell} rust
let a = 0b_1000_0110;
let b = 0b_1010_1010;
let c = a & b;
println!("{c:b}");
```

Example of bitwise OR:

```{code-cell} rust
let a = 0b_1000_0110;
let b = 0b_0010_1010;
let c = a | b;
println!("{c:b}");
```

Example of bitwise XOR:

```{code-cell} rust
let a = 0b_1010_0110;
let b = 0b_0010_1010;
let c = a ^ b;
println!("{c:b}");
```
