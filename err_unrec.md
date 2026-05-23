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

# Unrecoverable errors

:::{danger} Draft
This section is still being written.
:::

The `panic!` macro is called by the system when a fatal error occurs
(e.g.: reading/writing an array past the end). But we can also call it
explicitly:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
fn main() {
  panic!("Error!");
}
```

## Disable unwinding of the stack

By default, when `panic!` is called Rust unwinds the stack and cleans up
data. This operation takes memory space at compile time, and time at
runtime.
To disable it, place the following lines into the `Cargo.toml` file:

```toml
[profile.release]
panic = 'abort'
```
