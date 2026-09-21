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

(chp-generics)=
# Generics

A *generic* type is a type that is defined using one or more *parametric*
types or values. It is not, however, a *real* type, as it not compiled
*as-is*.

For it to be compiled, we need to realize a version of it. This means we
need to fix the parameters.

In Rust, the *generic* notation uses the bracket characters `<>` and can
be applied to various objects: `enum`, `struct`, `trait`, `function`,
`method`.

Here is an example of a generic function which turns each integer value
of an array into its negative counterpart. It takes a generic integer
parameter. The parameter is used inside the function's argument to accept
an array of signed integers:

```{code-cell} rust
fn negate<const N: usize>(mut a: [i16;N]) -> [i16;N] {
  for x in &mut a {
    *x = -*x;
  }
  a
}

println!("{:?}", negate([15, 9, 15000]));
println!("{:?}", negate([320, 4]));
```

Here is another example of a function that just prints its argument.
Since we print using the debug formatter (`?`), we have to declare that
our generic parameter T needs to implement the `Debug` trait:

```{code-cell} rust
use std::fmt::Debug;

fn my_print<T: Debug>(a: T) {
  println!("{a:?}");
}

my_print(15);
my_print([15, 4]);
my_print(true);
my_print("Hello");
```
