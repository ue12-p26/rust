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

# `?` operator

:::{danger} Draft
This section is still being written.
:::

The `?` operator is used to propagate a `Result<T, E>` or an
`Option<T>`.

Example:

```{code-cell} rust
fn last_char_of_first_line(text: &str) -> Option<char> {
    text.lines().next()?.chars().last()
}
```
