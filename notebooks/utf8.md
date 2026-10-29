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
# UTF-8 encoding

In Rust, strings are encoded in UTF-8. Since not all combinations of
bytes give *valid* UTF-8 characters, Rust adds a checking algorithm to
strings in order to verify at runtime that a string or a character is
always a valid UTF-8 string or UTF-8 character.

Getting a slice from a UTF-8 string can lead to runtime errors. Here is
an example with a russian word:

```{code-cell} rust
:tags: [raises-exception]

let s = "Салам";
println!("s: {}", &s[0..1]);
```

If we use the `get()` method, we can handle error cases thanks to the
`Option<T>` value it returns. Here is our russian string again:

```{code-cell} rust
:class: seq-start badges border

let s = "Салам";
```

```{code-cell} rust
:class: seq-cont badges border

match s.get(0..1) {
  Some(t) => println!("s[0..1]: {t}"),
  None => println!("Invalid slice."),
}
```

```{code-cell} rust
:class: seq-stop badges border

match s.get(0..2) {
  Some(t) => println!("s[0..2]: {t}"),
  None => println!("Invalid slice."),
}
```
