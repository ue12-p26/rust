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

# Booleans

[The boolean type](https://doc.rust-lang.org/stable/book/ch03-02-data-types.html#the-boolean-type)
is represented by the `bool` keyword and accepts the values `true` and
`false`:

```{code-cell} rust
let a = true;
let b = false;
(a, b)
```

## Logical operators

*Logical operators* combine boolean values to give a new boolean value.

The NOT operator `!` negates the value:

```{code-cell} rust
// don't remove the initial white space 
 ! false
```

The AND operator is represented by `&`:

```{code-cell} rust
(false & true, true & true)
```

The OR operator is represented by `|`:

```{code-cell} rust
false | true
```

The XOR operator is represented by `^`:

```{code-cell} rust
(false ^ true, true ^ true)
```

### Short-circuiting operators

When combining boolean functions with the AND or OR operator, all functions
are always evaluated.

Here are three boolean functions:

```{code-cell} rust
fn foo1() -> bool {
  println!("foo1()");
  true
}

fn foo2() -> bool {
  println!("foo2()");
  false
}

fn foo3() -> bool {
  println!("foo3()");
  true
}
```

Doing an OR operation between them results in the calling of the three
function, despise the fact that he first function `foo1()` returns `true`:

```{code-cell} rust
let b = foo1() | foo2() | foo3();
println!("{b}");
```

Similarly, an AND operation between the same functions triggers the calling
of the three functions while the second one returns `false`:

```{code-cell} rust
let b = foo1() & foo2() & foo3();
println!("{b}");
```

To avoid this side effect that can affect performance, two other operators
are available. They are called *short-circuiting* operators:

- `||` is the *short-circuiting* OR.
- `&&` is the *short-circuiting* AND.

Using the `||` operator, we that only the first function is evaluated:

```{code-cell} rust
let b = foo1() || foo2() || foo3();
println!("{b}");
```

With the `&&` operator, the last function is not evaluated:

```{code-cell} rust
let b = foo1() && foo2() && foo3();
println!("{b}");
```

## Comparison operators

*Comparison operators* compare values of various types and return a boolean
value.

The *equality* operator returns `true` if two values are equal:

```{code-cell} rust
(12.2 == 12.3, "abc" == "abc")
```

The *less than* operator return `true` if one value is strictly smaller than
another:

```{code-cell} rust
(12.2 < 12.3, "abc" < "abc", "abc" < "abd")
```

Other operators are `!=` (inequality), `<=`, `>` and `>=`.
