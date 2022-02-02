# Gossamer

Playing around with game development in Ruby using `gosu` (https://www.libgosu.org/), because I'm a bit nuts. Project codename is "gossamer" as a play on the name "gosu".

## Installation

You need Ruby 2.7.5 and Bundler installed. I suggest using a Ruby version manager such as `rvm` or `chruby`, since (as of the time of this writing) 2.7.5 is pretty cutting-edge, and if you do any other Ruby development you'll probably be using a different version.

Then execute:

    $ bundle

That should grab and install any dependencies you need.

## Usage

There's not much to "use", yet. `bin/gossamer` runs the app, but at the moment it does nothing except crash. Most of the real work is in the RSpec tests right now... which also fail other than the few I'm actively working on. Look, it's all basically a trash fire, but it's *my* trash fire.

## Development

After checking out the repo, run `bundler` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment. (That is probably also broken at the moment.)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/glindsey/gossamer.
