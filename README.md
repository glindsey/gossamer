# Gossamer

Playing around with game development in Ruby using `gosu` (https://www.libgosu.org/), because I'm a bit nuts. Project codename is "gossamer" as a play on the name "gosu".

## Installation

You need Ruby 2.7.5 and Bundler installed. I suggest using a Ruby version manager such as `rvm` or `chruby`, since (as of the time of this writing) 2.7.5 is pretty cutting-edge, and if you do any other Ruby development you'll probably be using a different version.

Then execute:

    $ bundle

That should grab and install any dependencies you need.

## Usage

There's not much to "use", yet. `bin/gossamer` runs the app, but at the moment it does practically nothing except set up a Gosu window and track some events. Most of the real work is in the RSpec tests right now.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/glindsey/gossamer.
