# LinkedList

:::{warning} To review
:class: readiness-toreview

:::

The `LinkedList` structure is a *doubly-linked* list as shown in
{numref}`fig-linked-list`.
It allows appending or removal, in constant time (i.e.: 𝒪(1)), of
elements at each end.
Searching for an element is in 𝒪(n), since it requires to iterate over
the list.

:::{warning} LinkedList vs Vec
A `Vec` or `VecDeque` is in general preferred to a `LinkedList`
because vectors are implemented as arrays (i.e.: contiguous memory in
which elements are stored in order) and thus:

- Are faster to access.
- Use less memory.
- Make a better use of CPU cache.

However a `LinkedList` will always offer a 𝒪(1) performance for push
operations, which vectors will trigger 𝒪(n) copy operation when they
need to grow.
:::

:::{code-block} text
:name: fig-linked-list
:caption: A doubly-linked list

                 ┌────┐     ┌────┐     ┌────┐     ┌────┐
push_front() ──> │    │ ──> │    │ ──> │    │ ──> │    │ <── push_back()
   O(1)          │ 10 │     │  5 │     │ 47 │     │ 13 │        O(1)
 pop_front() <── │    │ <── │    │ <── │    │ <── │    │ ──>  pop_back()
                 └────┘     └────┘     └────┘     └────┘
:::

Main methods of the `LinkedList` structure can be seen in
{numref}`tab-linked-list`.

:::{list-table} Some methods of `LinkedList`
:name: tab-linked-list
:header-rows: 1
:align: center

* - Method
  - Description
* - `append(other)`
  - Appends another `LinkedList` object to this one.
* - `back()`
  - Provides a reference to the back element.
* - `clear()`
  - Removes all elements.
* - `contains(v)`
  - Returns `true` if this list contains the value `v`. 𝒪(n) time.
* - `front()`
  - Provides a reference to the front element.
* - `is_empty()`
  - Returns `true` if this list contains no elements.
* - `iter()`
  - Returns a front-to-back iterator.
* - `len()`
  - Returns the number of elements.
* - `new()`
  - Creates a new list.
* - `pop_back()`
  - Removes the back element and returns it.
* - `pop_front()`
  - Removes the front element and returns it.
* - `push_back(v)`
  - Appends an element to the back.
* - `push_front(v)`
  - Appends an element to the front.
* - `split_off(i)`
  - Splits the list into two at the given index.
:::

## Create

:::{danger} TODO
:class: readiness-todo

Show `new()` usage.
:::

## push/pop

:::{danger} TODO
:class: readiness-todo

Show `push()`/`pop()` usage.
:::

## Searching

:::{danger} TODO
:class: readiness-todo

Show searching inside a list.
:::

## split_off

:::{danger} TODO
:class: readiness-todo

Show `split_off()` usage.
:::

:::{danger} TODO
:class: readiness-todo

Add exercise.
:::
