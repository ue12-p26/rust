# BTreeSet

:::{danger} TODO
:class: readiness-todo

Present this collection.
:::

:::{code-block} text
:name: fig-btreeset
:caption: A BTreeSet with integer values, using a maximum of 4 values per node.

                ┌────┬────┬────┬────┐
                │ 10 │ 16 │ 23 │    │
                └────┴────┴────┴────┘
               ╱           ╲
              ╱             ╲
             ╱               ╲
┌────┬────┬────┬────┐     ┌────┬────┬────┬────┐
│  2 │  5 │    │    │     │ 17 │ 19 │ 21 │ 22 │
└────┴────┴────┴────┘     └────┴────┴────┴────┘
:::
