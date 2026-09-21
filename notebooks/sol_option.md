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

# Option exercises

## Returning an Option<T>

:::{solution} ret-option
:label: ret-option-solution
:::

We define `foo()` as a function that takes a `usize` as argument and
returns an `Option<bool>`. If the indices is out-of-bound, we return a
`None` value:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

fn foo(i: usize) -> Option<bool> {
  let arr = [true, false, true];
  if i >= arr.len() {
    None
  } else {
    Some(arr[i])
  }
}
```

Here are the results for indices from `0` to `4`:

```{code-cell} rust
:class: seq-stop badges border

(foo(0), foo(1), foo(2), foo(3), foo(4))
```
