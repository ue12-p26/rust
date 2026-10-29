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

# Byte string

A byte string is a pure *slice of bytes* (i.e.: `&[u8]`):

```{code-cell} rust
let bytes = b"abc"; // Type is &[u8; 3]
bytes
```
