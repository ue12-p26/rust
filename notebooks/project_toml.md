# Project file Cargo.toml

:::{warning} To review
:class: readiness-toreview

:::

The `Cargo.toml` file uses the [TOML](https://toml.io/) format. See
the example in {numref}`listing-cargo-toml-ex`. It is divided in
multiple sections denoted by square brackets (`[]`):

- The `package` section regroups all the description of the package
  itself. See {numref}`tab-package-fields` for a description of each
  field and the official format in
  [The Manifest Format](https://doc.rust-lang.org/cargo/reference/manifest.html).
- The `dependencies` section gathers all crates this package needs to
  compile.
- There can be at most *one* `lib` section. It describes a binary
  library to generate. If this section is not defined, but the file
  `src/lib.rs` exists, it will be used as the default library.
- There can be any number of `bin` sections. The double square
  brackets (`[[]]`) means that it is an array. Each `[[bin]]` section
  describes a binary program to generate. The `path` key gives the
  code source file that contains the entry point (e.g.: the `main()`
  function). If no `bin` section is provided, and a file
  `src/main.rs` exists, then a default `bin` section is created with
  the file as the main source file and as a name the name of the
  package.

:::{list-table} The fields of the package section
:name: tab-package-fields
:header-rows: 1
:align: center

* - Field
  - Description
* - `name`
  - The package name.
* - `version`
  - The package version.
* - `edition`
  - The Rust edition used to compile the package.
* - `license`
  - The package license. Note the `AND` keyword that allows to
    combine two licenses. In the example we use the two French
    licenses CeCILL-B and CeCILL-C from CEA, CNRS and INRIA. See
    [CeCILL](https://cecill.info/index.en.html). See
    [SPDX license List](https://spdx.github.io/spdx-spec/v2.3/SPDX-license-list/).
* - `description`
  - A package description.
* - `documentation`
  - URL to the package's documentation.
* - `homepage`
  - URL to the package's homepage, if different from documentation
    and repository URLs.
* - `repository`
  - The URL to the package's repository.
* - `authors`
  - The authors (array format).
* - `readme`
  - The README file.
* - `exclude`
  - An array of files to exclude from the package. Those files will
    not be published.
* - `categories`
  - An array of up to 5 categories in which to classify this package.
    See
    [All Valid Category Slugs](https://crates.io/category_slugs).
* - `keywords`
  - An array of up to 5 keywords, used when searching for a crate on
    the registry. Any word is accepted.
:::

:::{code-block} toml
:name: listing-cargo-toml-ex
:caption: Example of a Cargo.toml file

[package]
name = "ansiconv"
version = "1.2.3"
edition = "2024"
license = "CECILL-B AND CECILL-C"
description = "A library and tools to parse ANSI escape codes from text."
repository = "https://gitlab.com/cnrgh/infotools/ansiconv"
authors = ["Pierrick Roger <pierrick.roger@cea.fr>"]
readme = "README.md"
exclude = ["Makefile"]
categories = ["command-line-utilities"]
keywords = ["shell", "library", "ANSI", "escape", "text"]

[dependencies]
build_html = "2.8.0"
clap = { version = "4.6.1", features = ["derive"] }
env_logger = "0.11.10"
glob = "0.3.3"
log = "0.4.32"

[lib]
path = "src/lib.rs"
test = true

[[bin]]
name = "ansi2tex"
path = "src/cli_ansi2tex.rs"

[[bin]]
name = "ansi2html"
path = "src/cli_ansi2html.rs"
:::
