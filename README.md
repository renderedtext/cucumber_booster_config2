# CucumberBoosterConfig

[![Build
Status](https://semaphoreci.com/api/v1/projects/b5ad1293-4dd1-425d-8c00-b42ceca09c75/527737/badge.svg)](https://semaphoreci.com/renderedtext/cucumber_booster_config)

Injects additional configuration for Cucumber so that it outputs JSON suitable
for auto-parallelism without affecting stdout.

## Installation

Add this line to your application's Gemfile:

```ruby
# TODO: this gem will live on Gemfury
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install cucumber_booster_config

## Usage

```
$ cucumber-booster-config help inject
Usage:
  cucumber-booster-config inject PATH

  Options:
    [--dry-run], [--no-dry-run]

inject Semaphore's Cucumber configuration in project PATH
```

If you use the `--dry-run` option, output will look like this:

```
$ cucumber-booster-config inject . --dry-run
Running in .
Found Cucumber profile file: ./cucumber.yml
Content before:
---
default: --format pretty features
---
Inserting Semaphore configuration at the top
Appending Semaphore profile to default profile
Content after:
---
semaphoreci: --format json --out=features_report.json
default: --format pretty features --profile semaphoreci
---
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bundle exec rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

TODO: how to release a new version on Gemfury.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/renderedtext/cucumber_booster_config.
