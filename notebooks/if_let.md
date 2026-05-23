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

# `if`/`let`

The `if/let` statement is a concise way to treat the case of a value
matching one pattern only.

In the following example the code block of the `if/let` statement is only
executed if `x` is a `Some`:

```{code-cell} rust
let x = Some(10u8);
if let Some(v) = x {
  println!("My value is {v}");
}
```

:::{note} Equivalent `match` statement
We may have written the same code using a `match`, however it is a bit
longer since we must ignore explicitly all other case:

```{code-cell} rust
let x = Some(10u8);
match x {
  Some(v) => println!("My value is {v}"),
    _     => (),
}
```

:::

## `let`/`else`

The `let/else` control flow works the other way, letting us match a value
and run a code block when it does not match:

```{code-cell} rust
fn foo(x: Option<u8>) -> Option<u8> {
  let Some(v) = x else {
    return None;
  };
  Some(2 * v)
}

(foo(Some(10u8)), foo(None))
```

## `if`/`let`/`else`

The `if/let/else` expression returns a value, using two different
expressions depending on a value matching:

```{code-cell} rust
let x = Some(10u8);
let y = if let Some(v) = x { Some(2 * v) } else { None };
y
```

:::{warning} Same return type
Note the usage `Some(...)` inside the `if` block. This is compulsory
because we return a `None` in the `else` block, hence the return type
must be an `Option<T>`.
Both `if` and `else` blocks must return the same value type otherwise
the compiler will fail:

```{code-cell} rust
:tags: [raises-exception]

let x = Some(10u8);
let y = if let Some(v) = x { 2 * v } else { None };
y
```

:::
