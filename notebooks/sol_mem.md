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

# Memory exercises

## Two ways of accessing a value by index

:::{solution} indexing-vec
:label: indexing-vec-solution
:::

The `String` struct allocates memory on the *heap* and thus does not
implement the `Copy` trait. As a consequence, indexing the vector
(`v[0]`) results in a tentative to move the value.

The compiler suggests us two solutions:

- Either *borrow* the indexed value (`&v[0]`).
- Or *clone* it (`v[0].clone()`).

```{code-cell} rust
:tags: [raises-exception]

let mut v: Vec<String> = Vec::new();
v.push(String::from("abc"));
let a = v[0];
a
```
