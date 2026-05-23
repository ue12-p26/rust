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

(chp-print)=
# Print macros

:::{danger} TODO
Show `print!`, `println!`, `eprint!`, `eprintln!`.
:::

Print a string:

```{code-cell} rust
:tags: [raises-exception]

println!("{s}");
```

Formatting a complex object using the *pretty-print* option of the
*Debug* formatter:

```{code-cell} rust
let t = (1.5, "abc", true);
println!("{t:#?}");
```
