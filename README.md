[![Build Status](https://secure.travis-ci.org/KensoDev/perform_later.png)](https://secure.travis-ci.org/KensoDev/perform_later)

## Overview
Perform later is a gem meant to work with the [Resque](http://github.com/defunkt/resque) queue system.

The gem handles queuing tasks without the need to have additional "Worker" classes.

The gem will "translate" objects to a serializable (suitable for JSON) versions of those classes.

The Gem also support a workflow similar to `async_method`, meaning you can just call method on your objects and configure those methods to be queued by default. No worries, you can always call the method in `now` mode, which will execute the method in sync.

## Why?
*Why* should you queue something for later?

You should queue something whenever the method handles some heavy lifting, some timely actions like API, 3rd party HTTP requests and more.

The basic logic is that whatever you don't need to do NOW, you should do later, this will make your site faster and the users will feel it.

## Real life use case
At [Gogobot](http://gogobot.com) whenever you post a review, there's major score calculation going on, this can take 20-30 seconds sometimes.

The user should not wait for this on submit, it can be queued into later execution.

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
You can configure `perform_later` exactly as you configure your rails app.

Inside your `#{env}.rb` file (for example development.rb)

```ruby
config.perform_later.enabled = false # this will default to true if unset
```

## What happens in test when it's disabled
In test mode, the method is not queued, it's being sent immediately on the object, this way your test work completely normal and you don't need to worry about Resque or Redis in your tests, this is very useful
 

## Contribute / Bug reports
If you have an issue with this gem, please open an issue in the main repo, it will help tons if you could supply a failing spec with that, so I can better track where the bug is coming from, if not, no worries, just report I will do my best to address it as fast and efficient as I can.

If you want to contribute (awesome), open a feature branch, base it on master.

Be as descriptive as you can in the pull request description, just to be clear what problem you are solving or what feature are you adding.

## TODO
1. Add the ability to perform_later without a queue provided (will go to a default queue - configurable)