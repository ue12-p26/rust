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

# Variable scope

A variable is only valid inside a certain *scope*. The memory occupied by
the variable's value is freed at the end of the scope.
In the following example, the *scope* is explicitly represented by curly
braces:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

{
  let x = 1;
}
```

Outside of the scope, the variable does not exist:

```{code-cell} rust
:tags: [raises-exception]

{
  let x = 1;
}
x
```
