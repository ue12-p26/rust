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

# Function-like macros

The *function-like* macros are a type of *procedural* macros that look like
function calls.
They can, however, accept an unknown number of arguments.
Like the *declarative* macros they end with an exclamation mark (`!`).
A list of the main *function-like* macros is provided in
{numref}`tab-macro-fct-like`.

Example with the `println!` macro:

```{code-cell} rust
println!("Good morning.");
```

The same macro can accept additional arguments:

```{code-cell} rust
let name = "John";
println!("Good morning, {}.", name);
```
