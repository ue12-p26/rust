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

# Integer representation

:::{danger} Draft
- TODO: explain binary representation.
- TODO: unsigned integers: show each bit is a power of 2.
- TODO: signed integers: show each bit is a power of 2.
:::

:::{list-table} Unsigned representation
:name: tab-unsign
:header-rows: 1
:align: center

* - Binary
  - Integer
* - `00000000`
  - 0
* - `00000001`
  - 1
* - `00000010`
  - 2
* - `00000011`
  - 3
* - …
  - …
* - `11111111`
  - 255
:::

:::{list-table} Sign-magnitude representation
:name: tab-sign-magn
:header-rows: 1
:align: center

* - Binary
  - Integer
* - `00000000`
  - 0
* - `00000001`
  - 1
* - `00000010`
  - 2
* - `00000011`
  - 3
* - `01111111`
  - 127
* - `10000000`
  - -0
* - `10000001`
  - -1
* - `10000010`
  - -2
* - …
  - …
* - `11111101`
  - -125
* - `11111110`
  - -126
* - `11111111`
  - -127
:::

:::{list-table} Ones' complement representation
:name: tab-ones-compl
:header-rows: 1
:align: center

* - Binary
  - Integer
* - `00000000`
  - 0
* - `00000001`
  - 1
* - `00000010`
  - 2
* - `00000011`
  - 3
* - `01111111`
  - 127
* - `10000000`
  - -127
* - `10000001`
  - -126
* - `10000010`
  - -125
* - …
  - …
* - `11111101`
  - -2
* - `11111110`
  - -1
* - `11111111`
  - -0
:::

:::{list-table} Two's complement representation
:name: tab-twos-compl
:header-rows: 1
:align: center

* - Binary
  - Integer
* - `00000000`
  - 0
* - `00000001`
  - 1
* - `00000010`
  - 2
* - `00000011`
  - 3
* - `01111111`
  - 127
* - `10000000`
  - -128
* - `10000001`
  - -127
* - `10000010`
  - -126
* - …
  - …
* - `11111101`
  - -3
* - `11111110`
  - -2
* - `11111111`
  - -1
:::

:::{note} Wikipedia reference
See
[Signed number representations](https://en.wikipedia.org/wiki/Signed_number_representations).
:::

```{code-cell} rust
let c = -16i8;
println!("{c:b}");
let c = -16i16;
println!("{c:b}");
let c = 16i8;
println!("{c:b}");
let c = 16u8;
println!("{c:b}");
```
