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

# Attribute-like macros

The *attribute-like* macro is a type of *procedural* macro that attaches an
attribute to an item.

The following macro would be defined by a web framework to link the function
to a particular route at compile time:

```{code-cell} rust
:tags: [skip-execution]
:class: disabled

#[get("/users")]
async fn list_users() -> impl Responder {
    ...
}
```
