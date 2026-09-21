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

# if/else

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

We can chain the `if`/`else` statements:

```{code-cell} rust
let s = "b";
let t = if s == "a" { (1,2) } else if s == "b" { (3,4) } else { (5,6) };
t
```
