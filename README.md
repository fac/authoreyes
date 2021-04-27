# Authoreyes

[![Gem Version](https://badge.fury.io/rb/authoreyes.svg)](https://badge.fury.io/rb/authoreyes) [![Build Status](https://travis-ci.org/tektite-software/authoreyes.svg?branch=master)](https://travis-ci.org/tektite-software/authoreyes) [![Dependency Status](https://gemnasium.com/badges/github.com/tektite-software/authoreyes.svg)](https://gemnasium.com/github.com/tektite-software/authoreyes)
 [![Code Climate](https://codeclimate.com/github/tektite-software/authoreyes/badges/gpa.svg)](https://codeclimate.com/github/tektite-software/authoreyes) [![Test Coverage](https://codeclimate.com/github/tektite-software/authoreyes/badges/coverage.svg)](https://codeclimate.com/github/tektite-software/authoreyes/coverage) [![Inline docs](http://inch-ci.org/github/tektite-software/authoreyes.svg?branch=master)](http://inch-ci.org/github/tektite-software/authoreyes)
[![Gem](https://github.com/fac/authoreyes/actions/workflows/freeagent-gem.yml/badge.svg)](https://github.com/fac/authoreyes/actions/workflows/freeagent-gem.yml)

_Authoreyes_ (pronounced "authorize") is intended to be a modern, Rails 5 compatible replacement for [Declarative Authorization](https://github.com/stffn/declarative_authorization/).

## Release Process

This is a FreeAgent fork of authoreyes to maintain rails compatibility as upstream has stopped.

This Gem is owned and managed by the Core Services team. Released to [github packages](https://github.com/fac/authoreyes/packages).

Packaging is handled by Jenkins, to push a new release:

* Create a PR that increases the version in `version.rb`
* Get that reviewed and approved.
* Merge, on successful build Jenkins will package the gem and release it to github packages.
* Update the bundles for any applications using this gem.

You can track builds in slack, [#authoreyes-ci](https://freeagent.slack.com/channels/authoreyes-ci). Track releases in [#gem-release](https://freeagent.slack.com/channels/gem-release).

See [Internal Gems](https://www.notion.so/freeagent/Internal-gems) for more detail.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'authoreyes'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install authoreyes

## Usage

For Rails authorization in Rails versions 4 and below, please use [Declarative Authorization](https://github.com/stffn/declarative_authorization) or one of its forks.

__Warning! This gem is not finished!__

At this point, to use Authoreyes, you must do the following:
  1. Add an `authorization_rules.rb` file.  See the included one for an example.  The syntax is the same as Declarative Authorization, so you can look at their examples too.
  2. Define privileges for every single action you want to be accessed.  As of now, Authoreyes has only one mode: authorize everything.
  3. Done!  Authoreyes will do its job.

If you want to customize authorization behavior, in your ApplicationController override Authoreyes's `redirect_if_unauthorized` before_action and `set_unauthorized_status_code` after_action.  See `lib/authoreyes/helpers/in_controller` for details.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tektite-software/authoreyes.

__Please check out the wiki for guides on contributing to this project.__

## Acknowledgements

This gem was originally based on [stffn](https://github.com/stffn)'s gem [Declarative_Authorization](https://github.com/stffn/declarative_authorization).  Many thanks to stffn and all who contributed to Declarative Authorization for a great gem!


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

:copyright: 2016 Tektite Software
