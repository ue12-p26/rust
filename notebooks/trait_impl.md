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

# Implementing a trait

:::{danger} Draft
This section is still being written.
:::

```{code-cell} rust
:tags: [raises-exception]

pub struct MyStruct {
  // Some attributes
}

impl MyTrait for MyStruct {
  fn my_trait_fct(&self) -> i32 {
    // Implementation
  }
}
```

We must import the trait along the struct:

```rust
use foo::{MyStruct, MyTrait};
```
