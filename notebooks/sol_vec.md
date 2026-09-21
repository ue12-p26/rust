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

# Vector exercises

## Iterating over a vector's items

:::{solution} vec-iter
:label: vec-iter-solution
:::

`str` has no `capitalize()` method, so we write a small helper function
that uppercases the first character of a string slice and appends the
rest unchanged:

```{code-cell} rust
fn capitalize(s: &str) -> String {
  let mut chars = s.chars();
  match chars.next() {
    None => String::new(),
    Some(first) => first.to_uppercase().collect::<String>() + chars.as_str(),
  }
}

let fruits: Vec<&str> = vec!["banana", "strawberry", "orange"];
for fruit in &fruits {
  println!("{}", capitalize(fruit));
}
```
