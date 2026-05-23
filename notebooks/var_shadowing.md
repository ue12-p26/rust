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

# Shadowing a variable

The
[shadowing](https://doc.rust-lang.org/stable/book/ch03-01-variables-and-mutability.html#shadowing)
of a variable is an overwrite of an existing variable.
When *shadowing* a variable, we redefine the variable by reusing the same
name to define a new variable.
The definition of the new variable marks the end of scope of the previous
variable and the start of scope of the new one.
In the following example, the variable x is shadowed on the second line.
Its value is then `"abc"`, and the previous has been freed.

```{code-cell} rust
let x = 1;
println!("{x}");
let x = "abc";
println!("{x}");
```
