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

# Borrowing

The second principle of memory in Rust is *borrowing*.
Instead of giving the *ownership* of a value to another part of the code,
we give a *reference* to it. We may give:

- Either one or more *immutable* references to other parts of our code.
- Or only one *mutable* reference to another part of our code.

## Defining a reference

Here is the definition of a reference on an integer variable:

```{code-cell} rust
{
  let a = 16;
  let b = &a;
  println!("{b}");
}
```

(chp-deref-op)=
## Dereferencing

Most of the time a reference cannot be used as is. The following
equality test cannot compile because `a` is a `i32`, while `b` is a
`&i32`:

```{code-cell} rust
:tags: [raises-exception]

let a = 16;
let b = &a;
16 == b
```

The compiler gives us the solution to make it work. We need to use
the dereferencing operator `*` that will convert back the `&i32`
into a `i32`:

```{code-cell} rust
{
  let a = 16;
  let b = &a;
  println!("{}", 16 == *b);
}
```

:::{important} References as pointers
A reference is a type of *pointer*. In our example `b` contains a
reference to the value of the `a` variable in memory. Memory on a
computer is divided in *byte cells*, each having an *address* (i.e.:
an integer number). The numeric value of an address is stored as a
[word](#chp-word) (`usize` in Rust). In our case the `b` variable
stores a `usize` value that is the *address* of the `a` variable in
memory.
:::

```text
    ┌────────────────┐         ┌────────┐
    │ b (0xa413b...) │────────>│ a (16) │
    └────────────────┘         └────────┘
```

The type of `b` is thus a *reference on an integer*, but it is also a
regular variable. As a consequence, we can also make a reference on
`b`. Let us define `c` a variable that is a reference on `b`:

```text
    ┌────────────────┐         ┌────────────────┐         ┌────────┐
    │ c (0x9c1f7...) │────────>│ b (0xa413b...) │────────>│ a (16) │
    └────────────────┘         └────────────────┘         └────────┘
```

To test `c` against `b` we need to *dereference* it. To test `c`
against `a`'s value we need to *dereference* it *twice*:

```{code-cell} rust
{
  let a = 16;
  let b = &a;
  let c = &b;
  println!("{}", b == *c);
  println!("{}", 16 == **c);
}
```

## Passing a reference

When passing a value by reference to a function, we need to declare the
reference both in the function *definition* and the function *call*:

```{code-cell} rust
fn foo(x: &i32) {
  println!("{x}");
}

let a = 16;
foo(&a);
```

If we want to access the referenced value *directly*, we need to use
the *dereferencing* operator `*`:

```{code-cell} rust
fn foo(x: &i32) -> i32 {
  *x + 2
}

let a = 16;
foo(&a)
```

(chp-ref-pattern)=
## The ref pattern

The `ref` keyword can be used in place of the `&` operator.

For instance when defining a new variable:

```{code-cell} rust
{
  let a = 10;
  let ref b = a;
  println!("{:?}", (a, b, a == *b));
}
```

If we define a function that takes a reference, we see that we can
pass `b` directly to the function, since it is already a reference:

```{code-cell} rust
{
  let a = 10;
  let ref b = a;

  fn foo(x: &i32) -> i32 {
    *x + 2
  }

  println!("{}", foo(b));
}
```

The `ref` keyword is useful when writing match expressions, like in
`if let`. Let us define an `Option` value, and write a match using
the `ref` keyword to make the variable `n` a reference on the
internal value of `a` instead of a copy of the value:

```{code-cell} rust
{
  let a = Some(13);

  fn foo(x: &i32) -> i32 {
    *x + 2
  }

  if let Some(ref n) = a {
    println!("{}", foo(n));
  }
}
```

:::{important} Moving or borrowing in `let Some` pattern
The `let Some(x)` pattern moves the object from the `Some()` into
`x` unless the object implements the `Copy` trait, in which case the
object is copied. If we do want the object to be moved, we use the
`let Some(ref x)` pattern that makes `x` a reference on the original
object into the `Some()`.
:::

If we have a mutable `Option` value, we can get a `mutable reference`
on the internal value using `ref` and `mut` together. This allows us
to *modify* the internal value, which we can check afterward:

```{code-cell} rust
{
  let mut b = Some(20);
  if let Some(ref mut n) = b {
    *n += 5;
  }
  println!("{:?}", b);
}
```

## Indexing a vector

When *indexing* a vector of a *non-copiable* type (i.e.: a type that does
not implement the `Copy` trait) using the `[]` operator, the values have
to be moved out of the collection (i.e.: the *ownership* passes from the
collection to the caller). Hopefully, the compiler forbids this usage of
the `[]` operator.

:::{exercise} Two ways of accessing a value by index (★☆☆☆☆)
:label: indexing-vec
:enumerated: true

In the following example, the compiler complains about *moving a value
out of index*:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

let mut v: Vec<String> = Vec::new();
v.push(String::from("abc"));
let a = v[0];
a
```

Try to compile this code and find out what solutions the compiler
suggests.
:::

[see solution](#indexing-vec-solution)

## Mutable reference

If a variable is *mutable*, we may define a *mutable* reference on it in
order to be able to modify the value:

```{code-cell} rust
{
  let mut a = 16;
  let b = &mut a;
  *b = 20;
  println!("{b}");
}
```

:::{note} Dereferencing
Note the use of the `*` operator in order to dereference `b` and access
the `a` variable.
:::

When passing a *mutable* reference to a function, both references in the
function *call* and in the function *definition* must be declared
*mutable*:

```{code-cell} rust
fn foo(s: &mut String) {
  s.push_str("def");
}

{
  let mut s = String::from("abc");
  foo(&mut s);
  s
}
```

## Borrowed mutable variable

While *borrowed*, a *mutable* variable is not freely accessible. Only
after the *reference's scope* termination will we get back full access to
the original variable.

When a *mutable* variable is *immutably* borrowed, we may access its
value and use it:

```{code-cell} rust
let mut a = 16;
{
  let b = &a;
  let c = a + 5;
  println!("(b, c)={:?}", (*b, c));
}
a = 8;
a
```

But we cannot modify it:

```{code-cell} rust
:tags: [raises-exception]

let mut a = 16;
let b = &a;
a = 8;
(a, b)
```

When a *mutable* variable is *mutably* borrowed, we may neither access
nor modify its value:

```{code-cell} rust
:tags: [raises-exception]

let mut a = 16;
let b = &mut a;
let c = a + 5;
(b, c)
```

## Multiple references

As said earlier, multiple `immutable` references on the same variable
are allowed:

```{code-cell} rust
:tags: [raises-exception]

{
  let s = 8;
  let t = &s;
  let u = &s;
  println!("{:?}", (s, t, u));
}
```

However it is forbidden to define multiple `mutable` references on the
same variable:

```{code-cell} rust
:tags: [raises-exception]

let mut s = 8;
let t = &mut s;
let u = &mut s;
(t, u)
```

Or to define a `mutable` reference while at least one `immutable`
reference exists:

```{code-cell} rust
:tags: [raises-exception]

{
  let mut s = 8;
  let t = &s;
  let u = &mut s; // t is still valid since it is used on the line after
  println!("{:?}", (t, u));
}
```

To solve the issue we need to terminate the scope of `t` earlier in the
code (i.e.: before `u` is created):

```{code-cell} rust
:tags: [raises-exception]

{
  let mut s = 8;
  let t = &s;
  println!("{t}"); // End of t's scope
  let u = &mut s;
  println!("{u}");
}
```

## Borrowing blocks moving

In the same way *borrowing* blocks modifications on a *mutable*
variable, it blocks also the *moving* of *ownership*.

In the following example, `s` cannot be moved, because the reference
`t` is still alive:

```{code-cell} rust
:tags: [raises-exception]

{
  let s = String::from("abc");
  let t = &s;
  println!("{:?}", (s, t));
}
```
