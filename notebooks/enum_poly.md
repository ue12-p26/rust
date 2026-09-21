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

# Polymorphism using enums

:::{danger} Draft
This section is still being written.
:::

We can store miscellaneous types inside a vector, using an enum.
This works because an enum defines all its values as variants.

```{code-cell} rust
enum MyEnum {
  AnInt(i8),
  ABool(bool),
  AFloat(f32),
}

let my_vec = vec![
  MyEnum::AnInt(10),
  MyEnum::ABool(false),
  MyEnum::AFloat(5.6),
];
```
