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

# Hash Maps

:::{danger} Draft
This section is still being written.
:::

## Create

Create a new hash map `HashMap<K, V>`:

```{code-cell} rust
use std::collections::HashMap;
let mut scores = HashMap::new();
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Yellow"), 50);
```

## Get a value

Get a value:

```{code-cell} rust
let team_name = String::from("Blue");
let score = scores.get(&team_name).copied().unwrap_or(0);
```

- `get()` return's type is `Option<&V>`.
- `copied()` converts `Option<&V>` into `Option<V>`.
- `unwrap_or()` converts `Option<V>` into `V` if it is `Some<V>`, and
  into a default value if it is `None`.

## Iterating

```{code-cell} rust
for (k, v) in &scores {
  println!("{k}: {v}");
}
```

## Ownership of keys and values

Types that implement the `Copy` (e.g.: basic types) trait are *copied*,
other types are *moved*.

```{code-cell} rust
use std::collections::HashMap;
let k = String::from("a");
let v = String::from("X");
let mut map = HashMap::new();
map.insert(k, v);
// k and v are now invalid.
```

## Updating a value

### Replacing a value

Replacing an existing value:

```{code-cell} rust
scores.insert(String::from("Blue"), 10);
scores.insert(String::from("Blue"), 25);
// Now Blue is associated with 25.
```

### Adding a value if no key present

Adding a key/value only if key isn't already defined:

```{code-cell} rust
scores.insert(String::from("Blue"), 10);
scores.entry(String::from("Blue")).or_insert(25);
// Blue is still associated with 10.
```

- `entry()` returns an `Entry` enum that represents a value that might
  or might not exist.

### Updating an existing value

```{code-cell} rust
:tags: [raises-exception]

let count = map.entry(my_key).or_insert(0); // Set count to 0 if my_key is not defined.
*count += 1; // Increment the value associated with my_key.
```

- `or_insert()` returns a `&mut V`.
- The `*` dereference the `&mut V`.

## Printing a hash map

```{code-cell} rust
println!("{map:?}");
```

## Hashing function

The default hashing function is `SipHash` which is resistant to DoS
attacks. It can be changed (i.e.: if it is too slow) by another hashing
function if needed. A *hasher* (i.e.: a hashing function) implements
the *BuildHasher* trait.
