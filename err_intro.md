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

# Introduction

:::{danger} Draft
This section is still being written.
:::

Rust distinguishes between *recoverable* and *unrecoverable* errors.
The type `Result<T, E>` is used to handle *recoverable* errors, while the
`panic!` macro handles *unrecoverable* errors by stopping the program.

Returning an error from the `main()` function:

```{code-cell} rust
:tags: [raises-exception]

use std::error::Error;
use std::fs::File;

fn main() -> Result<(), Box<dyn Error>> {
  let greeting_file = File::open("hello.txt")?;
  Ok(())
}
```
