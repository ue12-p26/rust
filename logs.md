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

# Log messages

:::{danger} Draft
This section is still being written.
:::

## Built-in debug messages

Print a debug message:

```{code-cell} rust
dbg!("My msg");
```

```{code-cell} rust
let a = 12;
dbg!(a);
```
