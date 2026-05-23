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

# Closures

:::{danger} Draft
This section is still being written.
:::

## Difference with functions

The following closure definition is allowed:

```{code-cell} rust
:tags: [raises-exception]

let x = 4;
let equal_to_x = |z| z == x;
```

while the following function definition is forbidden (`x` is not visible
from inside the function's body):

```{code-cell} rust
:tags: [raises-exception]

let x = 4;
fn equal_to_x(z: i32) -> bool { z == x }
```
