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

# Defining a trait

:::{danger} Draft
This section is still being written.
:::

```{code-cell} rust
pub trait MyTrait {
  fn my_trait_fct(&self) -> i32;
}
```

## Default implementation

```{code-cell} rust
pub trait MyTrait {
  fn my_trait_fct(&self) -> i32 {
    0
  }
}
```
