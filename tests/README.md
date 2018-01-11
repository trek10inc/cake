# Testing Strategy

- Quick test
  - `cake validate` each of the examples
  - Check against stored known good output as well

- Integration
  - `cake validate && cake deploy` or whatever
  - Should have no CFN failures
  - Will be slow, should be parallel?