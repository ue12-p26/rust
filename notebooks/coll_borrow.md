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

# Borrowing a collection

:::{warning} To review
:class: readiness-toreview

:::

We cannot modify a collection once we have a reference on it:

```{code-cell} rust
:tags: [raises-exception]

let mut v = vec![1, 2, 3];
let elem = &v[0]; // immutable borrow
v.push(10); // mutable borrow ==> COMPILER ERROR!
(elem, v)
```
