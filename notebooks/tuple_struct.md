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

# Tuple struct

In *tuple structs*, the fields are *not* named but *indexed*.

As an example, here is a `Color` tuple struct that defines an RGB color
on 8-bit values. The declaration uses parenthesis instead of curly
braces:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Color(u8, u8, u8);
```

For defining an instance we use also parenthesis and specify the values
in the order of definition:

```{code-cell} rust
:class: seq-cont badges border

let yellow = Color(0xff, 0xff, 0);
```

To access values from an instance, we use integer *indices*:

```{code-cell} rust
:class: seq-stop badges border

println!("red={}, green={}, blue={}", yellow.0, yellow.1, yellow.2);
```
