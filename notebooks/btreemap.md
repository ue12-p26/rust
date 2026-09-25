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

# BTreeMap

:::{warning} To review
:class: readiness-toreview

:::

The `BTreeMap` is a *B-tree* data structure that stores key/value
pairs in an ordered way. See {numref}`fig-btreemap`.
The main features of a `BTreeMap` are:

- The keys must implement the
  [Ord](https://doc.rust-lang.org/std/cmp/trait.Ord.html) trait.
- Each node of a *B-tree* has a maximum of $K$ keys.
- Iteration is made in key order, and has 𝒪($\log(n)$) complexity.

:::{code-block} text
:name: fig-btreemap
:caption: A BTreeMap with integer keys and string values, using a maximum of 4 keys per node.

                     ┌──────┬──────┬──────┬──────┐
                     │10/"a"│16/"r"│23/"z"│      │
                     └──────┴──────┴──────┴──────┘
                    ╱               ╲      ╲
                   ╱                 ╲      ╲
┌──────┬──────┬──────┬──────┐         ▏     ┌──────┬──────┬──────┬──────┐
│ 2/"t"│ 5/"e"│      │      │         ▏     │25/"w"│29/"o"│      │      │
└──────┴──────┴──────┴──────┘         ▏     └──────┴──────┴──────┴──────┘
                        ┌──────┬──────┬──────┬──────┐
                        │17/"w"│19/"o"│21/"j"│22/"v"│
                        └──────┴──────┴──────┴──────┘
:::

The main methods of the `BTreeMap` are presented in
{numref}`tab-btreemap`.

:::{list-table} Some methods of `BTreeMap`
:name: tab-btreemap
:header-rows: 1
:align: center

* - Method
  - Description
* - `append(&other)`
  - Moves the elements of another map into this map.
* - `clear()`
  - Removes all elements.
* - `contains_key(k)`
  - Returns `true` if this map contains the key `k`.
* - `entry(k)`
  - Gives access to key/value pair.
* - `get(k)`
  - Returns a reference to the value, if any. The returned type is
    `Option<&V>`.
* - `insert(k, v)`
  - Inserts a new key/value pair.
* - `is_empty()`
  - Returns `true` if this map contains no elements.
* - `iter()`
  - Returns an iterator on all key/value pairs.
* - `keys()`
  - Returns an iterator over the keys. Order is arbitrary.
* - `len()`
  - Returns the number of elements.
* - `new()`
  - Creates a new map.
* - `range(r)`
  - Returns a double-ended iterator over a range of elements in the
    map.
* - `remove(k)`
  - Removes the specified key from the map.
* - `split_off(k)`
  - Splits the map into two at the given key. The current map is
    modified to contain all elements with a key lower than the given
    key. Remaining elements are returned into a new map.
* - `values()`
  - Returns an iterator over the values. Order is arbitrary.
:::

## Creating a new instance

To create a new hash map `BTreeMap<K, V>`, an easy way, like for the
[Vec type](#chp-vec), is to let the compiler infer the type. Inserting
at least one key/value pair will give the compiler the information it
needs:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::collections::BTreeMap;

let mut scores = BTreeMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
```

:::{warning} Ownership of keys and values
When inserted inside a map, the keys and values may be copied or
moved, depending on their type.
Types that implement the `Copy` trait are *copied* (e.g.: basic
types), other types are *moved*.
For those last types, we may wish to clone them before passing them:

```{code-cell} rust
:class: seq-cont badges border

let k = String::from("Red");
scores.insert(k.clone(), 23);
k
```
:::

## Getting a value

Getting a value from the map is done using the `get()` method, which
returns an `Option<V>`:

```{code-cell} rust
:class: seq-cont badges border

let team_name = String::from("Blue");
match scores.get(&team_name) {
  Some(score) => println!("The score of team {team_name} is {score}."),
  None => println!("No score for team {team_name}"),
}
```

`BTreeMap` implements the
[Index](https://doc.rust-lang.org/std/ops/trait.Index.html) trait, and
thus provides the indexing operator (`[]`) for retrieving a value.
Example:

```{code-cell} rust
:class: seq-cont badges border

scores["Blue"]
```

:::{danger} Index out of range
If the key does not exist in the map, the indexing operator *panics*.
:::

## Iterating

Using a `for` loop we can loop onto the key/value pairs:

```{code-cell} rust
:class: seq-cont badges border

for (k, v) in &scores {
  println!("{k}: {v}");
}
```

## Replacing an existing value

Inserting a key/value pair, replaces the eventual existing key:

```{code-cell} rust
:class: seq-cont badges border

scores.insert(String::from("Blue"), 34);
scores
```

## Adding a value if no key present

The `or_insert()` of the `Entry` structure, allows to insert a
key/value only if the key is not already defined:

```{code-cell} rust
:class: seq-cont badges border

scores.entry(String::from("Green")).or_insert(18)
```

## Updating an existing value

We suppose we want to increment the score of a team.
We retrieve a reference on the current score of team `"Red"`, using
the `or_insert()` method in case the team is not declared, and
increment it by dereferencing it with the `*` operator. The
[or_insert()](https://doc.rust-lang.org/std/collections/btree_map/enum.Entry.html#method.or_insert)
method returns a `&mut V`:

```{code-cell} rust
:class: seq-cont badges border

{
  let count = scores.entry("Red".to_string()).or_insert(0);
  *count += 1;
  println!("count is now {count}");
}
```

Here is the result:

```{code-cell} rust
:class: seq-stop badges border

scores
```

:::{danger} TODO
:class: readiness-todo

Add exercises.
:::
