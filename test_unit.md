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

# Unit tests

:::{danger} Draft
This section is still being written.
:::

They are placed in a module named `tests` and annotated with
`cfg(test)` in each source file:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
// ... some code

#[cfg(test)]
mod tests {
  // the unit tests
}
```

The annotation tells `cargo` to only include the following code when
the named configuration (i.e.: `test`) is used.

Testing of private functions is allowed in unit tests:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
fn foo(...) -> ... {
  // ...
}

#[cfg(test)]
mod tests {
  #[test]
  fn test_foo() {
    // ...
  }
}
```

A function with its test:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled
pub fn add(left: u64, right: u64) -> u64 {
    left + right
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }

    #[test]
    fn test_panic() {
        panic!("Make this test fail");
    }

    #[test]
    fn test_with_custom_msg() {
        assert!(...), "My custom failure message"
    }

    #[test]
    #[should_panic]
    fn test_catch_panic() {
        foo(...) // function that raises panic
    }

    #[test]
    #[should_panic(expected = "some text from panic message")]
    fn test_catch_panic() {
        foo(...) // function that raises panic
    }

    #[test]
    fn test_that_returns_a_Result() -> Result<(), String> {
        let result = foo(...);

        if result == ... {
            Ok(())
        } else {
            Err(String::from("some message."))
        }
    }
}
```

Assert macros:

- `assert_eq!`
- `assert!`
