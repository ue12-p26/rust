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

# Safe access to elements

:::{warning} To review
:class: readiness-toreview

:::

## Vector

Accessing a vector's element with `get()` is safer than with the
indexing operator (`[]`). `get()` returns an `Option<T>` and uses the
`None` when the index is out of range:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
let elem = v.get(4);
match elem {
  Some(elem) => println!("Value is {elem}"),
  None => println!("Error, index is out of range."),
}
```

## Map

Like the `Vec`, maps can be accessed either with the index operator
(`[]`) or the `get()` method.

Let us construct a map:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::collections::HashMap;

let mut scores = HashMap::new();
scores.insert("Paul", 15);
scores.insert("John", 20);
```

The index operator will return the value directly:

```{code-cell} rust
:class: seq-cont badges border

scores["Paul"]
```

The `get()` method will return an `Option<T>`:

```{code-cell} rust
:class: seq-stop badges border

scores.get("Paul")
```

However if the key is unknown the index operator will *panic*:

```{code-cell} rust
:tags: [raises-exception]

let mut scores = std::collections::HashMap::new();
scores.insert("Paul", 15);
scores["John"]
```
