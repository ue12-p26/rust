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

(chp-hashmap)=
# HashMap

:::{warning} To review
:class: readiness-toreview

:::

The `HashMap` structure is a *map* that uses a *hashing* algorithm to
store key/value pairs.
A *map* is a data structure that stores key/value pairs. Each key has
a value associated to it, and is unique inside the map.
In a `HashMap`, the key of each pair is processed through the
*hashing* algorithm in order to generate a *hash value*, which is
used to store efficiently the key/value pair using an array. See
{numref}`fig-hashmap`.
The *hashing* algorithm has for goal to associate a bucket to each
key, by computing the *bucket index* from the key.
Possibly, multiple keys will be associated to the same index. Those
key/values are stored together in another structure.

:::{note} Performance
:name: hashmap-performance

The efficiency of a hash map depends on its load factor $\alpha$:

$$\alpha = \frac{n}{m}$$

where

- $n$ is the number of key-value pairs in the hash table.
- $m$ is the number of buckets.

In order to preserve a good performance, the load-factor of a hash
table is kept under a threshold. To ensure this, the map is rehashed
when necessary. Rehashing the whole map has a 𝒪(n) complexity, however
at each step the number of buckets usually grows exponentially
(doubling), which makes this complexity marginal in the long run, at
the cost of possibly a high memory consumption.
:::

:::{code-block} text
:name: fig-hashmap
:caption: An example of a `HashMap`

Buckets
  │
  ▼
┌────┐
│  0 │
├────┤     ┌──────┬──────┬──────┐
│  1 │ ──> │"a"/13│"g"/77│"z"/48│ key/value pairs
├────┤     └──────┴──────┴──────┘
│  2 │
├────┤
│  3 │
├────┤     ┌──────┐
│  4 │ ──> │"k"/55│ key/value pairs
├────┤     └──────┘
│  5 │
├────┤     ┌──────┬──────┐
│  6 │ ──> │"b"/65│"t"/11│ key/value pairs
├────┤     └──────┴──────┘
│  7 │
└────┘
:::

To be usable inside a `HashMap` the keys must have a type that
implements the traits `Eq` and `Hash`. Moreover it must verify:

$$k1 = k2 \Rightarrow hash(k1) = hash(k2)$$

The main methods of the `HashMap` are presented in
{numref}`tab-hashmap`.

:::{list-table} Some methods of `HashMap`
:name: tab-hashmap
:header-rows: 1
:align: center

* - Method
  - Description
* - `clear()`
  - Removes all elements.
* - `contains_key(k)`
  - Returns `true` if this map contains the key `k`. 𝒪(1) time.
* - `entry(k)`
  - Gives access to key/value pair. 𝒪(1) time.
* - `get(k)`
  - Returns a reference to the value, if any. The returned type is
    `Option<&V>`. 𝒪(1) time.
* - `insert(k, v)`
  - Inserts a new key/value pair. 𝒪(1) time.
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
* - `remove(k)`
  - Removes the specified key from the map.
* - `values()`
  - Returns an iterator over the values. Order is arbitrary.
:::

## Creating a new instance

To create a new hash map `HashMap<K, V>`, an easy way, like for the
[Vec type](#chp-vec), is to let the compiler infer the type. Inserting
at least one key/value pair will give the compiler the information it
needs:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::collections::HashMap;

let mut scores = HashMap::new();
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

`HashMap` implements the
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

The `or_insert()` of the `Entry` struct, allows to insert a key/value
only if the key is not already defined:

```{code-cell} rust
:class: seq-cont badges border

scores.entry(String::from("Green")).or_insert(18)
```

## Updating an existing value

We suppose we want to increment the score of a team.
We retrieve a reference on the current score of team `"Red"`, using
the `or_insert()` method in case the team is not declared, and
increment it by dereferencing it with the `*` operator. The
[or_insert()](https://doc.rust-lang.org/std/collections/hash_map/enum.Entry.html#method.or_insert)
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

Add exercise.
:::
