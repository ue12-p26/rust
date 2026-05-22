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

# `derive` macros

The `derive` macro is a *procedural* macro that generates automatically an
implementation for selected traits.

In the following example, both `Debug` and `Clone` are implemented for `User`
with generated default implementations:

```{code-cell} rust
:tags: [remove-cell]
:clear
```

```{code-cell} rust
:class: seq-start badges border
#[derive(Debug, Clone)]
struct User {
  id: u32,
  name: String,
}
```

The `Clone` trait allows us to make an explicit copy of an existing
instance:

```{code-cell} rust
:class: seq-cont badges border
let u = User { id: 12, name: String::from("John"), };
let v = u.clone();
println!("id={}, name={}", v.id, v.name);
```

And the `Debug` trait allows to automatically convert an instance into a
string and print it:

```{code-cell} rust
:class: seq-stop badges border
v
```
