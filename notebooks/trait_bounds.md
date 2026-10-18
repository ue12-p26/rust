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

# Using trait bounds

:::{warning} To review
:class: readiness-toreview

:::

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

trait Media {
  fn title(&self) -> &str;
  fn duration(&self) -> std::time::Duration;
}
```

Traits can be used as types of function arguments, using the `impl`
keyword. This keyword means that the concrete type will be decided
at *compile time*. Since multiple concrete types can be used with
this function as long as they implement the required trait, the
compiler will *generate* a function for each concrete type used:

```{code-cell} rust
:class: seq-cont badges border

fn info_media(f: &impl Media) {
  println!("Movie \"{}\" lasts {} minutes.", f.title(),
           f.duration().as_secs() / 60);
}
```

:::{important} Generic version
The following generic version of the previous function is strictly
equivalent to the `impl` version:
:::

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn info_media<T: Media>(f: &T) {
  println!("Movie \"{}\" lasts {} minutes.", f.title(),
           f.duration().as_secs() / 60);
}
```

:::{warning} Two arguments
The `impl` keyword is not always usable to describe what we want.
The generic version is more powerful. In the following example, the
function would not compile, because the two *tuples* returned by the
`if/else` expression could not have the same type. This is because
the requirement of implementing the `Media` trait does not imply
that both `f1` and `f2` have the same concrete type:
:::

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn compare_medias(f1: &impl Media, f2: &impl Media) {
  let (longest, shortest) = if f1.duration() > f2.duration() {(f1, f2)}
                            else {(f2, f1)};
  println!("Movie \"{}\" lasts longer than movie \"{}\".",
           longest.title(), shortest.title());
}
```

Using the generic notation, we can express the fact that `f1` and
`f2` must have the same concrete type that implements the `Media`
trait:

```{code-cell} rust
:class: seq-cont badges border

fn compare_medias<T: Media>(f1: &T, f2: &T) {
  let (longest, shortest) = if f1.duration() > f2.duration() {(f1, f2)}
                            else {(f2, f1)};
  println!("Movie \"{}\" lasts longer than movie \"{}\".",
           longest.title(), shortest.title());
}
```

We need a `Movie` structure to test our trait:

```{code-cell} rust
:class: seq-cont badges border

struct Movie<'a> {
  title: &'a str,
  duration: std::time::Duration,
}
```

With the trait implementation:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> Media for Movie<'a> {

  fn title(&self) -> &'a str {
    self.title
  }

  fn duration(&self) -> std::time::Duration {
    self.duration.clone()
  }
}
```

We define two movies:

```{code-cell} rust
:class: seq-cont badges border

let movie1 = Movie {
  title: "Despicable Me",
  duration: std::time::Duration::from_mins(95),
};
let movie2 = Movie {
  title: "Despicable Me 2",
  duration: std::time::Duration::from_mins(98),
};
```

The two functions are tested using the two movies:

```{code-cell} rust
:class: seq-stop badges border

info_media(&movie2);
compare_medias(&movie1, &movie2);
```

## Multiple traits

It is possible to have multiple trait bounds on the same argument,
using the `+` sign to link them.

Let us first define another trait for playing a video:

```{code-cell} rust
:class: seq-start badges border

trait Video {
  fn play_on_screen(&self);
}
```

We implement this new trait for the `Movie` structure:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> Video for Movie<'a> {
  fn play_on_screen(&self) {
    println!("Playing video {}...", self.title);
  }
}
```

We define now a function to play a video that takes an item that
implements the two traits `Media` and `Video`:

```{code-cell} rust
:class: seq-cont badges border

fn play_video(x: &(impl Media + Video)) {
  println!("Video: {}, length: {} min",
           x.title(), x.duration().as_secs() / 60);
  x.play_on_screen();
}
```

This function could also be defined directly as a *generic*:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn play_video<T: Media + Video>(x: &T) {
  println!("Video: {}, length: {} min",
           x.title(), x.duration().as_secs() / 60);
  x.play_on_screen();
}
```

Here is the invocation of the function with a movie instance:

```{code-cell} rust
:class: seq-stop badges border

play_video(&movie1);
```

## Returning a trait

Returning a trait is also possible. Here is the `impl` syntax with
two traits bound:

```{code-cell} rust
:class: seq-start badges border

fn get_video() -> impl Media + Video {
  Movie {
    title: "Despicable Me 3",
    duration: std::time::Duration::from_mins(90),
  }
}
```

```{code-cell} rust
:class: seq-stop badges border

{
  let movie3 = get_video();
  info_media(&movie3);
}
```

:::{important} Generic version
The following generic version would not compile:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

fn get_video<T: Media + Video>() -> T {
  Movie {
    title: "Despicable Me 3",
    duration: std::time::Duration::from_mins(90),
  }
}
```

This is because with this declaration, the caller is allowed to ask
for a generic function that returns any type that implements
`Media + Video`, not just `Movie`. To solve this, we need to create
another trait that is used to build an object.
:::

For instance, we define a trait to build an object from a title and
a duration:

```{code-cell} rust
:class: seq-start badges border

trait FromTitle<'a> {
  fn from_title(title: &'a str, duration: std::time::Duration) -> Self;
}
```

Then we implement it for `Movie`:

```{code-cell} rust
:class: seq-cont badges border

impl<'a> FromTitle<'a> for Movie<'a> {
  fn from_title(title: &'a str, duration: std::time::Duration) -> Self {
    Movie { title, duration }
  }
}
```

We now add the `FromTitle` as a bound and use its constructor
method:

```{code-cell} rust
:class: seq-cont badges border

fn get_video_bis<'a, T: Media + Video + FromTitle<'a>>() -> T {
  T::from_title("Despicable Me 3", std::time::Duration::from_mins(90))
}
```

To use it we need now to specify the wanted type (here `Movie`):

```{code-cell} rust
:class: seq-stop badges border

let movie3: Movie = get_video_bis();
info_media(&movie3);
```

## Where clause

The `where` clause allows for clearer declarations. For instance, in
the following function we want to merge two different video files,
with possibly different types. We express the trait bounds inside the
`where` clause, making the function header clearer:

```{code-cell} rust
:class: seq-start badges border

fn merge_videos<'a, T, U>(t: &T, u: &U) -> T
  where
  T: Media + Video + FromTitle<'a>,
  U: Media + Video,
{
  println!("Merging \"{}\" with \"{}\".", t.title(), u.title());
  // Merging T with U...
  T::from_title("Merged movies", t.duration() + u.duration())
}
```

Here is the execution:

```{code-cell} rust
:class: seq-stop badges border

let merged = merge_videos(&movie1, &movie2);
info_media(&merged);
```

(chp-bound-gen-method)=
## Bounding a generic method

*Trait bounds* can also be used to specialize partially a generic
type, and implement methods only for this specialization.

For instance given the following generic structure:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

struct Bag<T> {
  items: Vec<T>,
}
```

We may define the following method that will exist only for
primitive integers. This example requires the external `num_traits`
crate, which is not available in this notebook's kernel, so it is
shown but not executed:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

use num_traits::PrimInt;

impl<T: PrimInt> Bag<T> {
  fn sum(&self) -> T {
    let mut s: T = T::zero();
    for n in &self.items {
      s = s + *n;
    }
    s
  }
}
```

If we define the following bag of integers:

```{code-cell} rust
:class: seq-cont badges border

let bag = Bag { items: vec![1, 20, -4, 5] };
```

We would then be able to call the `sum()` method:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

bag.sum()
```

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
