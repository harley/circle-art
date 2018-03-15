# Circle::Art

A command line to download cucumber reports from CircleCI artifacts (split across containers) and combine them.
## Installation

You add in your app's Gemfile and use the API directly. Instructions to come.

Or install directly to use the command line

    $ gem install circle-art


## Usage

Get CircleCI token and set it as an ENV. If you haven't, it will [show you how](https://cl.ly/0R0S0g3f3t3t)

```bash
export CIRCLE_TOKEN=<your-token>
```

Input the repo and build number to generate a `downloads/<build-number>.html`

```bash
circle-art username/repo build-number
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/circle-art. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Circle::Art project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/circle-art/blob/master/CODE_OF_CONDUCT.md).
