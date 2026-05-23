(chp-howto-missing-tools)=
# Missing tools

:::{warning} To review
:::

This chapter lists in a table the various tools that may be used in
bash examples.
In case your system is missing one tool, refer to
{numref}`tab-missing-tools` to known which package provides it.

The table's columns have the following meaning:

- **Command**: The needed command.
- **Equivalent**: Another command that has the same effect.
- **Debian family**: The package in which the command is available.
- **Fedora family**: The package in which the command is available.
- **Arch Linux**: The package in which the command is available.
- **macOS / Homebrew**: The package in which the command is available.
- **Cargo**: The crate in which the command is available. To install a
  crate with `cargo` see
  [Install a crate with Cargo](#chp-howto-cargo-inst-crate).

```{list-table} How to install a missing tool
:name: tab-missing-tools
:header-rows: 1
:align: center

* - Command
  - Equivalent
  - Debian family
  - Fedora family
  - Arch Linux
  - macOS / Homebrew
  - Cargo
* - `bat`
  - `cat`
  - `bat`
  - `bat`
  - `bat`
  - `bat`
  - `bat`
* - `eza` / `exa`
  - In general: `ls`, but `tree` for `eza -T`
  - `eza`
  - `eza`
  - `eza`
  - `eza`
  - `eza`
* - `fd`
  - `find`
  - `fd-find`
  - `fd-find`
  - `fd`
  - `fd`
  - `fd-find`
* - `rg`
  - `grep`
  - `ripgrep`
  - `ripgrep`
  - `ripgrep`
  - `ripgrep`
  - `ripgrep`
* - `tree`
  - `eza -T`
  - `tree`
  - `tree`
  - `tree`
  - `tree`
  - *none*
* - `which`
  - *none*
  - `gnu-which`
  - `which`
  - `which`
  - *native*
  - `which`
```
