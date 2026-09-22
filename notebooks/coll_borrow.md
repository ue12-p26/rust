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

# Accessing & borrowing collections

:::{warning} To review
:class: readiness-toreview

:::

## Borrowing a vector

We cannot modify a vector once we have a reference on it:

```{code-cell} rust
:tags: [raises-exception]

let elem = &v[i]; // immutable borrow
v.push(10); // mutable borrow ==> COMPILER ERROR!
```

## Safe access to a vector's element

Accessing a vector's element with `get()` is safer than with the
indexing operator (`[]`). `get()` returns an `Option<T>` and uses the
`None` when the index is out-of-range:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
let elem = v.get(4);
match elem {
  Some(elem) => println!("Value is {elem}"),
  None => println!("Error, out-of-range."),
}
```
