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

# I/O

:::{danger} Draft
This section is still being written.
:::

Read a whole text file:

```rust
use std::fs;

let content = fs::read_to_string(my_file_path)
```

## Print macros

:::{danger} TODO
Show `print!`, `println!`, `eprint!`, `eprintln!`.
:::

Print a string:

```{code-cell} rust
:tags: [raises-exception]
println!("{s}");
```

Formatting a complex object using the *pretty-print* option of the
*Debug* formatter:

```{code-cell} rust
let t = (1.5, "abc", true);
println!("{t:#?}");
```
