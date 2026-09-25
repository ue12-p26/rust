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

# HashSet

:::{warning} To review
:class: readiness-toreview

:::

The `HashSet` structure is a *set* that uses a *hashing* algorithm to
store unique values.
A *set* is a data structure that stores values using a *hashing*
algorithm, like the [HashMap](#chp-hashmap). See {numref}`fig-hashset`.
Its performance is the same as the `HashMap`, see the
[Performance note](#hashmap-performance) about it.

:::{code-block} text
:name: fig-hashset
:caption: An example of a `HashSet`

Buckets
  │
  ▼
┌────┐
│  0 │
├────┤     ┌───┬───┬───┐
│  1 │ ──> │"a"│"g"│"z"│
├────┤     └───┴───┴───┘
│  2 │
├────┤
│  3 │
├────┤     ┌───┐
│  4 │ ──> │"k"│
├────┤     └───┘
│  5 │
├────┤     ┌───┬───┐
│  6 │ ──> │"b"│"t"│
├────┤     └───┴───┘
│  7 │
└────┘
:::

To be usable inside a `HashSet` the values must have a type that
implements the traits `Eq` and `Hash`. Moreover it must verify:

$$v1 = v2 \Rightarrow hash(v1) = hash(v2)$$

The main methods of the `HashSet` are presented in
{numref}`tab-hashset`.

:::{warning} Important features
The most important features of a set are:

- No duplicated values.
- Combining methods:
  - `difference(&other)`: $A \setminus B$.
  - `intersection(&other)`: $A \cap B$.
  - `symmetric_difference(&other)`: $A \triangle B$.
  - `union(&other)`: $A \cup B$.
- Comparing methods:
  - `is_disjoint(&other)`: $A \cap B = \emptyset$.
  - `is_subset(&other)`: $A \subseteq B$.
  - `is_superset(&other)`: $A \supseteq B$.
:::

:::{list-table} Some methods of `HashSet`
:name: tab-hashset
:header-rows: 1
:align: center

* - Method
  - Description
* - `clear()`
  - Removes all elements.
* - `contains(v)`
  - Returns `true` if this map contains the value `v`. 𝒪(1) time.
* - `difference(&other)`
  - Returns an iterator over the values that are in this set but not
    in the other.
* - `get(v)`
  - Returns a reference to the value contained in this set, if it
    exists. The returned type is `Option<&V>`. 𝒪(1) time.
* - `insert(v)`
  - Inserts a new value. 𝒪(1) time.
* - `intersection(&other)`
  - Returns an iterator over the values that are both in this set and
    the other.
* - `is_disjoint(&other)`
  - Returns `true` if this set has no element in common with the
    other. 𝒪(n) time.
* - `is_empty()`
  - Returns `true` if this set contains no elements.
* - `is_subset(&other)`
  - Returns `true` if the other set contains all values of this set.
    𝒪(n) time.
* - `is_superset(&other)`
  - Returns `true` if this set contains all values of the other set.
    𝒪(n) time.
* - `iter()`
  - Returns an iterator over all values. Order is undefined.
* - `len()`
  - Returns the number of elements.
* - `new()`
  - Creates a new map.
* - `remove(v)`
  - Removes the specified value from the map.
* - `replace(v)`
  - Replaces an existing value with a new value `v`.
* - `symmetric_difference(&other)`
  - Returns an iterator over the values that are in this set or in the
    other but not in both.
* - `take(v)`
  - Removes and returns a value from the set.
* - `union(&other)`
  - Returns an iterator over the values of this set and the other,
    without duplicates.
:::

## Creating a new instance

To create a new hash set `HashSet<V>`, an easy way, like for the
[Vec type](#chp-vec), is to let the compiler infer the type. Inserting
at least one value will give the compiler the information it needs:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::collections::HashSet;

let mut names = HashSet::new();
names.insert("John");
names.insert("Paul");
names
```

Note that objects moved into the set are either *copied* or *moved*,
depending on their type.

A `HashSet` may also be created from a vector or an array:

```{code-cell} rust
:class: seq-cont badges border

let other_names = HashSet::from(["George", "Ringo"]);
other_names
```

## Testing if a value exists

To test if a value exists, we use the `contains()` method:

```{code-cell} rust
:class: seq-cont badges border

names.contains("Paul")
```

## Combining methods

The `union()` method returns an iterator over all elements from both
sets, eliminating duplicates:

```{code-cell} rust
:class: seq-cont badges border

let all_names: HashSet<_> = names.union(&other_names).copied().collect();
all_names
```

Explanations:

- The underscore (`_`) inside the `HashSet<_>` type asks the compiler
  that we want `collect()` to insert elements inside a new `HashSet`
  and to infer the type of the elements inside the `HashSet`.
- The type returned by `union()` is `Union<&T>`. That is an iterator
  on references on elements of both sets. In our case the elements
  returned by `union()` are of type `&&str` since `T` is `&str`. In
  fact, nothing is copied here since our type is a slice.
- The `copied()` method is here to convert `&&str` into `&str`. A call
  to `cloned()` would have had the same effect for our case, and would
  also work for all types implementing the `Clone` trait.
- The `collect()` method gathers all elements returned by `union()`
  and puts them inside the new `HashSet<&str>`.

The `intersection()` method returns an iterator over the elements that
are inside the both sets:

```{code-cell} rust
:class: seq-cont badges border

all_names.intersection(&other_names).cloned().collect::<Vec<_>>()
```

The `difference()` method returns an iterator over the elements of a
set that are not inside another:

```{code-cell} rust
:class: seq-cont badges border

all_names.difference(&other_names).cloned().collect::<Vec<_>>()
```

The `symmetric_difference()` method returns an iterator over elements
that are in one set or the other but not both:

```{code-cell} rust
:class: seq-cont badges border

names.symmetric_difference(&all_names).cloned().collect::<Vec<_>>()
```

## Comparing methods

The `is_subset()` method tests if a set is a sub-set of another:

```{code-cell} rust
:class: seq-cont badges border

names.is_subset(&other_names)
```

The `is_superset()` method tests if a set is a super-set of another:

```{code-cell} rust
:class: seq-cont badges border

all_names.is_superset(&other_names)
```

The `is_disjoint()` method tests if two sets have no element in
common:

```{code-cell} rust
:class: seq-stop badges border

names.is_disjoint(&other_names)
```
