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

# Polymorphism with enums

Runtime polymorphism can be achieved easily with enum's variants. All
variants of an enum have the same enum type and thus can be put together
in the same collection. Each time an enum's value must be processed, the
compiler will check if we have taken into account all defined variants.
This is particularly useful when adding new variants to an enum.

As an example, let us suppose we want to store key/value pairs inside a
dictionary. The keys are all strings, but values are either signed
integers, boolean, floats or strings. To achieve this, we may define the
following enum type:

```{code-cell} rust
:tags: [remove-cell]

:clear
```

```{code-cell} rust
:class: seq-start badges border

#[derive(Debug)]
enum Value {
  Int(i32),
  Bool(bool),
  Float(f32),
  Str(String),
}
```

Then we can fill a dictionary using this enum:

```{code-cell} rust
:class: seq-cont badges border

let mut dict: std::collections::HashMap<String, Value> = std::collections::HashMap::new();
dict.insert(String::from("a"), Value::Float(3.1));
dict.insert(String::from("b"), Value::Str(String::from("abc")));
dict.insert(String::from("c"), Value::Int(10));
dict.insert(String::from("d"), Value::Bool(false));
```

When getting a value from the dictionary, we need to process each
variant:

```{code-cell} rust
:class: seq-stop badges border

if let Some(v) = dict.get("c") {
  match v {
    Value::Int(n)   => println!("Integer value: {n}"),
    Value::Bool(b)  => println!("Boolean value: {b}"),
    Value::Float(x) => println!("Float value: {x}"),
    Value::Str(s)   => println!("String value: {s}"),
  }
}
```
