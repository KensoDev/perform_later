# Why do now what you can perform_later?

## Overview
Perform later is a gem meant to work with the [Resque](http://github.com/defunkt/resque) queue system.

The gem handles queuing tasks without the need to have additional "Worker" classes or with any changes to your original model/object code base.

The gem really simplifies queuing tasks, no need for extra workers and you may never need to change your code.

The gem will "translate" objects to a serializable (suitable for json) versions of those classes.

### Usage
You can call the `perform_later` method on any object or active record instance

the `perform_later` method has 3 params

```ruby
:queue_name #The queue in which this task will be in
:method_name #the method that will be called on the object
args #array of arguments
```

### Samples

```ruby
@user = User.find(1)
@user.perform_later(:queue_name, :method_name, args)
```

You can also call objects on the User object itself

```ruby
User.perform_later(:queue_name, :method_name, args)
```

## Configuration
perform_later has a single configuration file, you should put the file in `config/resque_perform_later.yml`

```ruby
defaults: &DEFAULTS
  enabled: true

development:
  <<: *DEFAULTS

test:
  enabled: false

production:
  <<: *DEFAULTS

staging:
  <<: *DEFAULTS
```

### Configuration explained
The config is simple, either it's enabled or it's not, and you can set the environment which you want to enable in

## What happens in test when it's disabled
In test mode, the method is not queued, it's being sent immediately on the object, this way your test work completely normal and you don't need to worry about Resque or Redis in your tests, this is very useful
 

## Contribute / Bug reports
If you have an issue with this gem, please open an issue in the main repo, it will help tons if you could supply a failing spec with that, so I can better track where the bug is coming from, if not, no worries, just report I will do my best to address it as fast and efficient as I can.

If you want to contribute (awesome), open a feature branch, base it on master.

Be as descriptive as you can in the pull request description, just to be clear what problem you are solving or what feature are you adding.

## TODO
1. Add the ability to perform_later without a queue provided (will go to a default queue - configurable)
2. Add generator for the configuration file

## Ideas
1. Add the ability that a method will be tagged as "perform_later", this way you can call the method by name and it will be queued