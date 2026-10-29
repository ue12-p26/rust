# Number systems

:::{warning} To review
:class: readiness-toreview

:::

Computers store everything, from text to photos to video, as patterns
of two states: off and on. To represent these values, we use the
base-2 numeral system called
[Binary](https://en.wikipedia.org/wiki/Binary_number), which uses two
symbols: $0$ and $1$.

The Binary system is very useful, but not practical with big numbers.
We thus use also the [Octal](https://en.wikipedia.org/wiki/Octal) and
[Hexadecimal](https://en.wikipedia.org/wiki/Hexadecimal) systems that
use *8 symbols* and *16 symbols* respectively.

## Binary system

The Binary system is a base-2 numeral system that uses $0$ and $1$ as
symbols. A Binary number is thus a composition of powers of $2$.

Example:

:::{list-table} Decimal 177 in binary
:name: tab-binary-number-example
:header-rows: 1
:align: center

* - $2^7$
  - $2^6$
  - $2^5$
  - $2^4$
  - $2^3$
  - $2^2$
  - $2^1$
  - $2^0$
* - `1`
  - `0`
  - `1`
  - `1`
  - `0`
  - `0`
  - `0`
  - `1`
:::

## Octal system

The Octal system is a base-8 numeral system that uses symbols from $0$
to $7$. An Octal number is thus a composition of powers of $8$.

Example:

:::{list-table} Decimal 12446 in octal
:name: tab-octal-number-example
:header-rows: 1
:align: center

* - $8^7$
  - $8^6$
  - $8^5$
  - $8^4$
  - $8^3$
  - $8^2$
  - $8^1$
  - $8^0$
* - `0`
  - `0`
  - `0`
  - `3`
  - `0`
  - `2`
  - `3`
  - `6`
:::

## Hexadecimal system

The Hexadecimal system is a base-16 numeral system that uses symbols
from $0$ to $9$ plus symbols from $A$ to $F$. A Hexadecimal number is
thus a composition of powers of $16$.

Example:

:::{list-table} Decimal 993312446 in hexadecimal
:name: tab-hexa-number-example
:header-rows: 1
:align: center

* - $16^7$
  - $16^6$
  - $16^5$
  - $16^4$
  - $16^3$
  - $16^2$
  - $16^1$
  - $16^0$
* - `3`
  - `B`
  - `3`
  - `4`
  - `B`
  - `E`
  - `B`
  - `E`
:::

:::{list-table} Conversion between decimal, binary, octal and hexadecimal
:name: tab-dec-bin-oct-hex-conv
:header-rows: 1
:align: center

* - Dec $10^2$
  - Dec $10^1$
  - Dec $10^0$
  - Bin $2^7$
  - Bin $2^6$
  - Bin $2^5$
  - Bin $2^4$
  - Bin $2^3$
  - Bin $2^2$
  - Bin $2^1$
  - Bin $2^0$
  - Oct $8^2$
  - Oct $8^1$
  - Oct $8^0$
  - Hex $16^1$
  - Hex $16^0$
* - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
* - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `1`
  - `0`
  - `1`
* - `0`
  - `0`
  - `2`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `0`
  - `2`
  - `0`
  - `2`
* - `0`
  - `0`
  - `3`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `1`
  - `0`
  - `0`
  - `3`
  - `0`
  - `3`
* - `0`
  - `0`
  - `4`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `0`
  - `0`
  - `4`
  - `0`
  - `4`
* - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
* - `0`
  - `0`
  - `7`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `1`
  - `1`
  - `0`
  - `0`
  - `7`
  - `0`
  - `7`
* - `0`
  - `0`
  - `8`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `8`
* - `0`
  - `0`
  - `9`
  - `0`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `1`
  - `0`
  - `1`
  - `1`
  - `0`
  - `9`
* - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
* - `0`
  - `1`
  - `6`
  - `0`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `2`
  - `0`
  - `1`
  - `0`
* - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
* - `0`
  - `3`
  - `2`
  - `0`
  - `0`
  - `1`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `4`
  - `0`
  - `2`
  - `0`
* - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
* - `1`
  - `2`
  - `7`
  - `0`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `7`
  - `7`
  - `7`
  - `F`
* - `1`
  - `2`
  - `8`
  - `1`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `0`
  - `2`
  - `0`
  - `0`
  - `8`
  - `0`
* - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
  - …
* - `2`
  - `5`
  - `5`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `1`
  - `3`
  - `7`
  - `7`
  - `F`
  - `F`
:::
