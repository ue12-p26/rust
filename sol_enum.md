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

# Enum exercises

## Nuts price

:::{solution} variable-price
:label: variable-price-solution
:::

```{code-cell} rust
fn new_price(m: f32, x: f32) -> f32 {
  match m {
       ..1.0 => 1.2 * x,
    1.0..2.0 => x,
    2.0..4.0 => 0.8 * x,
        _    => 0.5 * x,
  }
}

let mass_prices = [(0.3, 3.4), (1.2, 2.7), (2.0, 2.9), (4.0, 3.2)];
for (m, x) in mass_prices {
  print!("{}, ", new_price(m, x));
}
```
