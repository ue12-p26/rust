(chp-poly)=
# What is polymorphism?

In computer science,
[polymorphism](https://en.wikipedia.org/wiki/Polymorphism_(computer_science))
is the mechanism through which the *same* language object (e.g.: function,
structure, class, method, operator, ...) can take different forms, either
at *compile-time* or at *runtime*.

## Compile-time polymorphism

*Compile-time* polymorphism, also called *parametric* polymorphism, let us
define one or more parameters for a single language object. *Parametric*
objects are not concrete, they never appear as-is inside the final
executable program. They are more like skeletons of code from which we
may generate one or more versions, depending of what values we choose for
the parameters. The parameters are placeholders for other language
objects, typically types, structures or base values like integers or
booleans, that can either be *fixed* by the developer or *deduced* from
the context by the compiler.

In {numref}`fig-param-poly`, we define a parametric function `add(T,T)`
whose code is generic. When using it the compiler generates the needed
version. For instance if we use it on 32 bit integers, the compiler will
generate `add<Int32>()`. So among all the possible versions of `add(T,T)`
only the ones really used are generated. The same exact code is generated
multiple times by the compiler, but we have only written one function,
and we have only one to maintain.

:::{figure} media/param_poly.svg
:name: fig-param-poly
:alt: Parametric polymorphism
:width: 80%

Parametric polymorphism
:::

## Runtime polymorphism

*Runtime* polymorphism is a mechanism through which an object can be
viewed in different ways during execution. Objects may be stored as their
original type or as any view they provide. When required, we test if an
object provides a certain view, and we transform it into this view.

{numref}`fig-runtime-poly` shows a set of types representing animals that
we may use for instance in a game. The animals are `Crocodile`, `Lizard`,
`Crow`, `Dolphin`. We have link each animal to a group (`Reptile`, `Bird`,
`Mammal`). These groups are our *views*. At runtime we may transform each
of our animal into its group/view. The view `Animal` represents a
super-group for all animals. The view `CanSwim`, `CanWalk`, `CanFly`
represent the capabilities of our animals. Below we find a list of
functions that may be applied to our animals. For instance the
`get_feather_type(Bird)` may be called on any animal object that provides
the `Bird` view.

:::{warning} Real runtime polymorphism is not always needed
The required view for an object may be known at compile-time. For
instance if we have a `Crocodile` object, the compiler knows it has the
`CanSwim` and the `CanWalk` abilities, that it is a `Reptile` and also an
`Animal`. Hence, the object will be transformed into the required view
when needed, at compilation. For instance the `make_fly(CanFly)` function
may be called directly on a `Crow` object, the compiler will transform
the object automatically.
However, once objects are transformed into views, we cannot transform
them into other views at compile time. We need runtime polymorphism. For
instance if we store objects of types `Crocodile`, `Lizard`, `Crow`, etc
as `Animal` into a collection, we need runtime polymorphism to get their
`CanSwim`, `CanWalk` and `CanFly` views.
:::

:::{figure} media/runtime_poly.svg
:name: fig-runtime-poly
:alt: Runtime polymorphism
:width: 80%

Runtime polymorphism
:::
