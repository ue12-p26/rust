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

# Ownership

In Rust, the first basic principle of memory is *ownership*: a value
belongs to its variable.
In this section we will look at what happens when:

- We clone a value.
- We pass a value to another variable or a function.
- A function returns a value.

## Cloning

The `Clone` trait (see [Traits chapter](#chp-traits)), when implemented
by a type, allows the explicit *copy* of an object through the use of
the `clone()` method.

Depending on the implementation of the `clone()` method, the *copy* may be
done:

- Using a *raw* copy of the memory. The memory zone where data is stored
  is copied exactly bit by bit, without any knowledge of the data's
  structure.
- Using a *clever* copy of the data. The knowledge of the data's structure
  is used to achieve an elaborated copy that takes into account:
  - Allocated heap memory.
  - Opened resources (file handles, sockets, …).
  - Complex structures: lists, trees, graphs, …
  - Resetting of specific fields that must not be copied.

Here is an example in which we clone a `String` object (the `String` type
allocates heap memory for storing a character string):

```{code-cell} rust
let mut s1 = String::from("hello");
let s2 = s1.clone();
s1.push_str(" world!");
println!("s1 = {s1}, s2 = {s2}");
```

## Passing a value

When a value is passed from a variable to another variable or a function,
one of two things happen:

- Either it is *copied*.
- Or it is *moved*.

Both behaviours are *implicitly* selected by the *compiler*, and the
choice between them depends on the implementation or not of the `Copy`
trait by the value's type.
If the value's type implements the `Copy` trait, the value is *copied*,
otherwise it is *moved*.
With either *copy* or *move* the destination gets the *ownership* of the
data:

- A *new* value (copied) in case of a *copy*.
- The *original* value in case of a *move*.

### Copying

The `Copy` trait specializes the `Clone` trait (i.e.: it implements the
`clone()` method) by making a raw copy of the memory (memory bytes copy).
The copy has thus no knowledge of the data structure.

To implement the `Copy` trait, a type must **NOT**:

- Use heap allocation.
- Require any form of resource management (like file handles or locks).
- Implement the `Drop` trait, as it is used for cleanup when values go
  out of scope.

The built-in types that implement `Copy` are:

- All integer types: `i8`, `i16`, `i32`, `i64`, `i128`, `isize`, `u8`,
  `u16`, `u32`, `u64`, `u128`, `usize`.
- All floating-point types: `f32`, `f64`.
- The boolean type: `bool`.
- The character type: `char`.
- Tuples, if all their fields implement `Copy` (e.g.: `(i32, bool)`)
- Arrays, if their element type implements `Copy` (e.g.: `[i32; 5]`)

In the following example, the table `a` is implicitly copied into `b`:

```{code-cell} rust
let a = [12, -7, 6];
let b = a;
(a, b)
```

### Moving

When its value is moved, a variable loses the ownership and cannot be used
anymore.

In the following example, `s` cannot be used anymore once its value is
passed to `t`:

```{code-cell} rust
:tags: [raises-exception]
let s = String::from("abc");
let t = s;
(s, t)
```

:::{warning} Move or copy?
A value is *moved* by the compiler when it cannot be *copied*.
:::

## Passing to a function

The same copy/move mechanism applies when passing values to functions.

Here is an example with a `String` value that is passed to a function:

```{code-cell} rust
:tags: [raises-exception]
fn foo(s: String) {
  println!("{} world!", s);
}

let s1 = String::from("hello");
foo(s1);
let s2 = s1;
s2
```

What happens is the following:

- Ownership of `s1` is passed to `foo()` (i.e.: the value is *moved*) as
  `s1` does not have the `Copy` trait.
- `s1` is dropped at the end of `foo()`.
- `s1` is no more valid inside the scope after the call to `foo()`.

If `s1` is needed after the call to `foo()`, one solution that we have
seen above is to clone the value:

```{code-cell} rust
fn foo(s: String) {
  println!("{} world!", s);
}

let s1 = String::from("hello");
foo(s1.clone());
let s2 = s1;
s2
```

## Getting a variable from a function

The return value of a function is *moved* or *copied* in the same way we
have seen.

In the following example the value returned by `foo()` is moved into
`s1`:

```{code-cell} rust
fn foo() -> String {
  String::from("Hello world")
}

let s1 = foo();
s1
```

## Modifying a value with a function

Using what we have seen above, we are able to write a function that
computes a new value, returns it, and use it to set a new value to our
variable:

```{code-cell} rust
fn inc(n: i16) -> i16 {
  n + 1
}

let a = 5;
let a = inc(a);
a
```

What we have done in the previous example is:

- Pass a value to function `inc()`.
- Compute a new value inside the function.
- Define a new variable `a`, shadowing the previous `a` variable, and
  initialize it with the returned value of `inc()`.

It looks like we have modified `a`, while all we have done is redefining
a new variable of the same name. Both version of the variable `a` are
*immutable*.

Making the variable *mutable*, we can reset its value:

```{code-cell} rust
let mut b = 7;
b = inc(b);
b
```

We can do the same with a type that allocates heap memory:

```{code-cell} rust
fn foo(s: String) -> String {
  format!("{s}def")
}

let mut s = String::from("abc");
s = foo(s);
s
```

Since the `ownership` of the value is passed to `foo()`, it is also
possible to declare the `foo`'s parameter as mutable so we can modify it
in-place:

```{code-cell} rust
fn foo(mut s: String) -> String {
  s.push_str("def");
  s
}

let mut s = String::from("abc");
s = foo(s);
s
```

:::{warning} Builder Pattern
This pattern, where the received parameter is modified before returning
it, is very common in Rust with structures' initialization, as we will
see later.
:::
