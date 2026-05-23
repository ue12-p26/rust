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

# Integer exercises

## Integer overflow

:::{solution} overflow-hash
:label: overflow-hash-solution
:::

The two overflowing statements must be replaced with an explicit call
to the intrinsic wrapping multiplication. This has the effect to never
overflow:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

fn hash(key: u64) -> u32
{
  let mut h = key;
  h ^= h >> 33;
  h = h.wrapping_mul(0xff51afd7ed558ccd);
  h ^= h >> 33;
  h = h.wrapping_mul(0xc4ceb9fe1a85ec53);
  h ^= h >> 33;

  h as u32
}
```

Here are the results for three integers:

```{code-cell} rust
:class: seq-stop badges border

for i in [128u64, 367u64, 1056u64] {
  println!("hash({i}): {}", hash(i));
}
```
