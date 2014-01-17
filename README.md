# RailsBricks

_Boost your Rails development productivity with RailsBricks_

---
- Title: RailsBricks
- Version: 1.0.4
- Author: Nico Schuele
- Contact: nico@railsbricks.net
- Twitter: @railsbricks

---


## Features

- replaces the `rails new` command with `rbricks -n`
- includes useful gems and sets them up for you
- offers two layouts for your site: Reset CSS or Bootstrap 3
- creates and configures a User model from scratch or with Devise
- configures your SMTP parameters both in the dev and prod environments
- inits local and remote git repositories
- ...and much more to boost your productivity!

## Prerequisites

In order to use RailsBricks, you need the following:

- A nix-based OS. That can be any flavour of Linux or Mac OS X. **currently, RailsBricks doesn't run on Windows**. If you are a Microsoft Windows-based Rails developer, have a look at [Nitrous.IO](http://www.nitrous.io) 
- Ruby Version Manager (RVM) must be installed on your machine. Get it here: https://rvm.io
- some knowledge of Rails (!)

## Install

######1 - cd to your `<user>` folder:

```
cd ~
```
 
######2 - clone the `railsbricks` repository into `~/railsbricks`

```
git clone https://github.com/nicoschuele/railsbricks.git
```

######3 - Add RailsBricks location to your path in `~/.bash_profile`

```
PATH=$PATH:~/railsbricks
```

## Update

To update RailsBricks to the latest version, just run the following command:

```
rbricks --update
```

## Tip

As RailsBricks will be in your `PATH`, you can simply type a few letters and then press the `tab` key. It will autocomplete the name in your terminal. Example:

```
rbr + tab
```

...will autocomplete to:

```
rbricks
```

## Tutorial

Visit [railsbricks.net](http://www.railsbricks.net) to see an intro video and some samples.

## Usage


### Creating a new Rails app

```
rbricks -n
```

### Destroying a Rails app

```
rbricks -D
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


## Questions, Feedback
If you have any question or feedback, drop me a line at nico@railsbricks.net or tweet at @railsbricks

## License
Copyright (c) 2013 - Nico Schuele. See MIT-LICENSE for further details.