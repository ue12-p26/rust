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

# Using a trait as field's type

:::{danger} Draft
This section is still being written.
:::

In struct fields, `dyn` is necessary for Traits, as a trait's size
cannot be known at compile time.

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

pub struct MyStruct<'a> {
    my_field: &'a (dyn MyTrait + 'a),
}
```
