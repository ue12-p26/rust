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

:::{danger} Draft
:class: readiness-draft

This section is still being written.
:::

## Borrowing a vector

We cannot modify a vector once we have a reference on it:

```{code-cell} rust
:tags: [raises-exception]

let elem = &v[i]; // immutable borrow
v.push(10); // mutable borrow ==> COMPILER ERROR!
```

## Safe access to a vector's element

Securely accessing an element with `get()`:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
let elem = v.get(0); // elem is a Option<&i32>
match elem {
  Some(elem) => println!("OK"),
  None => println!("Error"),
}
```
