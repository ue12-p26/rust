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

# BinaryHeap

:::{warning} To review
:class: readiness-toreview

:::

The `BinaryHeap` structure is a *max-heap*.
This type of *binary heap* is used for *priority queues*, since the
maximum value is always at the root. Popping out the max (i.e.: the
root element), re-arrange the heap so a new maximum is set at the
root.
See {numref}`fig-maxheap` for an illustration.
The property of a *max-heap* is that each parent must be greater than
its direct children. When inserting a value, it is placed in the first
available place and then moved up until to satisfy the property.

The time complexity of a *max-heap* is roughly as following:

- Getting the max value is 𝒪($1$).
- Popping out the max value is 𝒪($\log(n)$).
- Inserting a new value is 𝒪($\log(n)$).
- Building a new heap from a list of unordered values is 𝒪($n$).

:::{code-block} text
:name: fig-maxheap
:caption: An example of a max-heap

                   ┌──┐
                   │98│
                   └──┘
                  ╱    ╲
                 ╱      ╲
             ┌──┐        ┌──┐
             │41│        │76│
             └──┘        └──┘
             ╱   ╲      ╱    ╲
         ┌──┐    ┌──┐ ┌──┐  ┌──┐
         │23│    │11│ │33│  │56│
         └──┘    └──┘ └──┘  └──┘
        ╱    ╲       ╱    ╲
    ┌──┐     ┌──┐  ┌──┐  ┌──┐
    │ 5│     │10│  │25│  │17│
    └──┘     └──┘  └──┘  └──┘
:::

The main methods of the `BinaryHeap` are presented in
{numref}`tab-binaryheap`.

:::{list-table} Some methods of `BinaryHeap`
:name: tab-binaryheap
:header-rows: 1
:align: center

* - Method
  - Description
* - `append(&other)`
  - Moves the elements of another heap into this heap.
* - `clear()`
  - Removes all elements.
* - `is_empty()`
  - Returns `true` if this set contains no elements.
* - `into_vec()`
  - Consumes all the items and returns the underlying vector. Order of
    items is arbitrary.
* - `iter()`
  - Returns an iterator over all values. Order is undefined.
* - `len()`
  - Returns the number of elements.
* - `new()`
  - Creates a new binary heap.
* - `peek()`
  - Returns a reference to the greatest item.
* - `pop()`
  - Removes and returns the greatest item.
* - `push(v)`
  - Pushes a new value.
:::

## Creating a new instance

To create a new binary heap `BinaryHeap<V>`, an easy way, like for the
[Vec type](#chp-vec), is to let the compiler infer the type. Inserting
at least one value will give the compiler the information it needs:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::collections::BinaryHeap;

let mut values = BinaryHeap::new();
values.push(10);
values.push(24);
values
```

Note that objects moved into the set are either *copied* or *moved*,
depending on their type.

A `BinaryHeap` may also be created from a vector or an array:

```{code-cell} rust
:class: seq-cont badges border

let mut other_values = BinaryHeap::from([50, 4, 73, 87, 56, 33, 15]);
other_values
```

## Merging two heaps

Using the `append()` method, we can move all the items of a heap into
another:

```{code-cell} rust
:class: seq-cont badges border

values.append(&mut other_values);
values
```

## Max value

The max value is at the root node. To look at it we use the `peek()`
method:

```{code-cell} rust
:class: seq-cont badges border

values.peek()
```

If we remove it with `pop()`:

```{code-cell} rust
:class: seq-cont badges border

values.pop()
```

The heap is re-arranged:

```{code-cell} rust
:class: seq-stop badges border

values
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
