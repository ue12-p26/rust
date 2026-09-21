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

# Variables and constants exercises

## Constant and variable

:::{solution} var-ex
:label: var-ex-solution
:::

```{code-cell} rust
const SIZE: u8 = 100;
let mut a = 10;
a += 2;
(SIZE, a)
```
