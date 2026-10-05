# Introduction

A *method* is a function that is attached to a type. To define
*methods* for a type, we use the `impl` keyword onto the name of our
type and define the functions inside.

There exist two types of methods:

- *Static* methods: they do not reference an existing instance and are
  called using the type name (e.g.: `MyStruct::new()`). They are
  usually used to construct an object.
- *Instance* methods: they refer to an instance on which their code
  applies. They are called on an instance (e.g.: `my_obj.foo()`).
