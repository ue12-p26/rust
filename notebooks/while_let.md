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

# while/let pattern

The `while/let` pattern allows us to stay in a loop, as long as some
matching is `true`.

Let us define a *tagged union* to register measurement values and the
absence values:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

enum Measure {
  Value(f64),
  Nil,
}
```

We define then a function that generates some `Measure` values
depending on an index:

```{code-cell} rust
:class: seq-cont badges border

fn get_measure(i: usize) -> Measure {
  if i < 10 {
    Measure::Value(1.12 * i as f64)
  }
  else {
    Measure::Nil
  }
}
```

Let us initialize a global index:

```{code-cell} rust
:class: seq-cont badges border

let mut i: usize = 0;
```

And use it to iterate over the `Measure` values returned by the
`get_measure()` function. We use the `while/let` construct to extract
the float values returned by the function. As soon as a `Nil` is
returned, we will quit the loop:

```{code-cell} rust
:class: seq-stop badges border

while let Measure::Value(x) = get_measure(i) {
  print!("{x} ");
  i += 1;
}
println!();
```

:::{danger} Infinite loop
We must be careful to do not write a pattern that always match, as in
the following example, since it will produce an *infinite* loop:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

while let _ = 5 {
  println!("Irrefutable patterns are always true");
}
```

:::
