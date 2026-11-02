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

```{code-cell} bash
:tags: [remove-cell]

source bash-setup.sh
```

To install Rust, we present here three methods that we will detail for
each operating system:

- `rustup`: a command line only setup.
- [VS Code](https://code.visualstudio.com/): The
  [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment)
  from [Microsoft](https://www.microsoft.com/).
- [RustRover](https://www.jetbrains.com/rust/): The
  [IDE](https://en.wikipedia.org/wiki/Integrated_development_environment)
  from [JetBrains](https://www.jetbrains.com/).

## Linux

Linux is by far the easiest platform to install Rust on.
We must look for and install the following packages:

1. `gcc`.
2. `rustup`.

If no package is provided for `rustup` on our platform, then we use
the command line provided on the `rustup` website's main page.
Once `rustup` is installed, go to [Rustup usage](#chp-rustup-usage) for
the next instructions.

We may also install VS Code IDE:

1. Install VS Code by using the package manager or by following
   instructions on
   [https://code.visualstudio.com/docs/setup/linux](https://code.visualstudio.com/docs/setup/linux).
2. Once inside VS Code, install the extension
   [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer).
3. VS Code should use the *Rust tool chain* installed by `rustup`.
4. Test the installation by creating a new project, opening a terminal
   window and running `cargo build` to compile the project.

We may also install RustRover IDE:

1. Install RustRover by using the package manager.
2. Like VS Code, RustRover should use the *Rust tool chain* installed
   by `rustup`.

## macOS

Installing on macOS is best done through
[Homebrew](https://brew.sh/).
Homebrew is a package manager for macOS. It allows to install many
packages coming from the GNU/Linux world.

1. Open the `Terminal` application.
2. Install first the
   [Xcode Command-Line Tools](https://developer.apple.com/documentation/xcode/installing-the-command-line-tools)
   by running the command `xcode-select --install` inside the
   `Terminal`.
3. Go to the Homebrew homepage and follow the installation
   instructions.
4. Execute the command `brew install rustup` inside the `Terminal`.
5. Go to [Rustup usage](#chp-rustup-usage) for the next instructions.

We may also install VS Code IDE:

1. Install VS Code by using the macOS *App Store* package manager or
   by following instructions on
   [Installing Visual Studio Code on macOS](https://code.visualstudio.com/docs/setup/mac).
2. Once inside VS Code, install the extension
   [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer).
3. VS Code should use the *Rust tool chain* installed by `rustup`.
4. Test the installation by creating a new project, opening a terminal
   window and running `cargo build` to compile the project.
5. Additionally we may install the
   [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)
   extension for debugging with [LLVM](https://llvm.org/), the default
   compiler on macOS.

RustRover IDE is also available for macOS:

1. Install RustRover by using the *App Store* package manager or by
   following instructions on
   [Install RustRover](https://www.jetbrains.com/help/rust/installation-guide.html?keymap=macOS).
2. Like VS Code, RustRover should use the *Rust tool chain* installed
   by `rustup`.

## Windows

To install `rustup` on Windows, we need first to install Visual Studio
in order to get the binary *linker*.
To do that we install the
[Visual Studio Build Tools for C++](https://visualstudio.microsoft.com/visual-cpp-build-tools/).
When asking to choose, we select *C++ Desktop Development*.

Now that the linker is installed, we need to install a package
manager. We may use one of two package managers: either
[Chocolatey](https://chocolatey.org/) or [Scoop](https://scoop.sh/).

For Chocolatey:

1. To install Chocolatey, we follow the instructions on
   [Installing Chocolatey](https://chocolatey.org/install).
2. Note that we have to run the commands inside a
   [PowerShell](https://learn.microsoft.com/en-us/powershell/) as
   *Administrator*.
3. Once Chocolatey is installed, run `choco install rustup.install`
   inside the PowerShell instance.
4. Close the PowerShell instance.

Here are the instructions for Scoop, if Chocolatey was not chosen:

1. To install Scoop, we follow the instructions on
   [Scoop A command-line installer for Windows](https://scoop.sh/).
2. Once Scoop is installed, run `scoop install rustup`.

Once `rustup` is installed, open a normal user PowerShell and run the
following commands to check the `rustup` installation:

```{code-cell} bash
:class: dark-background full-color-output

cargo new foo
cd foo
cargo build
cargo run
```

We may also install VS Code IDE:

1. Install VS Code using the *Microsoft Store* package manager or by
   following instructions on
   [Installing Visual Studio Code on Windows](https://code.visualstudio.com/docs/setup/windows).
2. Once inside VS Code, install the extension
   [rust-analyzer](https://marketplace.visualstudio.com/items?itemName=rust-lang.rust-analyzer).
3. VS Code should use the *Rust tool chain* installed by `rustup`.
4. Test the installation by creating a new project, opening a terminal
   window and running `cargo build` to compile the project.
5. If the `cargo` command is not found in the VS Code's terminal, then
   restart Windows, in order to make it accessible.
6. Additionally we may install the
   [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)
   extension for debugging.

RustRover IDE is also available for Windows:

1. Restart Windows, if it has not already been done.
2. Install RustRover by the *Microsoft Store* package manager or by
   following instructions on
   [Install RustRover](https://www.jetbrains.com/help/rust/installation-guide.html).
3. Like VS Code, RustRover should use the *Rust tool chain* installed
   by `rustup`.

(chp-rustup-usage)=
## Rustup usage

The *Rust tool chain* is best installed through `rustup`, a tool
dedicated to the toolchain management.
Once `rustup` is installed on the platform, run the following command
inside a terminal:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

rustup default stable
```

It will install the latest stable *Rust tool chain*, including the
package and project manager `cargo` and the compiler `rustc`.

We may check the version of the installed *Rust tool chain*, by
running:

```{code-cell} bash
:class: dark-background full-color-output

cargo --version
```

If we need to update the *Rust tool chain* later, in order to upgrade
to a new stable release for instance, we will have to run:

```{code-cell} bash
:tags: [skip-execution]
:class: dark-background full-color-output disabled

rustup update
```

## IDEs
