---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
    format_version: 0.13
    jupytext_version: 1.19.2
kernelspec:
  name: bash
  display_name: Bash
  language: bash
---

# Examples

Many examples are found throughout this book.

A tiny tag black on the top right of the example indicates the language
or syntax of the example.

The following example uses the Bash shell as stated by the tag `bash`
placed on the right:

```{code-cell} bash
:class: dark-background full-color-output

echo "Hello!"
```

This example, as most examples in this book, is followed by an *output*
that is shown on *black background* just after the code snippet.
This means the code has been tested automatically when generating this
book, and the black output is the result of this execution.

When no output is shown, this does not mean the code snippet was not
run, but only that the commands did not generate any output.
Code snippet that were *not run* during the construction of the book,
are indicated with a *disabled* tag. This does not mean that you should
not run the command. This just means that it was not possible to execute
and test this particular code snippet while generating the book.

Example of a *disabled* cell:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

# this command is not actually executed when building the book
echo "this command is not actually executed..."
```

Some examples are divided in multiple *snippets* (a.k.a: *cells*). In
that cases, a set of tags indicate the *beginning* and the *end* of the
example. The first snippet is tagged with **start**, the last one with
**stop**, and the snippets in between with **cont**.

Example:

```{code-cell} bash
:class: dark-background full-color-output seq-start badges border

echo "First cell"
```

```{code-cell} bash
:class: dark-background full-color-output seq-cont badges border

echo "Second cell"
```

```{code-cell} bash
:class: dark-background full-color-output seq-stop badges border

echo "Third cell"
```
