---
jupytext:
  text_representation:
    extension: .md
    format_name: myst
kernelspec:
  name: bash
  display_name: Bash
  language: bash
---

(chp-howto-path)=
# `PATH` env var

:::{warning} To review
:::

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

The `PATH` environment variable contains a list of folder paths in
which to look for executables:

```{code-cell} bash
:class: dark-background full-color-output

echo $PATH
```

If an application we want to run has not its folder listed inside
`PATH`, we cannot run it, unless we specify the path to find it.

In order to show an example, we will create a shell script and put
inside a subfolder.

Here is the creation of the sub-folder:

```{code-cell} bash
:class: dark-background full-color-output

mkdir -p my/sub/folder
```

And the script creation:

```{code-cell} bash
:tags: [remove-cell]

bat >my/sub/folder/a_script.sh <<EOF
#!/bin/bash
echo "Hello!"
EOF
```

We now make the script executable:

```{code-cell} bash
:class: dark-background full-color-output

chmod u+x my/sub/folder/a_script.sh
```

The script is in the following location:

```{code-cell} bash
:class: dark-background full-color-output

exa -T my
```

And its content is correct:

```{code-cell} bash
:class: dark-background full-color-output

bat my/sub/folder/a_script.sh
```

However, if we try to run it by its name, the shell complains that
it cannot find it:

```{code-cell} bash
:class: dark-background full-color-output
:tags: [raises-exception]

a_script.sh
```

This is because the shell does not know where to find the script.
We can only run it if we specify explicitly the path to find it:

```{code-cell} bash
:class: dark-background full-color-output

my/sub/folder/a_script.sh
```

To make it findable by the shell, we need to add its folder to the
`PATH` variable:

```{code-cell} bash
:class: dark-background full-color-output

PATH="$PATH:my/sub/folder"
```

Then, by looking in each folder of the `PATH` environment variable,
the shell is able to find the script:

```{code-cell} bash
:class: dark-background full-color-output

a_script.sh
```

Unfortunately, the modification of the `PATH` we have just done is
only valid for the *current* shell session. If we open a new
session, we will have to do the same modification again.
To avoid this, we need to set the `PATH` modification inside the
`$HOME/.bash_profile` configuration file for bash.
Edit or create the file `$HOME/.bash_profile` and append the
following line:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

PATH="$PATH:my/sub/folder"
```

The next time we log in, the file will be read and the `PATH`
modified.
For now, we only have to *source* the file explicitly in order to
get the modification:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

source $HOME/.bash_profile
```
