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

# if/let

The `if/let` statement is a concise way to treat the case of an enum
value matching one pattern only.

Let us define a tagged union:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

enum Speed {
  Miles(f32), // Miles per hour
  Km(f32),    // Km/h
  Unknown,
}
```

And an array of values:

```{code-cell} rust
:class: seq-cont badges border

let speeds = [Speed::Unknown, Speed::Km(60.5), Speed::Miles(40.2)];
```

In the following example the code block of the `if/let` statement is
used twice in order to process the two cases `Miles` and `Km`:

```{code-cell} rust
:class: seq-cont badges border

for x in &speeds {
  if let Speed::Miles(speed) = x {
    println!("Speed is {speed} miles/h.");
  }
  else if let Speed::Km(speed) = x {
    println!("Speed is {speed} km/h.");
  }
}
```

## Returned value

With the `if/let/else` expression we may return values, the restriction
being that all returned values must be of the same type. Let us use a
`if/let/else` expression to get a speed in km/h all the time:

```{code-cell} rust
:class: seq-cont badges border

for x in &speeds {
  let speed = if let Speed::Miles(s) = x { s / 0.62 }
              else if let Speed::Km(s) = x { *s }
              else { 0.0 };
  println!("Speed is {speed} km/h.");
}
```

## let/else

The `let/else` control flow works the other way, letting us match a
value and run a code block when it does not match:

```{code-cell} rust
:class: seq-stop badges border

for x in &speeds {
  let Speed::Miles(speed) = x else {
    continue;
  };
  println!("Speed is {speed} miles/h.");
}
```
