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

# File

:::{warning} To review
:class: readiness-toreview

:::

The [File](https://doc.rust-lang.org/std/fs/struct.File.html) struct
allows to create/read/overwrite files onto file systems. See
{numref}`tab-file` for some its methods. It implements the
[Read](https://doc.rust-lang.org/std/io/trait.Read.html),
[Seek](https://doc.rust-lang.org/std/io/trait.Seek.html) and
[io::Write](https://doc.rust-lang.org/std/io/trait.Write.html) traits
that provide methods for moving cursor into file, read content and
write content: see {numref}`tab-read`, {numref}`tab-write` and
{numref}`tab-seek`.

:::{list-table} Some methods of File
:name: tab-file
:header-rows: 1
:align: center

* - Method
  - Description
* - `open(p)`
  - Opens a file in read mode.
* - `create(p)`
  - Opens a file in write mode. Creates a file if it does not exist
    or truncates it.
* - `create_new(p)`
  - Opens a file in write node. Returns an *error* if the file
    already exists.
* - `options()`
  - Equivalent to `OpenOptions::new()`.
:::

:::{list-table} Some methods of the Read trait
:name: tab-read
:header-rows: 1
:align: center

* - Method
  - Description
* - `chain(o)`
  - Chains another stream reader `o` after this reader. The other
    stream will start as soon as EOF is reached on this reader.
* - `read(b)`
  - Reads some bytes from this reader into the fixed size buffer `b`.
    Returns the number of bytes read.
* - `read_exact(b)`
  - Reads exactly the number of bytes required to fill the fixed
    size buffer `b`. If there are not enough bytes available, it
    returns an error.
* - `read_to_end(b)`
  - Reads all bytes from the stream up to EOF, placing into the
    dynamic size buffer `b`.
* - `read_to_string(b)`
  - Reads all bytes until EOF, and put them inside the `String`
    buffer `b`.
:::

:::{list-table} Some methods of the Seek trait
:name: tab-seek
:header-rows: 1
:align: center

* - Method
  - Description
* - `rewind()`
  - Rewinds to the start of the stream.
* - `seek(p)`
  - Moves the cursor to the position `p` in the stream. The given
    position must be a
    [SeekFrom](https://doc.rust-lang.org/std/io/enum.SeekFrom.html)
    object, which can be expressed from the *start* of the stream,
    the *current* position, or the *end*. Returns the new position
    relative to the start of the stream.
* - `seek_relative(offset)`
  - Moves relative to the current position.
* - `stream_position()`
  - Returns the current position in the stream.
:::

:::{list-table} Some methods of the Write trait
:name: tab-write
:header-rows: 1
:align: center

* - Method
  - Description
* - `flush()`
  - Flushes the buffer, and makes sure all data is written onto the
    destination.
* - `write(b)`
  - Writes the bytes buffer `b` into this writter. Returns the
    number of bytes written.
* - `write_all(b)`
  - Attempts to write the whole buffer `b` into this writer.
:::

```{code-cell} rust
:tags: [remove-cell]

:clear

let tmp_dir = std::env::temp_dir().join(format!("myst-rust-{}", std::process::id()));
std::fs::create_dir_all(&tmp_dir)?;
std::env::set_current_dir(&tmp_dir)?;
```

## Write mode

To create a new file, we may use the `create()` method:

```{code-cell} rust
:class: seq-start badges border

use std::fs::File;

let file = File::create("foo.txt")?;
file
```

A `File` object contains the following fields:

- `fd`: The *file descriptor*. It is an identifier allocated by the
  operating system when a file is open.
- `path`: The file system path.
- `read`: Read mode activated.
- `write`: Write mode activated.

:::{danger} Security issue with create()
The `create()` may introduce *security issues*. See
[Bugs Rust Won't Catch](https://corrode.dev/blog/bugs-rust-wont-catch/#don-t-trust-a-path-across-two-syscalls)
for explanations and an example. It is better to use `OpenOptions`
instead of `create()`.
:::

## OpenOptions

The [OpenOptions](https://doc.rust-lang.org/std/fs/struct.OpenOptions.html)
object allows us to customize the opening of a file for reading or
writing in any way possible. It is *safer* to use than the `create()`
method.

To create an `OpenOptions` object, we may use `OpenOptions::new()` or
`File::options()`. See {numref}`tab-open-options` for a list of
methods of `OpenOptions`. In the following example, we create a new
`OpenOptions` object for which we enable *writing*, file *creation*,
and *truncation* of any existing file at this path:

```{code-cell} rust
:class: seq-cont badges border

let mut file = File::options().write(true).create(true).truncate(true)
  .open("foo.txt")?;
file
```

:::{list-table} Methods of OptionOptions
:name: tab-open-options
:header-rows: 1
:align: center

* - Method
  - Description
* - `new()`
  - Creates a new `OpenOptions` object with all options set to
    `false`.
* - `append(b)`
  - Enables or disables *append* mode.
* - `create(b)`
  - Enables or disables *create* mode. This mode creates a new file
    or opens it if it already exists.
* - `create_new(b)`
  - Enables or disables *create new* mode. This mode creates a new
    file or returns an *error* if it already exists.
* - `open(p)`
  - Opens a file at path `p`.
* - `read(b)`
  - Enables or disables *read* mode.
* - `truncate(b)`
  - Enables or disables *truncate* mode.
* - `write(b)`
  - Enables or disables *write* mode.
:::

## The write!() and writeln!() macros

The [write!()](https://doc.rust-lang.org/std/macro.write.html) macro
is used to write into a write stream using either an
[io::Write](https://doc.rust-lang.org/std/io/trait.Write.html) or a
[fmt::Write](https://doc.rust-lang.org/std/fmt/trait.Write.html)
trait: it needs a *write_fmt()* method. The trait must be *imported*
with the `use` keyword in order to be accessible for the `write!()`
macro. It takes a as first argument the write stream (the `file`
object in our case), and then a string or a format string, and
eventually some arguments for the format string:

```{code-cell} rust
:class: seq-stop badges border

use std::io::Write;

writeln!(file, "Hello!")?;
write!(file, "a={:.2}", 12.345)?;
```

## Closing a file

Closing a file is done by letting the `File` object go out of scope.
The closing provokes the *flushing* of the buffer and the release of
the *file descriptor*. Here we implement a function that writes a
file, the file will be closed when we leave the function:

```{code-cell} rust
:tags: [remove-cell]

:clear

let tmp_dir = std::env::temp_dir().join(format!("myst-rust-{}", std::process::id()));
std::fs::create_dir_all(&tmp_dir)?;
std::env::set_current_dir(&tmp_dir)?;
```

```{code-cell} rust
:class: seq-start badges border

use std::fs::File;
use std::io::Write;
use std::error::Error;

fn write_file(filename: &str) -> Result<(), Box<dyn Error>> {
  let mut file = File::options().write(true).create(true).open(filename)?;
  writeln!(file, "Hello!")?;
  Ok(())
}

let filename = "hello.txt";
write_file(filename)?;
```

## Appending to a file

To append to an existing file we just set the *append* flag:

```{code-cell} rust
:class: seq-cont badges border

fn append_file(filename: &str) -> Result<(), Box<dyn Error>> {
  let mut file = File::options().append(true).open(filename)?;
  writeln!(file, "Hello again!")?;
  writeln!(file, "Nice day to you!")?;
  Ok(())
}

append_file(filename)?;
```

## Read mode

The `Read` trait provides functions to access the content of a
stream. To use it, we need to import with the `use` keyword. In the
following example, we use the `read_to_string()` method to load the
file's content into a `String` instance:

```{code-cell} rust
:class: seq-cont badges border

use std::io::Read;

fn read_file(filename: &str) -> Result<(), Box<dyn Error>> {
  let mut file = File::options().read(true).open(filename)?;
  let mut contents = String::new();
  file.read_to_string(&mut contents)?;
  println!("{}", contents);
  Ok(())
}

read_file(filename)?;
```

:::{warning} Mutability of the file object
Note the `mut` modifier onto the `file` object. The file itself is
open in `read-only` mode, but the `file` object itself, that resides
in memory, needs to be *mutable* in order for the `Read` trait to
move the cursor.
:::

## BufRead trait

The [BufRead](https://doc.rust-lang.org/std/io/trait.BufRead.html)
trait provides additional reading features like *line by line*
reading (see {numref}`tab-buf-read`). It is implemented for instance
by the [BufReader](https://doc.rust-lang.org/std/io/struct.BufReader.html)
structure, which can be instantiated from any object implementing the
`Read` trait: it will thus work on a `File` object.

```{code-cell} rust
:class: seq-stop badges border

use std::io::{BufRead, BufReader};

fn read_file_line_by_line(filename: &str) -> Result<(), Box<dyn Error>> {
  let file = File::options().read(true).open(filename)?;
  let buf = BufReader::new(file);
  for (n, line) in buf.lines().enumerate() {
    println!("Line n°{n}: {}", line?);
  }
  Ok(())
}

read_file_line_by_line(filename)?;
```

:::{warning} No mutability for the file object
Here the objects are *moved*, not borrowed. The `file` object is
moved into the `buf` object which is consumed to create the
*iterator*. No *mutability* is needed for the file object, because
we do not borrow anything.
:::

:::{list-table} Methods of the BufRead trait
:name: tab-buf-read
:header-rows: 1
:align: center

* - Method
  - Description
* - `lines()`
  - Returns an iterator over the lines of this reader.
* - `read_line(s)`
  - Reads all bytes until a *Line Feed* (LF or `0xA`) character or
    *EOF* is reached, and appends to the string `s`.
* - `read_until(b, v)`
  - Reads all bytes until the byte `b` or *EOF* is reached, appends
    the bytes to the bytes vector `v`.
* - `skip_until(b)`
  - Skips all bytes up to byte `b` or *EOF*.
* - `split(b)`
  - Returns an iterator over chunks (i.e.: bytes vectors) from this
    reader, split on the byte `b`.
:::

## Checking the error type

The various functions of the `std::fs` module and the methods of all
its structures and traits return an
[io::Error](https://doc.rust-lang.org/std/io/struct.Error.html)
object. Since file system errors are of many types, the `io::Error`
structure offers a way to check what happened and possibly take
action through the `kind()` method that returns an
[io::ErrorKind](https://doc.rust-lang.org/std/io/enum.ErrorKind.html)
enum:

```{code-cell} rust
:tags: [remove-cell]

:clear

let tmp_dir = std::env::temp_dir().join(format!("myst-rust-{}", std::process::id()));
std::fs::create_dir_all(&tmp_dir)?;
std::env::set_current_dir(&tmp_dir)?;
```

```{code-cell} rust
use std::error::Error;
use std::fs::File;
use std::io::ErrorKind;
use std::path::Path;

fn main() -> Result<(), Box<dyn Error>> {
  let path = Path::new("input_data.txt");

  let file = match File::open(path) {
    Ok(f) => f,
    Err(e) => match e.kind() {
      ErrorKind::NotFound => File::options().create(true).write(true)
                                            .read(true).open(path)?,
      _ => return Err(Box::new(e)),
    },
  };

  println!("{file:?}");
  Ok(())
}

main()
```

In this example:

- The `open()` method tries to open the file in *read* mode.
- Using the `options()` method we creates the file, enabling both
  *write* and *read* modes.
