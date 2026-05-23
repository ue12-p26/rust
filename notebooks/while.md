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

# `while`

The [while](https://doc.rust-lang.org/std/keyword.while.html) statement
loops on a code block as long as a condition is `true`.

The following code loops until `n` reaches the value `10`:

```{code-cell} rust
let mut n = 1;
while n < 10 {
  print!("{n}, ");
  n += 1;
}
```

As for the `loop` statement:

- The `continue` keyword is used to skip a step.
- The `break` keyword is used to exit the loop prematurely.
- *Labels* are used to exit *nested* loops.
