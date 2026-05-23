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
