# Ranges

[Range expressions](https://doc.rust-lang.org/reference/expressions/range-expr.html)
allows to define integer ranges that can used:

- To loop on integers in a `for` statement.
- To take a *slice* of an object (array, string, ...).
- To match a value inside a `match` statement.

We will see later practical usage of *ranges* inside the dedicated chapters
for `match`, *slices* and *for*.
For the moment, we just present in {numref}`tab-range-syntax` the syntax to
use when defining a range.

:::{list-table} Range syntax
:name: tab-range-syntax
:header-rows: 1
:align: center

* - Range expression
  - Meaning
* - `1..5`
  - From 1 included to 5 excluded.
* - `1..=5`
  - From 1 to 5, both included.
* - `..5` [^a]
  - From start of object to 5 excluded.
* - `..=5` [^a]
  - From start of object to 5 included.
* - `3..` [^a]
  - From 3 included to end of object.
* - `..` [^b]
  - All indices of the whole object.
:::

[^a]: Only allowed in a *slice* or a *match*.
[^b]: Only allowed in a *slice*.
