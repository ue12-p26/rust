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

# Command line arguments

:::{danger} Draft
This section is still being written.
:::

Getting all arguments:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

use std::env;

fn main() {
  let args: Vec<String> = env::args().collect();
}
```

## Clap

Add with derive feature:

```bash
cargo add clap --features derive
```
