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

# Installing

To get access to Rust, one may install a system package on \*nix platforms
(Homebrew on macOS), use the `rustup` script, install an IDE (all platforms),
or use a package manager like Chocolatey or Scoop on Windows.
See all the main installation methods on
[Install Rust](https://rust-lang.org/tools/install/) official page, we will
only briefly cover some of them here.

## `rustup`

The *Rust toolchain* is best installed through `rustup`, a tool dedicated to
the toolchain management.

`rustup` is found in package repository of Ubuntu (`apt search rustup`), or
[Homebrew](https://brew.sh/) on MacOS (`brew search rustup`).
If not found as an official package on a \*nix platform, `rustup` can be
downloaded and installed directly from the
[Install Rust](https://rust-lang.org/tools/install/) page.

On Windows, we may either use the [Scoop](https://scoop.sh/) package
manager or download the `rustup-init.exe` executable from the
[Other installation methods](https://rust-lang.github.io/rustup/installation/other.html)
page.

Once installed, we install the stable version or Rust:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

rustup default stable
```

## IDEs

### VS Code

See
[Rust in Visual Studio Code](https://code.visualstudio.com/docs/languages/rust)
to install Rust inside VS Code.

### RustRover

See
[RustRover](https://www.jetbrains.com/help/rust/getting-started.html) to
install RustRover IDE from [JetBrains](https://www.jetbrains.com/).
