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

# Generic exercises

## Generic enum

:::{solution} gen-enum
:label: gen-enum-solution
:::

To accept a different type for grey, we use two parameters `G` and `C`:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
enum Color<C, G> {
  Grey(G),
  Rgb(C, C, C),
}
```

We can then test this enum on a grey level and an RGB color:

```{code-cell} rust
:class: seq-stop badges border

let c1 = Color::<u8, u16>::Grey(0xa0b4);
let c2 = Color::<u8, u16>::Rgb(0x60, 0x70, 0x80);
(c1, c2)
```

## Generic function for getting env vars

:::{solution} gen-fct-env-var
:label: gen-fct-env-var-solution
:::

```{code-cell} rust
use std::env;
use std::str::FromStr;

fn get_env_or_default<T: FromStr>(key: &str, default: T) -> T {
  if let Ok(s) = env::var(key) {
    if let Ok(val) = s.parse::<T>() {
      val
    } else {
      default
    }
  } else {
    default
  }
}

let host: String = get_env_or_default("HOST", "localhost".to_string());
let port: u16 = get_env_or_default("PORT", 8080);

println!("Server starting on {}:{}", host, port);
```
