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

(chp-cmdlineargs)=
# Command line arguments

:::{warning} To review
:class: readiness-toreview

:::

:::{danger} TODO
:class: readiness-todo

`args()` and `args_os()`.
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
