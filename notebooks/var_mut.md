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

# Mutability

To make a variable *mutable* (i.e.: modifiable), we use the `mut` keyword,
as explained in
[Variables and Mutability](https://doc.rust-lang.org/stable/book/ch03-01-variables-and-mutability.html#variables-and-mutability):

```{code-cell} rust
let mut x = 1;
x += 2;
x
```
