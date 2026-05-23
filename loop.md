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

# `loop`

The [loop](https://doc.rust-lang.org/std/keyword.loop.html) statement
defines an *infinite* loop.

As an example, the following loop would never end:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

loop {
  println!("Hello!");
}
```

## `break`

Using the `break` keyword, we may leave the loop at any moment:

```{code-cell} rust
let mut i = 0;
loop {
  if i > 4 {
    break;
  }
  print!("{i}, ");
  i += 1;
}
```

The `break` keyword allows us to return a value:

```{code-cell} rust
let mut i = 0;
let n = loop {
  if i > 3 {
    break 15;
  }
  i += 1;
};
n
```

## `continue`

Using the `continue` keyword, we can also skip the current step and go to
the next:

```{code-cell} rust
let mut i = 0;
loop {
  i += 1;
  if i % 2 == 0 {
    continue;
  }
  if i > 8 {
    break;
  }
  print!("{i}, ");
}
```

## Nested loops

Exiting from nested loops is best done using a *label*:

```{code-cell} rust
let mut i = 0;
let mut j = 0;
'my_label: loop {
  i += 1;
  loop {
    j += 1;
    if i+j > 7 {
      break 'my_label;
    }
  }
}
(i, j)
```
