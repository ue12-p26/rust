# BTreeSet

:::{warning} To review
:class: readiness-toreview

:::

The `BTreeSet` is a *B-tree* data structure that stores values in an
ordered way. See {numref}`fig-btreeset`.
The main features of a `BTreeSet` are:

- The values must implement the
  [Ord](https://doc.rust-lang.org/std/cmp/trait.Ord.html) trait.
- Each node of a *B-tree* has a maximum of $K$ values.
- Iteration is made in value order, and has 𝒪($\log(n)$) complexity.

:::{code-block} text
:name: fig-btreeset
:caption: A BTreeSet with integer values, using a maximum of 4 values per node.

                ┌────┬────┬────┬────┐
                │ 10 │ 16 │ 23 │    │
                └────┴────┴────┴────┘
               ╱           ╲
              ╱             ╲
             ╱               ╲
┌────┬────┬────┬────┐     ┌────┬────┬────┬────┐
│  2 │  5 │    │    │     │ 17 │ 19 │ 21 │ 22 │
└────┴────┴────┴────┘     └────┴────┴────┴────┘
:::

The main methods of the `BTreeSet` are presented in
{numref}`tab-btreeset`.

:::{list-table} Some methods of `BTreeSet`
:name: tab-btreeset
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
