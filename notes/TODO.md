# List of stuff TODO

## Small

### Wrap keys like `always`, `usually`, etc. inside a `when_created` hash

The reason for this is to clarify YAML description files. It's not necessary from a parsing point of view, and may even slow things down a little, but putting them inside a `when_created` value makes it clear that these are initial conditions for a thing, and may very well change over time.

## Medium

### Verify `conditionals` clauses

Only need to verify `if`, `then`, `elseif` child clauses.

## Large

### Verify conditionals

## Huge

### Processing anything to create objects

## ???

### Custom conditions

This is the idea of being able to define particular conditions to be checked, essentially as pure functions on game data.

For example: defining `bald?` as "being or incorporating a head which does not incorporate hair".

I question whether this should really be encoded as YAML, or whether it would be better suited as a Ruby function that is called directly.
