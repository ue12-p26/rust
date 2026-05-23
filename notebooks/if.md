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

# `if`/`else`

The [if](https://doc.rust-lang.org/std/keyword.if.html) statement allows
conditional branching of code.

Example:

```{code-cell} rust
let n = 5;
if n > 10 {
  println!("Yes");
} else if n < -20 {
  println!("Maybe");
} else {
  println!("No");
}
```

## As an expression

`if`/`else` statement can be used as an expression:

```{code-cell} rust
let n = 11;
let x = if n < 10 { 5.5 } else { -4.1 };
x
```
