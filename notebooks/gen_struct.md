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

# Generic struct

:::{danger} Draft
This section is still being written.
:::

```{code-cell} rust
struct Point<T> {
    x: T,
    y: T,
}

fn main() {
    let integer = Point { x: 5, y: 10 };
    let float = Point { x: 1.0, y: 4.0 };
}

main();
```

Use two different generic types:

```{code-cell} rust
struct Point<T, U> {
    x: T,
    y: U,
}
```
