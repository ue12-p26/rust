(chp-ranges)=
# Ranges

[Range expressions](https://doc.rust-lang.org/reference/expressions/range-expr.html)
allows to define integer ranges that can used:

- To loop on integers in a `for` statement.
- To take a *slice* of an object (array, string, ...).
- To match a value inside a `match` statement.

See [Match](#chp-match), [Slices](#chp-slices) and [`for`](#chp-for)
for practical usages of *ranges*.
For the moment, we just present in {numref}`tab-range-syntax` the syntax to
use when defining a range.

A [Range](https://doc.rust-lang.org/std/range/struct.Range.html) being
also an [Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html),
we may use [Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html)
methods on it like `rev()`. See {numref}`tab-iter-methods` for some
interesting iterator methods.

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

:::{list-table} Some methods of the `Iterator` trait
:name: tab-iter-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `all(f)`
  - Test if all elements satisfy the predicate `f()`.
* - `any(f)`
  - Test if any element satisfies the predicate `f()`.
* - `chain(other)`
  - Construct a new `Iterator` made of the two iterators in sequence.
* - `collect()`
  - Transform the iterator into a collection.
* - `count()`
  - Consume the iterator and return the number of iterations.
* - `cycle()`
  - Repeat endlessly.
* - `enumerate()`
  - Create a new `Iterator` of pairs `(index, element)`.
* - `filter(f)`
  - Create a new `Iterator` that filters elements according to the
    closure `f()`.
* - `for_each(f)`
  - Call the closure `f()` on each element.
* - `map(f)`
  - Create a new `Iterator` that applies a closure `f` onto each
    element.
* - `max()`
  - Return the max element.
* - `min()`
  - Return the min element.
* - `product()`
  - Multiply all elements.
* - `reduce(f)`
  - Reduce the elements using the reducing operator `f()`.
* - `rev()`
  - Reverse the iterator.
* - `skip(n)`
  - Skip the `n` first elements.
* - `step_by(n)`
  - Step by the given amount.
* - `sum()`
  - Sum the elements.
* - `take(n)`
  - Yield only the `n` first elements.
* - `unzip()`
  - Convert an iterator of pairs into a pair of containers.
* - `zip(other)`
  - Zip two iterators into an iterator of pairs.
:::
