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

# Control flow exercises

## Loop exercise

:::{solution} loop-ex
:label: loop-ex-solution
:::

```{code-cell} rust
let mut n = 0;
loop {
  n += if n % 2 == 0 { 3 } else { 1 };
  println!("{n}");
  if n > 30 {
    break;
  }
}
```

## Checker

:::{solution} checker
:label: checker-solution
:::

Here are the two `for` loops needed to draw the grid:

```{code-cell} rust
for i in 0..20 {
  for j in 0..i {
    print!("{}", if (i+j)%2==0 {'X'} else {' '});
  }
  println!();
}
```

## Multiple search in a string

:::{solution} mult-search-str
:label: mult-search-str-solution
:::

We define the letters and the string:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let s = "abcdefghijklmnop";
let letters = ['c', 'a', 't', 'z', 'h'];
```

We loop on each letter to search for, and test the result of `find()`
using `if let Some(...)`:

```{code-cell} rust
:class: seq-stop badges border

for letter in letters {
  if let Some(index) = s.find(letter) {
    println!("Found {letter} at index {index}.");
  }
}
```

## Iterating over results

:::{solution} iter-results
:label: iter-results-solution
:::

We define the string variable:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let s = "abc\nde\nfghi\njklm\nnop\n";
```

We store the iterator returned by `lines()`:

```{code-cell} rust
:class: seq-cont badges border

let mut lines = s.lines();
```

We use the `while let` construct to iterate over all results until the
end (`None` value):

```{code-cell} rust
:class: seq-stop badges border

while let Some(line) = lines.next() {
  println!("{line}");
}
```
