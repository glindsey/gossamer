# Gossamer

## The Basics

Playing around with game development in Ruby using `gosu` (https://www.libgosu.org/), because I'm a bit nuts. Project codename is "gossamer" as a play on the name "gosu".

### Installation

You need Ruby 3.1.1 and Bundler installed. I suggest using a Ruby version manager such as `rvm` or `chruby`, since (as of the time of this writing) 3.1.1 is cutting-edge, and if you do any other Ruby development you'll probably be using a different version.

Then execute:

    $ bundle

That should grab and install any dependencies you need.

### Usage

There's not much to "use", yet. `bin/gossamer` runs the app, but at the moment it does nothing except crash. Most of the real work is in the RSpec tests right now. Look, it's all basically a trash fire, but it's *my* trash fire.

### Development

After checking out the repo, run `bundler` to install dependencies. You will most likely have to install several libraries for some of the gems to install, particularly `gosu`; these will vary based on your operating system.

Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. (That is probably also broken at the moment.)

### Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/glindsey/gossamer.

## The System

Gossamer attempts to create what is almost certainly an overly-elaborate description of the game world using several core concepts implemented as Ruby classes, mixin modules, and/or simple data types.

### Things

The Thing class is the primary "noun" of the world. A Thing class can be abstract, meaning it cannot be created as-is as an object in the world; or it can be concrete, meaning it _can_ be created. A Thing class may inherit from another class; _usually_ (but not always) the class inherited from is abstract. 

Example: A "lifeform" is too vague to be created, but a "human" is perfectly fine.

### Traits

This is a module that provides additional attributes, constraints, parts, properties, and/or tags to a Thing class. It is used by being `include`d into another Thing class or Trait module. (Traits, being Ruby modules and not classes, can't inherit from other traits directly, but inclusion essentially performs the same task.)

Example: A "human" is a subclass of "lifeform", but it has the traits "concrete", "humanoid", and "mammal".

### Attributes

An attribute consists of a symbol key -- its name -- and a value. The value can be one of several types (the details of most still to be defined), but one type is special: if the value is a symbol, it is cast to a subclass of the `Attributes::(Name)::Base` class type, where `(Name)` is the symbol name.

#### Class Attributes

Default attribute values for an entire Thing class are specified by simply creating a class method with the name of the attribute; this value will be used for any instance of that Thing unless explicitly set for that instance. The only caveat to note here is that class methods referencing symbolic attributes must reference the class itself, not just the symbol (e.g. the value for an attribute named `shape` must be `World::Attributes::Shapes::Square`, not just `:square`).

Example: Including `def self.shape; World::Attributes::Shapes::Circle; end` in the Coin class will make all created coins be circular by default, unless explicitly specified at creation (or during gameplay).

#### Object Attributes

Attribute values for specific objects can be set during gameplay by using the `Thing#attributes` method to get the hash. (This will almost certainly change in the future, as per the TODOs below.)

Likewise, these attribute values can be checked for existence via the `Thing#attribute?` method, and read via the `Thing#attribute` method. If a specific object doesn't have an value set for a certain attribute, the default for the class will be returned, assuming one exists. Otherwise, it will just return `nil`.

#### Symbolic Attributes (both Class and Object)

Classes derived from `Attributes::Base` are a special static type that lets attributes have properties of their own, and are generally used for attributes that denote a particular "quality", like "shape" or "color".

Example: A "coin" may have a ":shape" attribute which can be ":circle" or ":square"; these are cast to `Attributes::Circle` and `Attributes::Square` module references, respectively.

### Constraints

Constraints are a set of lambda functions defined for a Thing class. Each function takes a Thing object, and returns either true or false. These functions are each run in turn when a Thing is created, to verify that the Thing meets the constraints; if it does not, an error is raised.

Class constraints are defined via the class method `Thing.class_constraints`, which should return an array of lambdas. 

If you want a mixin to add class constraints to a class, the process is somewhat different; a mixin trait should do:

    included do
      self.mixin_constraints |= [
        # put constraint functions here
      ]
    end

Example: Say you want a "doohickey" to have an "volume" attribute that ranges between 0 and 5, but you don't want a default to be set. You can add a constraint function `->(obj) { obj.attribute(:volume) > 0 && obj.attribute(:volume) < 5 }` which will be run when a "doohickey" is created.

### Materials

Materials are static classes that describe what individual thing instances are made of. (This will probably change to be actual instances of materials, so the materials themselves can keep track of attributes such as burn/corrosion/etc. amount.)

(TODO: Add more details here)

### Parts

Parts are individual pieces of a thing, and are also things themselves. This is where the compositional nature of the engine really shines, since a "human" can have a "head" part, which has a "face" part, which has a "nose" part, which has a "nostril" part.

(TODO: Add more details here)

### Properties

Properties are similar to attributes, except that they are boolean true/false values only.

(TODO: Add more details here)

### Tags

Tags are a set of symbols attached to a thing object. They act somewhat similar to properties, with the following differences:

- Tags are inherited by the parts of a thing: for example, if a "leg" is tagged "human" and "left", a "foot" part of that leg will also be tagged "human" and "left".
- Tags are only added upon object creation, or added/removed during gameplay: there are no "default" tags implemented by thing classes.

(TODO: Add more details here)

### Config

"Config" is the name for the hash used to create any given thing. Thing classes can define default configs to be used when things are created, mixins can add to those configs via functions that can optionally check conditions, and additional options can be specified to be merged into the config when creating an object.

(TODO: Add more details here)

#### Mixin config functions: Before and After

Trait mixins can add to arrays of configuration functions which can modify the thing config for object creation. For example, the "biped" trait adds a config function that provides a "left leg" and "right leg" to any thing class that includes it.

(TODO: Add more details here)

## TODOs

A non-exhaustive list (obviously).

### Attributes

- Attribute constraints, such as min/max values.

- Direct access of the `Thing#attributes` hash is probably a bad idea, since it won't allow for checking future attribute constraints, or converting symbols into symbolic attributes. (Also, reading them via that hash doesn't fall back to class attributes if they don't exist.)

### Materials

- Thing instances should probably have Material instances, instead of class references.
 
