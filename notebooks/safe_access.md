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

# Safe access to elements

:::{warning} To review
:class: readiness-toreview

:::

## Vector

Accessing a vector's element with `get()` is safer than with the
indexing operator (`[]`). `get()` returns an `Option<T>` and uses the
`None` when the index is out of range:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
let elem = v.get(4);
match elem {
  Some(elem) => println!("Value is {elem}"),
  None => println!("Error, index is out of range."),
}
```

## Map

:::{danger} TODO
:class: readiness-todo

Show that `get()` is better than `[]` in the same way used for `Vec`.
:::
