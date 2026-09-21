(chp-iter-methods)=
# Iterator methods

We list here some of the methods of the `Iterator` trait. See
[Iterator](https://doc.rust-lang.org/std/iter/trait.Iterator.html).

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
