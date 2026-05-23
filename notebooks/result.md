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

# Result

:::{danger} Draft
This section is still being written.

TODO: explain `Result`.
:::

The standard library `Result<T, E>`:

```{code-cell} rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```
