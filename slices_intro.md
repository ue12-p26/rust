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

# Slices

:::{danger} Draft
This section is still being written.

TODO: What are slices.
:::

A slice is a kind of reference.

String slices:

```{code-cell} rust
:tags: [raises-exception]
let s = String::from("Hello");
let slice = &s[0..2]; // from start to index 2 excluded
let slice = &s[..2]; // from start to index 2 excluded
let slice = &s[2..]; // from index 2 to end
let slice = &s[2..len]; // from index 2 to end
let slice = &s[0..len]; // whole string
let slice = &s[..]; // whole string
```

Function returning a string slice:

```{code-cell} rust
:tags: [raises-exception]
fn foo(s: &String) -> &str {
  // ...
}
```

String literals are slices, their type is `&str`.
A more generic function would take a `&str` instead of a `&String`:

```{code-cell} rust
:tags: [raises-exception]
fn foo(s: &str) -> &str {
  // ...
}
```

Array slice:

```{code-cell} rust
:tags: [raises-exception]
let a = [1, 2, 3, 4];
let slice = &a[1..3];
```
