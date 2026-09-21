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

# Generic function

Here is an example of a *generic* function. It takes a single parameter
`T` and uses it to define the type of its single argument:

```{code-cell} rust
fn get_length<T>(v: &[T]) -> usize {
  v.len()
}

let arr = [16, -10, 120];
get_length(&arr)
```

The previous function does not do anything useful, and thus does not put
any constraint on the type `T`. Usually, we use `T` inside the function's
code, like calling one of its methods or using an operator on it. This
implies that `T` must provide some *abilities*.
The following example needs the `T` type to be compared using the `>`
operator. This implies that `T` must implement the `PartialOrd` trait.
The function returns the highest element in an array of any type `T`:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

use std::cmp::PartialOrd;

fn largest<T: PartialOrd>(arr: &[T]) -> &T {
  let mut largest = &arr[0];

  for item in arr {
    if item > largest {
      largest = item;
    }
  }

  largest
}
```

We apply the function first on a list of integers:

```{code-cell} rust
:class: seq-cont badges border

{
  let number_list = vec![34, 50, 25, 100, 65];
  let result = largest(&number_list);
  println!("The largest number is {result}");
}
```

:::{important} Type inference
When calling `largest()`, we did not precise the parameter `T`.
This is because the compiler used type inference to deduce `T` from the
type of `number_list`. `number_list` itself had its type deduced the
line before when using `vec![]` to set it, by looking at the integer
values, which themselves were set to `i32` type, as it is the *default*
integer type for Rust.
:::

Now we apply it on a list of characters:

```{code-cell} rust
:class: seq-stop badges border

{
  let char_list = vec!['y', 'm', 'a', 'q'];
  let result = largest(&char_list);
  println!("The largest char is {result}");
}
```

:::{exercise} Getting an environment variable (★★★☆☆)
:label: gen-fct-env-var
:enumerated: true

Write a generic function that:

- Takes the name of an environment variable. See
  [Environment variables](#chp-howto-env-vars) about environment
  variables.
- Takes a default value.
- Tries to read the environment variable's value and convert it into a
  desired type.
- Returns the value if found, otherwise returns the default value.

Use this function to get the environment variables:

- `HOST` (default value `"localhost"`).
- `PORT` (default value `8080`).
:::

[see solution](#gen-fct-env-var-solution)
