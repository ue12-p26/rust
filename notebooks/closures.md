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

# Closures

:::{warning} To review
:::

A *closure* is an *anonymous* function that can be:

- Stored in a variable.
- Passed as an argument.
- Returned from a function.

The syntax of a *closure* is more like an expression. It uses the
vertical bars `||` to declare the arguments of the closure and then an
expression that uses those arguments to compute a value. Here is a
closure that doubles a value, that we use as a normal function:

```{code-cell} rust
let double = |x| x * 2;
double(5)
```

We can define a function that takes a closure. We use the `Fn` trait
with the type of the argument and the returned type to describe the
closure type:

```{code-cell} rust
fn foo(f: impl Fn(i32) -> i32) {
  for i in 0..10 {
    print!("{} ", f(i))
  }
}
```

:::{note} Fn, FnOnce and FnMut
- The [Fn](https://doc.rust-lang.org/std/ops/trait.Fn.html) trait
  describes a closure that can be called multiple times and is allowed
  to modify its arguments.
- The [FnMut](https://doc.rust-lang.org/std/ops/trait.FnMut.html)
  trait describes a closure that can be called multiple times and is
  allowed to modify its arguments.
- The [FnOnce](https://doc.rust-lang.org/std/ops/trait.FnOnce.html)
  trait describes a closure that can be called only once and is not
  allowed to modify its arguments.
:::

Here is the effect of calling `foo()` with `double()`:

```{code-cell} rust
let double = |x| x * 2;
foo(double);
```

A function can return a closure as illustrated by the following
example in which we create any closure that multiplies a number by a
factor. The `move` keyword is *compulsory*. It tells the compiler that
the closure takes ownership of the `factor` variable:

```{code-cell} rust
fn make_closure(factor: i32) -> impl Fn(i32) -> i32 {
  move |x| x * factor
}
```

We call directly the closure returned by the `make_closure()`
function:

```{code-cell} rust
make_closure(3)(10)
```

Or pass it to another function:

```{code-cell} rust
foo(make_closure(5));
```

## Capturing variables

A *closure* can also *capture* variables from its *scope*. Hence the
name *closure* that embeds together a *function*/*expression*
definition with an *environment* (i.e.: variables from the scope).

Here the definition of a closure that takes an argument `z` but also
embeds the variable `x` from its scope. The evaluation is done as
usual:

```{code-cell} rust
let x = 4;
let equal_to_x = |z| z == x;
equal_to_x(5)
```

The capture of a variable by a closure, means the closure *borrows*
the variable. A *mutable* variable that is captured, cannot be
modified as long as the closure is alive:

```{code-cell} rust
:tags: [raises-exception]

{
  let mut x = 4;
  let equal_to_x = |z| z == x;
  x = 7;
  equal_to_x(7)
}
```
