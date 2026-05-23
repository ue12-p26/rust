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
