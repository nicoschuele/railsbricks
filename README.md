# RailsBricks

_Boost your Rails development productivity with RailsBricks_

---
- Title: RailsBricks
- Version: 2.0.0
- Author: Nico Schuele
- Contact: nico@railsbricks.net
- Twitter: @railsbricks

---


## Important (really!)

If you currently use RailsBricks 1.x, **you must first uninstall it** as RailsBricks 2.x is not compatible with it.

## Features

- replaces the `rails new` command with `rbricks -n`
- includes useful gems and sets them up for you
- offers two layouts for your site: Reset CSS or Bootstrap 3
- creates and configures a User model from scratch or with Devise
- builds an admin zone
- optionally sets a test framework based on RSpec
- configures your SMTP parameters
- inits local and remote git repositories
- ...and much more to boost your productivity!

## Prerequisites

In order to use RailsBricks, you need the following:

- A nix-based OS. That can be any flavour of Linux or Mac OS X. **RailsBricks may run on Windows but it was not tested**. If you are a Microsoft Windows-based Rails developer, have a look at [Nitrous.IO](http://www.nitrous.io)
- Ruby (1.9.3, 2.0.0 or 2.1.0-preview)
- some knowledge of Rails (!)

## Install

#### Uninstall RailsBricks 1.x

If you have RailsBricks 1.x installed on your system, you must first uninstall it. Follow these steps:

###### 1 - cd to your `<user>` folder:

```
cd ~
```

###### 2 - delete the `railsbricks` directory

```
rm -rf railsbricks
```

###### 3 - Remove RailsBricks from your path in `~/.bash_profile`

remove the following line:

```
PATH=$PATH:~/railsbricks
```

#### Install RailsBricks

RailsBricks is available on [RubyGems.org](http://www.rubygems.org). You can simply install it by issuing the following command in your terminal:

```
gem install railsbricks
```

That's it. RailsBricks is now installed on your system. Again, note that *RailsBricks 2.x is not compatible with version 1.x* and that you should uninstall version 1 before attempting to use it.

## Update

To update RailsBricks to the latest version, just run the following command:

```
rbricks --update
```


## Tutorial

Visit [railsbricks.net](http://www.railsbricks.net) to see an intro video and some samples.

## Usage


### Creating a new Rails app

```
rbricks -n
```

### Resetting the database

```
rbricks -r
```

## Options

### User model

- 1) Simple
- 2) Devise
- 3) None

### Layout

- 1) Reset CSS
- 2) Bootstrap 3

### Git

- local repository (y/n)
- remote repository (y/n)
- creates an augmented .gitignore

### Environment variables

- production domain
- smtp server
- smtp port
- smtp username
- smtp password
- email address used for sending emails

### Secret token

- Automatically generated and **not** tracked by Git

### Seeds

- Offers to create test users automatically

### Test Frameworks

1) Rails default test suite
2) RSpec + Capybara
3) No tests (tests won't be automatically created with the `rails generate` command either)

## Contribute

You like RailsBricks and want to contribute to its development? Cool! You can do it in 3 ways:

- Have a look at the [Roadmap](http://www.railsbricks.net/roadmap), fork the code and try implementing one of the listed feature
- Found a bug or a quirk? Fix it!
- Have an idea for an awesome feature? Fork the code and implement it

...then, submit a pull request.

## Questions, Feedback
If you have any question or feedback, drop me a line at nico@railsbricks.net or tweet at @railsbricks

## Acknowledgments

- [Nikkau](https://github.com/Nikkau), for showing me how to segregate gems without using RVM
- [Joelle Gobbo](http://ch.linkedin.com/pub/joelle-gobbo/32/4b5/a9b), for the elegant snippet used to generate a valid Rails app name
- the authors of the many gems used by RailsBricks
- everyone who emailed me, gave feedback, opened an issue on Github, tweeted, etc. I truly love the Rails community.

## License
Released under GNU GPL-3. Copyright (c) 2013 - Nico Schuele. See LICENSE.txt for further details.