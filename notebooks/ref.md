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

## Type of a reference

Printing the value of `b` gives the right value, however the type of `b`
is not `integer` but is a reference to an `integer`: `&integer`.
We can see it if we make `b` mutable and try to modify its value:

```{code-cell} rust
:tags: [raises-exception]

let a = 16;
let mut b = &a;
b = 20;
b
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

If want to access the referenced value *directly*, we need to use the
*dereferencing* operator `*`:

```{code-cell} rust
fn foo(x: &i32) -> i32 {
  *x + 2
}

let a = 16;
foo(&a)
```

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
