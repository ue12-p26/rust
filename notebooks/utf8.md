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

(chp-utf8)=
# UTF-8

:::{danger} Draft
This section is still being written.

- TODO: explain UTF-8.
- TODO: explain that it is used in `str` and `String`.
- TODO: explain that this is the reason `str` has no size.
- TODO: present ASCII, extended ASCII, latin-1 & co encoding, UNICODE,
  UTF-8 encoding, character fonts, ...
- TODO: add a chapter presenting binary, octal, hexadecimal.
:::

### Getting a slice from a UTF-8 string

Compiler error:

```{code-cell} rust
:tags: [raises-exception]

let s = "Салам";
println!("s: {}", &s[0..1]);
```

Runtime error (panic):

```{code-cell} rust
:tags: [raises-exception]

let s = String::from("Салам");
println!("s: {}", &s[0..1]);
```

We use the `get()` method:

```{code-cell} rust
let s = String::from("Салам");
if let Some(t) = s.get(0..1) {
  println!("s[0..1]: {t}");
}
if let Some(t) = s.get(0..2) {
  println!("s[0..2]: {t}");
}
```
