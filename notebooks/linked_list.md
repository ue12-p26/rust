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

# LinkedList

:::{warning} To review
:class: readiness-toreview

:::

The `LinkedList` structure is a *doubly-linked* list as shown in
{numref}`fig-linked-list`.
It allows appending or removal, in constant time (i.e.: 𝒪(1)), of
elements at each end.
Searching for an element is in 𝒪(n), since it requires to iterate over
the list.

:::{warning} LinkedList vs Vec
A `Vec` or `VecDeque` is in general preferred to a `LinkedList`
because vectors are implemented as arrays (i.e.: contiguous memory in
which elements are stored in order) and thus:

- Are faster to access.
- Use less memory.
- Make a better use of CPU cache.

However a `LinkedList` will always offer a 𝒪(1) performance for push
operations, which vectors will trigger 𝒪(n) copy operation when they
need to grow.
:::

:::{code-block} text
:name: fig-linked-list
:caption: A doubly-linked list

                 ┌────┐     ┌────┐     ┌────┐     ┌────┐
push_front() ──> │    │ ──> │    │ ──> │    │ ──> │    │ <── push_back()
   O(1)          │ 10 │     │  5 │     │ 47 │     │ 13 │        O(1)
 pop_front() <── │    │ <── │    │ <── │    │ <── │    │ ──>  pop_back()
                 └────┘     └────┘     └────┘     └────┘
:::

Main methods of the `LinkedList` structure can be seen in
{numref}`tab-linked-list`.

:::{list-table} Some methods of `LinkedList`
:name: tab-linked-list
:header-rows: 1
:align: center

* - Method
  - Description
* - `append(&other)`
  - Moves all elements from another `LinkedList` into this one.
* - `back()`
  - Provides a reference to the back element.
* - `clear()`
  - Removes all elements.
* - `contains(v)`
  - Returns `true` if this list contains the value `v`. 𝒪(n) time.
* - `front()`
  - Provides a reference to the front element.
* - `is_empty()`
  - Returns `true` if this list contains no elements.
* - `iter()`
  - Returns a front-to-back iterator.
* - `len()`
  - Returns the number of elements.
* - `new()`
  - Creates a new list.
* - `pop_back()`
  - Removes the back element and returns it.
* - `pop_front()`
  - Removes the front element and returns it.
* - `push_back(v)`
  - Appends an element to the back.
* - `push_front(v)`
  - Appends an element to the front.
* - `split_off(i)`
  - Splits the list into two at the given index. The current list is
    cut at the splitting point, and another list containing the
    remaining values is returned.
:::

## Creating a new instance

To create a new linked list `LinkedList<V>`, an easy way, like for the
[Vec type](#chp-vec), is to let the compiler infer the type. Inserting
at least one value will give the compiler the information it needs:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::collections::LinkedList;

let mut names = LinkedList::new();
names.push_back(String::from("Paul"));
names.push_back(String::from("John"));
```

A `LinkedList` may also be created from a vector or an array:

```{code-cell} rust
:class: seq-cont badges border

let mut other_names = LinkedList::from([
  "George".to_string(),
  "Ringo".to_string(),
]);
other_names
```

## Concatenating

To concatenate two lists we used the `append()` method that adds
elements from a list to the current one:

```{code-cell} rust
:class: seq-cont badges border

names.append(&mut other_names);
names
```

## Pushing & removing

We can push back or front an element in the list:

```{code-cell} rust
:class: seq-cont badges border

names.push_front(String::from("Paul"));
names
```

And also remove elements using the `pop_*()` methods:

```{code-cell} rust
:class: seq-cont badges border

names.pop_back()
```

## Searching

Searching inside a list must be made using an iterator.

The `position()` method of the `Iterator` trait searches for a value
and returns the found index:

```{code-cell} rust
:class: seq-cont badges border

names.iter().position(|x| x == "George")
```

The `find()` method of the `Iterator` trait searches for a value and
returns it:

```{code-cell} rust
:class: seq-cont badges border

names.iter().find(|&x| x == "John")
```

The `find()` method takes a reference, and `iter()` iterates over
references, thus we get double references for elements.
One way is to explicitly write the double reference with the variable
declaration inside the closure. This way we can use the variable
directly:

```{code-cell} rust
:class: seq-cont badges border

let l = std::collections::LinkedList::from([10, 50, 8, 4]);
l.iter().find(|&&x| x == 8)
```

Another solution is to write only one reference and use the
*dereference* operator `*`:

```{code-cell} rust
:class: seq-cont badges border

l.iter().find(|&x| *x == 8)
```

## Splitting

The `split_off()` method cuts a list into two parts at an index. The
current list is cut at the index, while the second part becomes a new
list that is returned by the method:

```{code-cell} rust
:class: seq-stop badges border

(names.split_off(2), names)
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
