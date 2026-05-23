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

# File I/O

:::{danger} Draft
This section is still being written.
:::

Read a whole text file:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
use std::fs;

let content = fs::read_to_string(my_file_path)
```
