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
let mut x = vec![1, 2, 3];

while let Some(y) = x.pop() {
  println!("y = {}", y);
}
```

We must be careful to do not write a pattern that always match, as in the
following example, since it will produce an *infinite* loop:

```rust
while let _ = 5 {
  println!("Irrefutable patterns are always true");
}
```

We may write complex patterns that helps us, for instance, to filter
values like in the folling example:

```{code-cell} rust
let mut vals = vec![2, 3, 1, 2, 2];
while let Some(v @ 1) | Some(v @ 2) = vals.pop() {
  println!("{}", v);
}
```
