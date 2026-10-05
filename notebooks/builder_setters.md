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

# Builder setters (instance methods)

In Rust, it is no possible to define default values in methods and
functions. This implies that in a constructor method we cannot make
optional the setting of certain fields. To be able to set default values
to fields and still allow the user to easily set his/her own values
while building a new object, we need another mechanism called *Builder
Setters*. The convention in Rust is to name those methods using the
`with_` prefix. The idea is to chain one more `with_...()` methods after
the call to the constructor `new()`. Each method takes ownership of the
object, modifies it and returns it.

Example:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

let color = Color::new(0x00, 0xff, 0x50)
  .with_transparency(60)
  .with_blinking(true);
```

:::{exercise} Postal Mail (★★☆☆☆)
:label: postal-mail
:enumerated: true

1. Define a new `struct` named `Mail` that defines a postal mail.
2. Define the following fields:
   - `recipient`: string.
   - `sender`: string.
   - `weight`: float.
   - `priority`: boolean.
3. Implement the following methods:
   - A constructor that takes the `recipient` and the `sender`, only.
   - A builder setter for the `weight` field.
   - A builder setter for the `priority` field.
4. Create an instance of the `Mail` struct and print the values of all
   fields.
:::

[see solution](#postal-mail-solution)
