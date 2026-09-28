# Introduction

The *bitwise* operations operate on the *binary* level of a value instead
of the value itself. Said otherwise, the *bitwise* operators act on the
individual *bits* that compose a value. To understand how they work, we
must first look at the *binary* representation of integers. We will then
show what the available *bitwise* operators and how to use them.

*Bitwise* operators are listed in {numref}`tab-bitwise-op`.

:::{list-table} Bitwise operators
:name: tab-bitwise-op
:header-rows: 1
:align: center

* - Operator
  - Description
* - `!`
  - Bitwise complement
* - `&`
  - Bitwise AND
* - `|`
  - Bitwise OR
* - `^`
  - Bitwise XOR
* - `<<`
  - Left Shift
* - `>>`
  - Right Shift [^d]
:::

[^d]: *Arithmetic* right shift on signed integer types, *logical* right
    shift on unsigned integer types.
