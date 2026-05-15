# Introduction

Macros are a *metaprogramming* feature of a language.
They can be found in languages like C/C++ or Julia.
Macros are not part of the language itself, they are processed by the
*pre-processor* which expands them into language code *before* the *real*
parsing of the code.
Macros allow us to define a block and repeat it wherever we need it.
In Rust, macros are devided into:

- *Declarative* macros.
- *Procedural* macros, in which we find the following three sub-categories:
  - Custom `derive` macros.
  - Attribute-like macros.
  - Function-like macros.
