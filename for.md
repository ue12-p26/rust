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

# `for`

The `for` statement is a shortcut to loop on an iterator. When run on a
iterable object, it calls the `iter()` method for us.

In the following example, we use the `for` statement to iterate over an
array:

```{code-cell} rust
let a = [1, 2, 3, 4];
for n in a {
  print!("{n} ");
}
```

A range being an iterator, we can use the `for` statement on it:

```{code-cell} rust
for i in 1..=10 {
  print!("{i} ");
}
```

We may also reverse the range to iterate from higher values to lower
values, using the `rev()` method on a range:

```{code-cell} rust
for i in (1..=10).rev() {
  print!("{i} ");
}
```

As for the `loop` statement:

- The `continue` keyword is used to skip a step.
- The `break` keyword is used to exit the loop prematurely.
- *Labels* are used to exit *nested* loops.
