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

# Integer overflow

:::{danger} Draft
This section is still being written.
:::

## Compile time detection

We define two 16 bit numbers such that their addition will provoke an
overflow:

```{code-cell} rust
:tags: [remove-cell]
:clear
```

```{code-cell} rust
:class: seq-start badges border
let i: u16 = 0xff00;
let j: u16 = 0x0100;
```

And we add them:

```{code-cell} rust
:tags: [raises-exception]
:class: seq-stop badges border
i + j
```

The overflow is detected at compile time.

## Runtime detection

Not all overflow are detectable at compile time. Fortunately, Rust uses
a detection mechanism at runtime in *debug* mode.

The following code compiles without error, but fails at execution:

```{code-cell} rust
:tags: [raises-exception]
fn foo(i: u16, j: u16) -> u16 {
  i + j
}

foo(0xff00, 0x0100)
```

When confronted with integer overflow (potential or desired), Rust
proposes a set of function that allows to enforce the behaviour to
apply:

- `checked_*()`: return `None` in case of overflow.
- `strict_*()`: panic in case of overflow.
- `unchecked_*()`: assume overflow cannot occur (faster), but lead to
  undefined behaviour when overflow occurs.
- `wrapping_*()`: wrap arround at boundaries, avoiding overflow.
- `saturating_*()`: saturate at boundaries, avoiding overflow.
- `overflowing_*()`: return tuple containing a result and a `bool`
  value indicating if overflow occurred.

Where `*` can be:

- `mul`: multiplication.
- `div`: division.
- `pow`: power.
- `sub`: subtraction.
- `add`: addition.
- `rem`: reminder (modulo, `%`).
- `shl`: shift left (`<<`).
- `shr`: shift right (`>>`).

In our case, we may choose to enforce saturating of the result:

```{code-cell} rust
fn foo(i: u16, j: u16) -> u16 {
  i.saturating_add(j)
}

foo(0xff00, 0x0100)
```

:::{exercise} Overflow in hash function
:label: overflow-hash
:enumerated: true

Here is a more complex example of an overflow, inside a hash function
implementing the
[MurmurHash](https://en.wikipedia.org/wiki/MurmurHash) algorithm, that
the compiler will not detect:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
fn hash(key: u64) -> u32
{
  let mut h = key;
  h ^= h >> 33;
  h *= 0xff51afd7ed558ccd;
  h ^= h >> 33;
  h *= 0xc4ceb9fe1a85ec53;
  h ^= h >> 33;

  h as u32
}
```

Try this function with value `128`, then correct it.
:::

[see solution](#overflow-hash-solution)
