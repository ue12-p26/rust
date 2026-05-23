---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: rust
  display_name: Rust
  language: rust
---

# More about `Vec`

:::{danger} Draft
This section is still being written.
:::

## Vector of non-copiable types

We have seen how to define and use a vector whose elements' type
implements the `Copy` trait (e.g.: integers, floats, ...). In the case of
a non-copiable type, accessing vector's elements result result the same
we have learnt, by indexing or iterating, the elements of the vector will
be *moved* instead of *copied*, and thus will be removed from the vector.

```{code-cell} rust
:tags: [raises-exception]

let mut v: Vec<String> = Vec::new();
v.push(String::from("abc"));
let a = v[0];
```

```{code-cell} rust
:tags: [raises-exception]

let mut v: Vec<String> = Vec::new();
v.push(String::from("abc"));
v.push(String::from("def"));
v.push(String::from("ghi"));
for e in v {
  print!("{e}, ");
}
v
```

### Indexing

```{code-cell} rust
:tags: [raises-exception]

{
  let mut v: Vec<String> = Vec::new();
  v.push(String::from("abc"));
  v.push(String::from("def"));
  v.push(String::from("ghi"));
  let a = &v[1];
  (v, a)
}
```

We cannot modify a vector once we have a reference on it:

```{code-cell} rust
:tags: [raises-exception]

let elem = &v[i]; // immutable borrow
v.push(10); // mutable borrow ==> COMPILER ERROR!
```

Securely accessing an element with `get()`:

```{code-cell} rust
:tags: [raises-exception]

let v = vec![1, 2, 3];
let elem = v.get(0); // elem is a Option<&i32>
match elem {
  Some(elem) => println!("OK"),
  None => println!("Error"),
}
```

### Iterating

Iterating over elements:

```{code-cell} rust
:tags: [raises-exception]

for e in &v { // immutable iteration
}

for e in &mut v{ // mutable iteration (i.e.: we can modify the elements)
}
```

We can store miscellaneous types inside a vector, using an enum.
This works because an enum defines all its values as variants.

```{code-cell} rust
enum MyEnum {
  AnInt(i8),
  ABool(bool),
  AFloat(f32),
}

let my_vec = vec![
  MyEnum::AnInt(10),
  MyEnum::ABool(false),
  MyEnum::AFloat(5.6),
];
```
