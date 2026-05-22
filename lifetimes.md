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

# Lifetimes

:::{danger} Draft
This section is still being written.

TODO: clean.
:::

## What is a Lifetime?

A lifetime is a construct that describes the scope for which a reference
is valid. It's denoted with an apostrophe (`'a`, `'b`, etc.) and is
primarily used to annotate references (`&'a T`). Lifetimes help the Rust
compiler ensure that references do not outlive the data they point to.

## Types of Lifetimes

## Function/Block Scope Lifetimes

Variables declared inside a function or block (i.e.: local variables) are
valid only within that scope. Their lifetime ends when the scope ends.

Example:

```rust
fn example() {
    let x = 5; // x is valid from this point forward
    // ... use x ...
} // x is no longer valid here
```

## Reference Lifetimes

When you **borrow** a reference (`&T` or `&mut T`), its lifetime is tied
to the scope where it is used. Rust enforces that the reference cannot
outlive the data it refers to.

Example:

```{code-cell} rust
:tags: [remove-cell]
:clear
```

```{code-cell} rust
:class: seq-start badges border
fn borrow_example<'a>(s: &'a str) -> &'a str {
    s // The returned reference has the same lifetime as the input
}
```

Let us see it in action:

```{code-cell} rust
:tags: [raises-exception]
:class: seq-stop badges border
let s = "abc";
let t = borrow_example(s);
(s, t)
```

## Struct/Enum Lifetimes

If a **struct** or **enum** contains a **reference**, you must annotate
its lifetime to ensure the reference is **valid** as long as the
struct/enum is used.

Example:

```{code-cell} rust
struct Book<'a> {
    title: &'a str,
}
```

## Static Lifetimes

The `'static` lifetime means the reference is valid for the entire
duration of the program. **String literals** (`&'static str`) and
**global variables** have this lifetime.

Example:

```{code-cell} rust
let s: &'static str = "I live forever!";
```

## Lifetime Elision Rules

Rust has rules to infer lifetimes in common patterns, so you don't always
need to annotate them explicitly:

1. Each input reference gets its own lifetime.
2. If there's exactly one input lifetime, it's assigned to all output
   lifetimes.
3. For methods with `&self` or `&mut self`, the output lifetime is the
   same as self.

Example:

```{code-cell} rust
:tags: [remove-cell]
:clear
```

```{code-cell} rust
:class: seq-start badges border
fn first_word(s: &str) -> &str { // Lifetimes are elided here
    s.split_whitespace().next().unwrap()
}
```

Let us see it in action:

```{code-cell} rust
:tags: [raises-exception]
:class: seq-stop badges border
let s = "abc def ghi";
let t = first_word(s);
(s, t)
```

## Lifetime Annotations in Functions

```{code-cell} rust
:tags: [raises-exception]
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() { x } else { y }
}
```

When the compiler can't infer lifetimes, you must annotate them
explicitly:

```{code-cell} rust
:tags: [remove-cell]
:clear
```

```{code-cell} rust
:class: seq-start badges border
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

Here, `'a` expresses the necessity that both inputs live as long as the
output.

An example of running the function:

```{code-cell} rust
:class: seq-stop badges border
longest("abc", "abcdef")
```

## Lifetime annotations

Every reference has a lifetime.
Most lifetimes are implicit and inferred.

### In functions

In the following code, the compiler does not know if the returned `&str`
is linked to `x` or `y`, thus it cannot set its lifetime:

```{code-cell} rust
:tags: [raises-exception]
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() { x } else { y }
}
```

The following code uses a lifetime annotation to state the returned
reference is valid as long as both parameters `x` and `y` are valid:

```{code-cell} rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

If there is no ambiguity, the lifetime can be inferred by the compiler:

```{code-cell} rust
:tags: [raises-exception]
fn foo(s: &str) -> &str {
  // ...
}
```

### In structures & methods

Lifetime annotations must be declared when using references inside a
struct:

```{code-cell} rust
struct ImportantExcerpt<'a> {
    part: &'a str,
}
```

Returned value is not a reference:

```{code-cell} rust
impl<'a> ImportantExcerpt<'a> {
    fn level(&self) -> i32 {
        3
    }
}
```

When the returned value is a reference, it gets the lifetime of `self`:

```{code-cell} rust
impl<'a> ImportantExcerpt<'a> {
    fn announce_and_return_part(&self, announcement: &str) -> &str {
        println!("Attention please: {announcement}");
        self.part
    }
}
```

### Static lifetime

The following lifetime is for the whole duration of the program:

```{code-cell} rust
let s: &'static str = "I have a static lifetime.";
```

### Inside generic functions

```{code-cell} rust
use std::fmt::Display;

fn longest_with_an_announcement<'a, T>(
    x: &'a str,
    y: &'a str,
    ann: T,
) -> &'a str
where
    T: Display,
{
    println!("Announcement! {ann}");
    if x.len() > y.len() { x } else { y }
}
```
