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

# `while`/`let` pattern

The `while/let` pattern allows us to stay in a loop, while some matching
is `true`.

In the following example, we loop on all elements of `x`, taking them one
by one until there is no element left and `pop` returns `None`:

```{code-cell} rust
let mut i = 3..10;

while let Some(n) = i.next() {
  print!("{n} ");
}
```

We must be careful to do not write a pattern that always match, as in the
following example, since it will produce an *infinite* loop:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

while let _ = 5 {
  println!("Irrefutable patterns are always true");
}
```
