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

# String exercises

## Splitting a string

:::{solution} str-split
:label: str-split-solution
:::

The `split_whitespace()` splits a string on white spaces and returns an
*iterator* on the sub-strings:

```{code-cell} rust
let n = "a b c d e f";
for s in n.split_whitespace() {
  println!("{s}")
}
```

The more generic `split()` method does the same on a pattern (e.g.: a
string, a character, a function or a closure):

```{code-cell} rust
let n = "ab..cde..f..ghi..jk..l";
for s in n.split("..") {
  println!("{s}")
}
```

## Iterating over a string

:::{solution} str-iter
:label: str-iter-solution
:::

```{code-cell} rust
let s = "Салам";

println!("Iterating over the characters:");
for c in s.chars() {
  print!("{c}, ");
}
println!();

println!("Iterating over the bytes:");
for b in s.bytes() {
  print!("{b}, ");
}
```

Each character is defined by more than one byte.

## Searching into a string

:::{solution} str-search
:label: str-search-solution
:::

```{code-cell} rust
let s = "AbCDeFGHijkL";
let mut t = s;
while let Some(i) = t.find(char::is_lowercase) {
  print!("{}", &t[i..i+1]);
  t = &t[i+1..];
}
```
