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

# String exercises

## Splitting a string

:::{solution} str-split
:label: str-split-solution
:::

The `split_whitespace()` splits a string on white spaces and returns an
*iterator* on the sub-strings:

```{code-cell} rust
let n = "a b c d e f";
for s in n.split_whitespace() {
  println!("{s}")
}
```

The more generic `split()` method does the same on a pattern (e.g.: a
string, a character, a function or a closure):

```{code-cell} rust
let n = "ab..cde..f..ghi..jk..l";
for s in n.split("..") {
  println!("{s}")
}
```

## Iterating over a string

:::{solution} str-iter
:label: str-iter-solution
:::

```{code-cell} rust
let s = "Салам";

println!("Iterating over the characters:");
for c in s.chars() {
  print!("{c}, ");
}
println!();

println!("Iterating over the bytes:");
for b in s.bytes() {
  print!("{b}, ");
}
```

Each character is defined by more than one byte.

## Searching into a string

:::{solution} str-search
:label: str-search-solution
:::

We define the original string in which to search for lowercase
characters:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let s = "AbCDeFGHijkL";
```

We define a new slice variable, mutable, that we will use to store a
reference (i.e.: slice) to the remaining string part to search:

```{code-cell} rust
:class: seq-cont badges border

let mut t = s;
```

We loop on the results of the `find()` method, which is called with the
predicate `char::is_lowercase` to find the next lowercase character.
During the loop, we update the slice variable `t` in order for it to be
ready for next call to `find()`:

```{code-cell} rust
:class: seq-stop badges border

while let Some(i) = t.find(char::is_lowercase) {
  print!("{}", &t[i..i+1]);
  t = &t[i+1..];
}
```

## Vector of strings

:::{solution} vec-str
:label: vec-str-solution
:::

We create an empty vector. There is no need to define the type of
elements stored inside the vector, because the compiler will wait to
see what we put in it to deduce this type:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

let mut v = Vec::new();
```

We push the three strings into the vector, the compiler now knows that
our vector is a vector of `String` instances:

```{code-cell} rust
:class: seq-cont badges border

v.push(String::from("abc"));
v.push(String::from("def"));
v.push(String::from("ghi"));
```

We loop on the vector's elements by references and print each string:

```{code-cell} rust
:class: seq-stop badges border

for s in &v {
  println!("{s}");
}
```

## Strings in struct

:::{solution} str-struct
:label: str-struct-solution
:::

We define the `Book` structure with the two fields `title` and `author`
as `String` instances:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Book {
  title: String,
  author: String,
  year: i16,
}
```

When defining the `new()` constructor, we *move* the arguments `title`
and `author` into the new `String` instance:

```{code-cell} rust
:class: seq-cont badges border

impl Book {

  fn new(title: String, author: String, year: i16) -> Self {
    Self {
      title,
      author,
      year,
    }
  }
}
```

One way to implement the access methods of the two string fields
`title` and `author`, is to return clones:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

impl Book {

  fn title(&self) -> String {
    self.title.clone()
  }

  fn author(&self) -> String {
    self.author.clone()
  }
}
```

However, this would create a new object each time we want to access a
field's value. This is not optimal, since most of the time we just want
to read the value, not modify it. A better approach is to return string
slices (see [Slices](#chp-slices)) that will be valid during the whole
lifetime of the Book instance (see [Lifetimes](#chp-lifetimes)):

```{code-cell} rust
:class: seq-cont badges border

impl Book {

  fn title(&self) -> &str {
    &self.title
  }

  fn author(&self) -> &str {
    &self.author
  }
}
```

```{code-cell} rust
:class: seq-cont badges border

impl Book {

  fn year(&self) -> i16 {
    self.year
  }
}
```

```{code-cell} rust
:class: seq-stop badges border

let book = Book::new("Robinson Crusoe".to_string(), "Daniel Defoe".to_string(),
  1719);
(book.title(), book.author(), book.year())
```
