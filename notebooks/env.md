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

# Process environment

:::{warning} To review
:class: readiness-toreview

:::

Almost every useful program needs some input from the outside world before
it starts working:

- General information:
  - Name of the process' executable file.
  - Path to the current user's home folder.
  - Access to a temporary directory.
  - ...
- Custom information:
  - A file to read.
  - A number of iterations.
  - A flag that turns on extra logging.
  - ...

Some *operating system* calls give *general information*. Then there exist
two main ways to provide *custom information*:

- Environment variables.
- Command line arguments.

The [std::env](https://doc.rust-lang.org/std/env/index.html) module
provides function to get that information. Some of its functions are
listed in {numref}`tab-env-fcts`.

:::{list-table} Some functions of the env module
:name: tab-env-fcts
:header-rows: 1
:align: center

* - Method
  - Description
* - `args()` & `args_os()`
  - Returns an iterator on the command line arguments, the first argument
    being the path used to invoke the executable. Arguments are returned
    as `String` values with `arg()` and `OsString` values with
    `args_os()`.
* - `current_dir()`
  - Returns the current working directory as a `PathBuf`.
* - `current_exe()`
  - Returns the full file system path of the current running executable.
* - `home_dir()`
  - Returns the path to the current user's home directory.
* - `join_paths(iter)`
  - Joins the paths returned from the iterator `iter` in the style used
    by the platform to build the `PATH` environment variable, and
    returns the result as an `OsString`.
* - `set_current_dir(p)`
  - Changes the current working directory.
* - `split_paths(p)`
  - Parses `p` by splitting it according to platform conventions for the
    `PATH` environment variable, and returns an iterator on the
    extracted paths.
* - `temp_dir()`
  - Returns the operating system temporary directory. It may be shared
    among users, like on traditional *UNIX* systems with the `/tmp`
    folder.
* - `var(k)` & `var_os(k)`
  - Returns the value of the environment variable `k`. Returns
    `VarError::NotPresent` if the variable is not set, and
    `VarError::NotUnicode` if the value is not valid *Unicode* (when
    using `var(k)`. `var(k)` returns a `String` while `var_os(k)`
    returns an `OsString`.
* - `vars()` & `vars_os()`
  - Returns an iterator on the environment variables returned as pairs
    of strings (variable's name, value). `vars()` returns `String`
    values, while `vars_os()` returns `OsString` values.
:::

Environment variables related functions will be covered in
[Environment variables](#chp-envvars), and command line arguments related
functions in [Command line arguments](#chp-cmdlineargs).

## Current working directory

Every process is linked to a *current working directory*. This is from
this folder that are computed *relative paths* to files or other folders.

The `current_dir()` function returns the path to the *current working
directory*:

```{code-cell} rust
std::env::current_dir()
```

We can change the *current working directory* with the
`set_current_dir()` function:

```{code-cell} rust
:class: seq-start badges border

std::env::set_current_dir("/home")
```

The `current_dir()` returns now the new value:

```{code-cell} rust
:class: seq-stop badges border

std::env::current_dir()
```

## Home directory

The `home_dir()` returns the path to the current user's home directory.
This directory is often used to access configuration files, store cache
files, etc.

Here is the output of the function in our case:

```{code-cell} rust
std::env::home_dir()
```

:::{important} Usage of the HOME folder
Traditionally on *UNIX*, configuration files were stored directly inside
the `HOME` folder, as hidden files or folders (i.e.: in *UNIX*, if a name
starts with a dot (`.`), it is hidden from the default list of files and
folders). This is not the case anymore, and more specific folders are
used now for configuration files and cache files. We will see more about
this in [Application folders](#chp-appfolders).
:::

## Temporary directory

The `temp_dir()` function returns the temporary system folder, in which
we can create temporary files:

```{code-cell} rust
std::env::temp_dir()
```

:::{important} File system cluttering
On system cleanup or reboot, the content of the temporary folder is
deleted. However applications have to delete all their temporary files
or folders before exiting, in order to avoid cluttering the file system.
We will see in [Temporary files and folders](#chp-tmp) safe ways to
create temporary files and folders that are automatically deleted when
dropped.
:::
