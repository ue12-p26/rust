# Integer operators

:::{list-table} Arithmetic operators
:name: tab-arith-op
:header-rows: 1
:align: center

* - Operator
  - Description
* - `+`
  - Addition
* - `-`
  - Subtraction
* - `*`
  - Multiplication
* - `/`
  - Division [^a] [^b]
* - `%`
  - Remainder [^c]
:::

[^a]: Rounded towards zero.
[^b]: Division by zero panics.
[^c]: Rust uses a remainder defined with truncating division. Given
    *remainder = dividend % divisor*, the `remainder` will have the same
    sign as the `dividend`.

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
