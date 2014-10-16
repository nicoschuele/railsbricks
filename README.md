# RailsBricks

_Create **Rails** apps. **Faster**._

---
- Title: RailsBricks
- Version: 3.0.0
- Author: Nico Schuele (www.nicoschuele.com)
- Contact: nico@railsbricks.net
- Homepage: http://www.railsbricks.net
- Github: https://github.com/nicoschuele/railsbricks
- Twitter: @railsbricks

---

## Features

* replaces the `rails new` command with `rbricks -n`
* includes useful gems and sets them up for you
* offers different UI choices for your web app
* creates and configures a Devise authentication scheme
* adds the necessary resources for a blog, contact form, and more
* builds an admin zone
* configures your mailers
* inits local and remote git repositories
* ...and much more to boost your productivity!

## Prerequisites

In order to use RailsBricks, you need the following:

* A nix-based OS. That can be any flavour of Linux or OS X. **RailsBricks may run on Windows but it was not extensively tested**. Still, reports say it runs fine.
* Ruby (version 2.0+)
* Some knowledge of Rails (!)

## Install

Like any other gem, you simply issue `gem install railsbricks`

**Notice:** If you still have RailsBricks 1.x installed, remove it manually *before* installing RailsBricks 3.x

## Usage

To create a new app, just type `rbricks --new` and follow the wizard.

You can read the documentation, see a video and go through the *Get Started* tutorial at [railsbricks.net](http://www.railsbricks.net)
    
## Contribute

You like RailsBricks and want to contribute to its development? Cool! You can do it in 2 ways:

* Fork the code and implement an awesome feature
* Found a bug or a quirk? Fix it!

...then, submit a pull request.

## Questions, Feedback

If you have any question or feedback, drop me a line at nico@railsbricks.net or tweet at @railsbricks

## Acknowledgements

* [Nikkau](https://github.com/Nikkau), for showing me how to segregate gems without using RVM
* [Joelle Gobbo](http://ch.linkedin.com/pub/joelle-gobbo/32/4b5/a9b), for the elegant snippet used to generate a valid Rails app name
* [Jim Meyer](https://github.com/purp), for forking RailsBricks and creating an alternative version I also use
* [David Hsu](https://github.com/dvdhsu), for adding a new Brick: Devise authentication using only an email address
* the authors of the many gems used by RailsBricks
* the [Geneva.rb](http://www.meetup.com/genevarb/) Meetup Group for the beer!
* everyone who emailed me, gave feedback, opened an issue on Github, submitted a pull request, tweeted, etc. I truly love the Rails community.

## License

Released under GNU GPL-3. Copyright (c) 2014 - Nico Schuele. See LICENSE.txt for further details.
