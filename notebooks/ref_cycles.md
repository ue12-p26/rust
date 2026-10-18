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

# Reference cycles

:::{warning} To review
:class: readiness-toreview

:::

Rust protects against many memory issues thanks to its safety rules.
However it cannot protect against everything. For instance, the
`Rc` pointer is powerful to share an object through different parts
of the code, but when used with the `RefCell` pointer it may create
*reference cycles*. *Reference cycles*, once created, cannot be
removed from memory. When their variables go out of scope, they
stay in memory: they generate *memory leaks*.

## Strong cycle

Cycles are not bad by nature, but they must not be made of only
*strong* references. Instead they must contain some `Weak`
references.

To begin with, let us show how to create a *reference cycle* with
*strong* references only. First we import the pointer types:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::rc::Rc;
use std::cell::RefCell;
```

We create a `List<T>` structure that contains a `value` field and a
`next` field for chaining the next element:

```{code-cell} rust
:class: seq-cont badges border

struct List<T> {
  value: T,
  next: RefCell<Option<Rc<List<T>>>>,
}
```

We use a `RefCell` to be able to modify the `next` field even inside
an *immutable* `List<T>` object. Inside the `RefCell` we have an
`Option` value that we use as following:

- `None`: end of the list.
- `Some`: An `Rc` reference to the next `List<T>` object.

We implement a `next()` function that returns a `Some` with a new
reference to the next element or `None` for the end of the list:

```{code-cell} rust
:class: seq-cont badges border

impl<T> List<T> {

  fn next(&self) -> Option<Rc<List<T>>> {
    match *self.next.borrow() {
      Some(ref n) => Some(Rc::clone(n)),
      None => None,
    }
  }
}
```

We create a list `a` with just one element in it:

```{code-cell} rust
:class: seq-cont badges border

let a = Rc::new(List { value:-5, next: RefCell::new(None), });
```

We create a list `b` with one element, and set the next to be `a`:

```{code-cell} rust
:class: seq-cont badges border

let b = Rc::new(List { value:13, next: RefCell::new(Some(Rc::clone(&a))), });
```

We then modify the next field of the single element of `a` to point
to `b` using a new `Rc` reference on it:

```{code-cell} rust
:class: seq-cont badges border

*a.next.borrow_mut() = Some(Rc::clone(&b));
```

We have now our cycle, as shown in the following diagram:

```text
    ┌────┐
a---->│ -5 │
    └────┘
     |  ^
     |  |
     |  |
     v  |
    ┌────┐
b---->│ 13 │
    └────┘
```

We use another pointer to iterate through the list values:

```{code-cell} rust
:class: seq-cont badges border

let mut x = Rc::clone(&a);
```

We print some of the first values of this *infinite* list:

```{code-cell} rust
:class: seq-stop badges border

for _ in 0..11 {
  print!("{} --> ", x.value);
  match x.next() {
    Some(n) => x = n,
    None => break,
  }
}
println!("...");
```

## Weak references

Cycles may be useful, like for instance inside graph structures.
However they must be dropable when the variables go out of scope.
To make this possible we need to use at least one `Weak` reference
inside each cycle.

### Proof that the cycle is alive

We come back to our strong reference cycle problem from above. We
will see how a weak reference helps us see that the cycle is still
in memory. To create a *weak reference* we use the `downgrade()`
method of `Rc`. It increments the counter of weak references and
returns a `Weak` object. Here we create a weak reference on `a`:

```{code-cell} rust
:class: seq-start badges border

let c = Rc::downgrade(&a);
```

We then drop `a` and `b`:

```{code-cell} rust
:class: seq-cont badges border

drop(a);
drop(b);
```

On the `Weak` object we can call the method `upgrade()` that returns
an `Option`. If the object pointed to has been destroyed, `None` is
returned. Otherwise `Some` is returned with a strong reference `Rc`
to it.

```{code-cell} rust
:class: seq-stop badges border

match c.upgrade() {
  Some(rc) => {
    println!("The list `a` has NOT been dropped");
    println!("First value is {}", rc.value);
  },
  None => println!("The list `a` has been dropped."),
}
```

## Droppable cycle

Using one `Weak` reference inside our cycle will make it
*droppable*. To show this we need to build a special enum type that
can have either a *strong* reference or a *weak* reference.

We start by importing the reference types we need:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::rc::{Rc, Weak};
use std::cell::RefCell;
```

Then we create our generic `enum` that will be able to contain
either a *termination* (`Nil`), a *weak* reference or a *strong*
reference:

```{code-cell} rust
:class: seq-cont badges border

enum Next<T> {
  StrongLink(Rc<T>),
  WeakLink(Weak<T>),
  Nil,
}

use Next::{StrongLink, WeakLink, Nil};
```

We define our generic structure `List<T>` using the `Next<T>` enum:

```{code-cell} rust
:class: seq-cont badges border

struct List<T> {
  value: T,
  next: RefCell<Next<List<T>>>,
}
```

The `next()` method has a third case in its `match` now:

```{code-cell} rust
:class: seq-cont badges border

impl<T> List<T> {

  fn next(&self) -> Option<Rc<List<T>>> {
    match *self.next.borrow() {
      StrongLink(ref n) => Some(Rc::clone(n)),
      WeakLink(ref w) => w.upgrade(),
      Nil => None,
    }
  }
}
```

To define our cycle, we start with the `a` list:

```{code-cell} rust
:class: seq-cont badges border

let a = Rc::new(List { value:-5, next: RefCell::new(Nil), });
```

Then we define `b` with a *weak* reference on `a`:

```{code-cell} rust
:class: seq-cont badges border

let b = Rc::new(List {
  value:13,
  next: RefCell::new(WeakLink(Rc::downgrade(&a))),
});
```

Finally we change the *termination* of `a` into a *strong* reference
on `b`:

```{code-cell} rust
:class: seq-cont badges border

*a.next.borrow_mut() = StrongLink(Rc::clone(&b));
```

Here is our cycle, with one weak link (`b` on `a`) and one strong
link (`a` on `b`):

```text
    ┌────┐
a---->│ -5 │
    └────┘
     ¦  ^
     ¦  |
     ¦  |
     v  |
    ┌────┐
b---->│ 13 │
    └────┘
```

We can see the cycle is correct by printing its first elements using
the `next()` method:

```{code-cell} rust
:class: seq-cont badges border

let mut x = Rc::clone(&a);
for _ in 0..11 {
  print!("{} --> ", x.value);
  match x.next() {
    Some(n) => x = n,
    None => break,
  }
}
println!("...");
```

Let us now define a *weak* reference on `a`:

```{code-cell} rust
:class: seq-cont badges border

let c = Rc::downgrade(&a);
```

And try to drop `a` and `b`:

```{code-cell} rust
:class: seq-cont badges border

drop(a);
drop(b);
```

If we check the *weak* reference `c`, we see that `a` does not exist
anymore. The cycle has been *dropped* correctly:

```{code-cell} rust
:class: seq-stop badges border

match c.upgrade() {
  Some(rc) => {
    println!("The list `a` has NOT been dropped");
    println!("First value is {}", rc.value);
  },
  None => println!("The list `a` has been dropped."),
}
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
