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

# Pointer exercises

## Type size

:::{solution} box-struct-size
:label: box-struct-size-solution
:::

The size of the `Book` type can be computed by adding the type size
of each field. We suppose we are on a 64-bit system:

- `String`: A `String` stores a string on the *heap*, and is itself
  made of a *pointer*, a *capacity* and a *size* (one word, so 64
  bits, each). Its size is thus 24 bytes.
- `Vec<String>`: A `Vec` object stores its data inside an array on the
  *heap*, and is itself made of a *pointer*, a *capacity* and a
  *size* (64 bits each). Its size is thus 24 bytes.
- `u64`: 8 bytes.
- `i16`: 2 bytes.
- `usize`: 64 bits, thus 8 bytes.
- `f32`: 4 bytes.

In total the fields of the `Book` type add up to
$24 * 4 + 8 + 2 + 8 + 4 = 118$ bytes (three `String` fields plus the
`Vec<String>` one). Since the type must be aligned on 8 bytes, the
compiler adds some padding and an instance of the `Book` type occupies
120 bytes, as reported by `std::mem::size_of::<Book>()`.

## Deref implementation

:::{solution} deref-impl
:label: deref-impl-solution
:::

Here is the generic tuple structure:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct MyBox<T>(T);
```

We implement the `new()` constructor that takes a `T`:

```{code-cell} rust
:class: seq-cont badges border

impl<T> MyBox<T> {
  fn new(x: T) -> MyBox<T> {
    MyBox(x)
  }
}
```

The `Deref` trait is implemented by returning a *reference to the
first value of the tuple* inside the `deref()` method:

```{code-cell} rust
:class: seq-cont badges border

use std::ops::Deref;

impl<T> Deref for MyBox<T> {
  type Target = T;

  fn deref(&self) -> &Self::Target {
    &self.0
  }
}
```

We use `MyBox` to create a reference/pointer to a variable `x`:

```{code-cell} rust
:class: seq-cont badges border

let x = 5;
let y = MyBox::new(x);
```

Using the dereferencing operator, we can print the value pointed to
by `y`:

```{code-cell} rust
:class: seq-stop badges border

*y
```

This exercise is taken from the Rust official book. See
[Defining Our Own Smart Pointer](https://doc.rust-lang.org/book/ch15-02-deref.html#defining-our-own-smart-pointer).

## Shared lists

:::{solution} shared-lists
:label: shared-lists-solution
:::

Let us import the `Rc` type:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::rc::Rc;
```

We define `List` using `Rc` instead of `Box`:

```{code-cell} rust
:class: seq-cont badges border

enum List<T> {
  Val(T, Rc<List<T>>),
  Nil,
}
```

Let us import the variants of `List`:

```{code-cell} rust
:class: seq-cont badges border

use List::{Val, Nil};
```

We implement a `print()` that we will use to print the content of a
list:

```{code-cell} rust
:class: seq-cont badges border

impl<T> List<T>
  where T: std::fmt::Debug {

  fn print(&self) {
    match self {
      Val(x, next) => {
        print!("({x:?}, ");
        next.print();
        print!(")");
      },
      Nil => print!("Nil"),
    }
  }
}
```

We first create a list `x` with two values:

```{code-cell} rust
:class: seq-cont badges border

let x = Rc::new(Val(5, Rc::new(Val(17, Rc::new(Nil)))));
```

We define lists `a` and `b` with `x` as a sub-list for both, and the
list `c` that uses `b` as a sub-list:

```{code-cell} rust
:class: seq-cont badges border

let a = Rc::new(Val(7, Rc::new(Val(14, Rc::clone(&x)))));
let b = Rc::new(Val(-2, Rc::clone(&x)));
let c = Rc::new(Val(27, Rc::clone(&b)));
```

We can check the reference count of `x` and `b`:

```{code-cell} rust
:class: seq-cont badges border

(Rc::strong_count(&x), Rc::strong_count(&b))
```

Here is list `a`:

```{code-cell} rust
:class: seq-cont badges border

a.print();
println!();
```

List `b`:

```{code-cell} rust
:class: seq-cont badges border

b.print();
println!();
```

List `c`:

```{code-cell} rust
:class: seq-stop badges border

c.print();
println!();
```

## Prime numbers

:::{solution} prime-numbers
:label: prime-numbers-solution
:::

We import the needed structures:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::cell::RefCell;
use std::collections::HashMap;
```

We define a checker structure, that stores the *tested numbers* into
a *map*:

```{code-cell} rust
:class: seq-cont badges border

struct PrimeChecker {
  cache: RefCell<HashMap<u64, bool>>,
}
```

We define the constructor that initializes an empty map:

```{code-cell} rust
:class: seq-cont badges border

impl PrimeChecker {

  fn new() -> Self {
    PrimeChecker {
      cache: RefCell::new(HashMap::new()),
    }
  }
}
```

The `is_prime()` method is the main entry point of our structure. It
uses the cache to check if the number has already been tested, and
otherwise delegates to the `trial_division()` method, that finds out
if a number is a prime number:

```{code-cell} rust
:class: seq-cont badges border

impl PrimeChecker {

  fn is_prime(&self, n: u64) -> bool {

    // Access cache
    let cached = self.cache.borrow().get(&n).copied();
    if let Some(is_prime) = cached {
      return is_prime;
    }

    // Compute
    let is_prime = Self::trial_division(n);

    // Store answer
    self.cache.borrow_mut().insert(n, is_prime);

    // Return result
    is_prime
  }

  fn trial_division(n: u64) -> bool {

    // Easy checks
    if n < 2 { return false; }
    if n % 2 == 0 { return n == 2; }

    // Loop on odd numbers
    let mut i = 3;
    while i * i <= n {
      if n % i == 0 { return false; }
      i += 2;
    }

    true
  }
}
```

We instantiate a checker:

```{code-cell} rust
:class: seq-cont badges border

let checker = PrimeChecker::new();
```

And test it on some numbers:

```{code-cell} rust
:class: seq-stop badges border

for n in [97, 100, 563] {
  println!("{n} is{} prime.", if checker.is_prime(n) {""} else {" not"});
}
```
