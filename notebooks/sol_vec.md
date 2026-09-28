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

Here is a version of the vector using string slices:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let fruits = vec!["banana", "strawberry", "orange"];
```

We loop on the vector's elements using a vector's reference:

```{code-cell} rust
:class: seq-cont badges border

for fruit in &fruits {
  println!("{}", fruit.to_uppercase());
}
```

The vector still contains its elements:

```{code-cell} rust
:class: seq-stop badges border

fruits.len()
```
