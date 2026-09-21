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

# Box

:::{danger} Draft
This section is still being written.
:::

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

let shapes: Vec<Box<dyn Shape>> = vec![
  Box::new(Circle { radius: 2.0 }),
  Box::new(Rectangle { width: 3.0, height: 4.0 }),
];

for shape in &shapes {
  println!("{}", shape.describe());
}
```
