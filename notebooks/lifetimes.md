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

(chp-lifetimes)=
# Lifetimes

:::{warning} To review
:class: readiness-toreview

:::

## What is a lifetime?

A *lifetime* is a construct that describes the scope for which a
reference is valid. It is denoted with an apostrophe (`'a`, `'b`,
etc.) and used on *references* (`&`) or inside angle brackets on types
or functions (`<>`). It is used to annotate:

- References (e.g.: `&'a T`).
- Types or traits to describe constraints about references they
  *might contain* (e.g.: `struct Foo<'a>`, `Box<dyn Trait + 'a>`).

Lifetimes help the Rust compiler ensure that references do not outlive
the data they point to.

## Function/block scope lifetimes

Variables declared inside a function or block (i.e.: local variables)
are valid only within that scope. Their lifetime ends when the scope
ends. In the following example, the lifetime of `x` is *implicit*. It
is linked to the *block delimiters*:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn example() {
  let x = 5; // x is valid from this point forward
  // ... use x ...
} // x is no longer valid here
```

## Static lifetimes

The `'static` lifetime means the reference is valid for the entire
duration of the program. *String literals* and *global variables* have
this lifetime.

The following code defines a static string:

```{code-cell} rust
let s: &'static str = "I can live forever!";
s
```

In fact, the lifetime is implicit and we do not need to write it:

```{code-cell} rust
let s = "I can live forever!";
s
```

## Lifetimes of borrowed objects

When we *borrow* a reference (`&T` or `&mut T`), its lifetime is tied
to the scope where it is used. Rust enforces that the reference cannot
outlive the data it refers to:

```{code-cell} rust
:tags: [raises-exception]

let m = {let n = 17; &n };
m
```

## Lifetimes of returned objects

Rust has rules to *infer* lifetimes in common patterns, so we don't
always need to annotate them explicitly:

1. Each input reference gets its own lifetime.
2. If there's exactly one input lifetime, it's assigned to all output
   lifetimes.
3. For methods with `&self` or `&mut self`, the output lifetime is the
   same as self.

In the following example, the lifetimes are elided since the compiler
can infer them automatically. The returned reference has the same
lifetime as the input argument:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

fn first_word(s: &str) -> &str {
  s.split_whitespace().next().unwrap()
}
```

The variable `t` has the same *lifetime* as `s`. It can be used as
long as `s` is alive:

```{code-cell} rust
:class: seq-stop badges border

let s = "abc def ghi";
let t = first_word(s);
(s, t)
```

## Explicit lifetime in functions

In the following function, the compiler *cannot* infer the lifetime of
the return type. It does not know if it has to take the lifetime of
`x`, `y` or *both*:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn longest(x: &str, y: &str) -> &str {
  if x.len() > y.len() { x } else { y }
}
```

Hence we must annotate them explicitly. Since the return type is
either linked to `x` or `y`, we define the *same* lifetime for the
three values. The `'a` lifetime expresses the necessity that *both*
inputs live *as long as* the output:

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

Here is an example of running the function:

```{code-cell} rust
:class: seq-stop badges border

longest("abc", "abcdef")
```

## Struct lifetimes

If a `struct` contains a *reference*, we must annotate its lifetime to
ensure the reference is *valid* as long as the `struct` is used:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Book<'a> {
  title: &'a str,
}
```

When defining a method that returns a *reference*, the returned value
gets *implicitly* the lifetime of `self`:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> Book<'a> {
  fn title(&self) -> &str {
    self.title
  }
}
```

In the following code `title` cannot outlive `book`:

```{code-cell} rust
:class: seq-stop badges border

{
  let book = Book { title: "All Systems Red" };
  let title = book.title();
  println!("{title}");
}
```

## Enum lifetimes

As for a `struct`, we need to explicitly set a lifetime for an `enum`
that uses a reference.

In the following *enum*, the use of string slices for the two variants
makes a lifetime compulsory:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

enum Message<'a> {
  Standard(&'a str),
  Urgent(&'a str),
}
```

If a reference is returned from a method, it uses the same lifetime as
the `enum`:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> Message<'a> {
  fn text(&self) -> &str {
    match self {
      Self::Standard(m) => m,
      Self::Urgent(m) => m,
    }
  }
}
```

Here is the usage of this enum:

```{code-cell} rust
:class: seq-stop badges border

let m1 = Message::Standard("Hello!");
let m2 = Message::Urgent("Help!");
(m1.text(), m2.text())
```
