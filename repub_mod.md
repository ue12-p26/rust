# Re-publishing modules

:::{danger} Draft
TODO: explain how to use `pub mod ...` and `pub use ...` to re-publish
sub-modules or rename and re-publish modules.

```
pub mod foo; // Publish (and include?) items from another module

pub use crate::foo::zap; // Re-export zap
```
:::
