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

# Rc

:::{warning} To review
:class: readiness-toreview

:::

`Rc` is a *Reference-Counted Smart Pointer*. While a `Box` object is
restricted to one owner only at a time, an `Rc` object can have
*multiple owners*. This is made possible because `Rc` keeps track of
the number of owners, and *drops* the object it points to only when
the count reaches *zero*. `Rc` provides static methods to create new
owners (through the `clone()` method) and get counts of the
references. See {numref}`tab-rc-methods`.

As an example, let us use an `Rc` object on an integer:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::rc::Rc;

let a = Rc::new(10);
Rc::strong_count(&a)
```

As we can see the number of references is 1, which is normal since
only the variable `a` owns this `Rc`.

Now let us define another owner:

```{code-cell} rust
:class: seq-cont badges border

let b = Rc::clone(&a);
Rc::strong_count(&a)
```

The reference count is now 2.

We can check that both owners have access to the same value:

```{code-cell} rust
:class: seq-cont badges border

(*a, *b)
```

Now if we drop `a`, the count decreases:

```{code-cell} rust
:class: seq-cont badges border

drop(a);
Rc::strong_count(&b)
```

But the value is still accessible through `b`:

```{code-cell} rust
:class: seq-stop badges border

*b
```

:::{list-table} Some methods of Rc
:name: tab-rc-methods
:header-rows: 1
:align: center

* - Method
  - Description
* - `new(x)`
  - Constructs a new `Rc` object.
* - `clone(&rc)`
  - Clones the `Rc` object, increasing the *strong* reference count.
* - `downgrade(&rc)`
  - Returns a `Weak` pointer to the contained object and increases
    the *weak* reference count.
* - `strong_count(&rc)`
  - Returns the current number of *strong* pointers to the `Rc`
    object.
* - `weak_count(&rc)`
  - Returns the current number of *weak* pointers to the `Rc`
    object.
:::

:::{exercise} Shared lists (★★★☆☆)
:label: shared-lists
:enumerated: true

Use the `Rc` type to improve the list example in
[Recursive type](#chp-box-recursive) in order to be able to define
lists that share other lists as sub-lists. For instance, we want to
be able to create lists as in the following diagram:

```text
  ┌──┐   ┌──┐
a │ 7│──>│14│
  └──┘   └──┘
            ╲
             🡖
      ┌──┐   ┌──┐   ┌──┐
    b │-2│──>│ 5│──>│17│
      └──┘   └──┘   └──┘
      🡕
     ╱
  ┌──┐
c │27│
  └──┘
```
:::

[see solution](#shared-lists-solution)
