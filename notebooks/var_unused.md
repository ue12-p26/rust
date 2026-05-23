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

# Unused variables

When a variable is declared but unused, the compiler emits a warning:

```{code-cell} rust
let x = 5;
```

If needed, this can be silenced by prefixing the variable's name with an
underscore (`_`) character as suggested by the compiler's message.
This may be useful when an implementation is not yet finalized, and we just
want to avoid too much warnings.
Example:

```{code-cell} rust
let _x = 5;
```

We could even replace the whole variable's name with a single underscore
character.
This is particulary useful when ignoring a certain value, or the returned
value of a function.
Example:

```{code-cell} rust
let _ = 5;
```
