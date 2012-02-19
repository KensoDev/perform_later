# Why do now what you can perform_later?

## Overview
Perform later is a gem meant to work with the [Resque](http://github.com/defunkt/resque) queue system.

The gem handles queuing tasks without the need to have additional "Worker" classes or with any changes to your original model/object code base.

The gem really simplifies queing tasks, no need for extra workers and you may never need to change your code.

The gem will "translate" objects to a serializable (suitable for json) versions of tha classes.

### Usage
You can call the `perform_later` method on any object or active record instance
```
@user = User.find(1)
@user.perform_later(:queue_name, :method_name, args)

```

You can also call objects on the User object itself

```
User.perform_later(:queue_name, :method_name, args)
```




## Contribute / Bug reports
If you have an issue with this gem, please open an issue in the main repo, it will help tons if you could supply a failing spec with that, so I can better track where the bug is coming from, if not, no worries, just report I will do my best to address it as fast and efficient as I can.

If you want to contribute (awesome), open a feature branch, base it on master.

Be as descriptive as you can in the pull request description, just to be clear what problem you are solving or what feature are you adding.