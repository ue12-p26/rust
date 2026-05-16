# Command line arguments

:::{danger} Draft
This section is still being written.
:::

Getting all arguments:

```rust
use std::env;

fn main() {
  let args: Vec<String> = env::args().collect();
}
```

## Clap

Add with derive feature:

```bash
cargo add clap --features derive
```
