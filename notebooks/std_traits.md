(chp-std-traits)=
# Traits of the Standard library

We list in {numref}`tab-std-traits` some of the most common *traits*
of the *standard library*.

:::{danger} TODO
Show existing traits for primitive types.
:::

Among them are the comparison operators from the
[cmp](https://doc.rust-lang.org/std/cmp/index.html) module. Other
operators (`*`, `/`, `+`, `%`, ...) are defined inside the
[ops](https://doc.rust-lang.org/stable/std/ops/index.html) module.
They are listed inside the
[Traits](https://doc.rust-lang.org/stable/std/ops/index.html#traits)
section.

:::{list-table} Some of the most common traits
:name: tab-std-traits
:header-rows: 1
:align: center

* - Trait
  - Description
* - [Clone](https://doc.rust-lang.org/std/clone/trait.Clone.html)
  - To make a object clonable.
* - [Copy](https://doc.rust-lang.org/std/marker/trait.Copy.html)
  - Reserved for copiable types.
* - [Debug](https://doc.rust-lang.org/std/fmt/trait.Debug.html)
  - To provide the Debug formatter.
* - [Display](https://doc.rust-lang.org/std/fmt/trait.Display.html)
  - To provide the Display formatter.
* - [Default](https://doc.rust-lang.org/std/default/trait.Default.html)
  - To set a default value for a type.
* - [Eq](https://doc.rust-lang.org/std/cmp/trait.Eq.html)
  - Like `PartialEq` plus reflexivity (`a == a`).
* - [Ord](https://doc.rust-lang.org/std/cmp/trait.Ord.html)
  - Like `PartialOrd` plus `min()`, `max()` and `clamp()`.
* - [PartialEq](https://doc.rust-lang.org/std/cmp/trait.PartialEq.html)
  - To provide operators `==` and `!=`.
* - [PartialOrd](https://doc.rust-lang.org/std/cmp/trait.PartialOrd.html)
  - To provide operators `<`, `<=`, `>` and `>=`.
:::
