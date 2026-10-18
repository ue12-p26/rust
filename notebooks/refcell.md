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

# RefCell

:::{warning} To review
:class: readiness-toreview

:::

The `RefCell` pointer type implements single ownership like `Box`,
but enforces *borrowing rules* only at *runtime*.

By default the following *borrowing rules* are enforced at compile
time:

- At any given time, an object can have either *one mutable
  reference* or *any number of immutable references* (but not both).
- References must always be valid.

The implementation of `RefCell`, on the other hand, enforces these
same rules at *runtime*. This means that:

- `RefCell` allows the checking of *mutable borrow* at runtime for
  its internal value.
- `RefCell` does this while itself is *immutable*.
- `RefCell` allows *multiple immutable borrows* at the same time.
- `RefCell` allows only *one mutable borrow* at a time.
- If the *borrowing rules* are violated, a `panic!()` is issued.

:::{list-table} Some methods of RefCell
:name: tab-refcell-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `new(x)`
  - Constructs a new `RefCell` object.
* - `borrow()`
  - Returns an immutable reference `Ref` to the wrapped value.
    Multiple immutable borrows can exist at the same time. Panics if
    a mutable borrow exists.
* - `borrow_mut()`
  - Returns a mutable reference `RefMut` to the wrapped value.
    Panics if the value is already borrowed.
* - `replace(v)`
  - Replaces the wrapped value with `v`. Panics if the value is
    already borrowed.
* - `swap(other)`
  - Swaps the wrapped value with the one from `other`.
* - `take()`
  - Extracts the wrapped value, leaving the default value in its
    place. Panics if the value is already borrowed.
* - `try_borrow()`
  - Tries to immutably borrow the wrapped value. Returns an error if
    it fails.
* - `try_borrow_mut()`
  - Tries to mutably borrow the wrapped value. Returns an error if
    it fails.
:::

As an example we are going to create a `Fib` structure that computes
numbers from the Fibonacci sequence, but uses a *cache* to speed up
computing of the current request and future requests. As the
computing method `get()` should not modify anything from the
perspective of the `Fib`'s caller, it takes an immutable `self`
instance. But since it possibly needs to modify the cache, we will
use a `RefCell` for the cache. This caching technique for a function
is called
[Memoization](https://en.wikipedia.org/wiki/Memoization).

Here is the code of our `Fib` structure, we use a vector of 64-bit
integers for the cache:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::cell::RefCell;

struct Fib {
  cache: RefCell<Vec<u64>>,
}
```

The constructor initializes the cache with an empty vector:

```{code-cell} rust
:class: seq-cont badges border

impl Fib {
  fn new() -> Self {
    Fib { cache: RefCell::new(Vec::new()) }
  }
}
```

The `get()` method computes a Fibonacci value, checking if the value
is already computed and stored into the cache, or computing the
value and storing it into the cache:

```{code-cell} rust
:class: seq-cont badges border

impl Fib {
  fn get(&self, n: u64) -> u64 {

    // Stop condition
    if n < 2 { return n; }

    // Cached value
    let i = n as usize; // Convert to index
    let cached = self.cache.borrow().get(i).copied();
    if let Some(v) = cached && v != 0 {
      return v;
    }

    // Compute new value
    let v = self.get(n - 1) + self.get(n - 2);

    // Store new value
    let mut cache = self.cache.borrow_mut();
    if cache.len() <= i {
      cache.resize(i + 1, 0); // Grow the Vec so index n exists
    }
    cache[i] = v;

    // Return computed value
    v
  }
}
```

We create a new instance of `Fib`:

```{code-cell} rust
:class: seq-cont badges border

let fib = Fib::new();
```

Here is the computing of the 50th number of the Fibonacci sequence:

```{code-cell} rust
:class: seq-stop badges border

fib.get(50)
```

:::{exercise} Prime numbers (★★★☆☆)
:label: prime-numbers
:enumerated: true

Following the model of the Fibonacci example, write a prime number
program that uses a structure with a cache to compute if a number is
a prime number.

1. Implement a `PrimeChecker` structure with a `cache` field that
   uses a `RefCell`.
2. To cache the tested numbers do not use a `Vec`, since it would
   use too much space with unused slots. Use another collection,
   best suited to save space.
3. Test for instance the following numbers: 97, 100, 563.
:::

[see solution](#prime-numbers-solution)
