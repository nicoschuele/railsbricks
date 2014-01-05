#!/bin/bash
echo
echo
echo "************************************************"
echo "*             RailsBricks v0.1.0               *"
echo "*             ------------------               *"
echo "*  https://github.com/nicoschuele/railsbricks  *"
echo "************************************************"
echo
echo 
echo "Create a new Rails 4.0.2 app?(y/n):"

# Continue?
read CONTNEW
if [ "$CONTNEW" = "n" ]
  then
  exit 1
fi

# App name
echo 
echo "What do you want to call your app?:"
read APPNAME

# User model
echo
echo "USER MODEL:"
echo "-----------"
echo "1) Simple"
echo "2) Devise"
echo "3) None"
echo "(1), (2), (3):"
read USERMODEL

# Layout
echo 
echo "LAYOUT:"
echo "-------------------"
echo "1) Reset CSS"
echo "2) Bootstrap 3 SASS"
echo "3) None"
echo "(1), (2), (3):"
read LAYOUT

# Env variables 
echo
echo "ENVIRONMENT VARIABLES:"
echo "----------------------"
echo "What production domain?:"
echo "(example: www.example.com, app.example.com, ...)"
read DOMAIN

echo 
echo "What mailer domain?:"
echo "(example: example.com)"
read MAILERDOMAIN

echo 
echo "What SMTP server?:"
echo "(example: mail.example.com)"
read SMTPSERVER

echo 
echo "What SMTP username?:"
read SMTPUSER

echo
echo "What SMTP password?:"
read SMTPPWD

echo
echo "Which email address to send mail from?:"
read SENDEREMAIL

# Git
echo
echo "GIT CONFIG:"
echo "----------------------------"
echo "Init a Git repository?(y/n):"
read GITSET

# Remote Git
if [ "$GITSET" = "y" ]
  then
  echo
  echo "Set a remote Git repository?(y/n):"
  read GITREMOTE
  
  if [ "$GITREMOTE" = "y" ]
    then
    echo
    echo "Remote Git repository URL:"
    echo "(example: https://my-name@bitbucket.org/my-name/my-app.git)"
    read GITREMOTEURL
  fi  
fi

# Confirmation
echo
echo "----> User input set."

# RVM
echo
echo "----> Creating RVM Gemset ..."
[ -s "$HOME/.rvm/scripts/rvm" ] && . "$HOME/.rvm/scripts/rvm"
rvm use 2.0.0@$APPNAME --create
echo
echo "----> RVM Gemset created."

# Rails 4.0.2
echo
echo "----> Installing Rails 4.0.2 into Gemset $APPNAME ..."
gem install rails -v 4.0.2
echo
echo "----> Rails 4.0.2 installed."

# Create app
echo
echo "----> Creating $APPNAME ..."
rails new $APPNAME --skip-bundle
echo
echo "----> $APPNAME created."

# cd into app
cd "$APPNAME"

# Set rvmrc
echo
echo "----> Setting .rvmrc ..."
rvm --rvmrc 2.0.0@$APPNAME
echo
echo "----> .rvmrc set."

# Set Gemfile
echo
echo "----> Setting Gemfile ..."
rm Gemfile
cp ~/railsbricks/assets/gemfile/Gemfile_simple Gemfile
~/railsbricks/assets/gemfile/set_gemfile.rb $USERMODEL $LAYOUT
echo
echo "----> Gemfile set."

# Bundle install (no prod)
echo 
echo "----> Installing Gems ..."
bundle install --without production
echo 
echo "----> Gems installed."

# Config Gems (kaminari, figaro & friendly_id)
echo
echo "----> Kaminari config ..."
rails generate kaminari:config
echo
echo "----> Kaminari set."

echo
echo "----> Figaro config ..."
rails generate figaro:install
echo
echo "----> Figaro set."

echo 
echo "----> Friendly_id config ..."
rails generate friendly_id
echo
echo "----> Friendly_id set."

# Rails layout if Bootstrap 3
if [ "$LAYOUT" = "2" ]
  then
  echo
  echo "----> Generating Bootstrap 3 layout ..."
  rails generate layout bootstrap3 --force
  echo
  echo "----> Bootstrap 3 layout generated"  
fi

# Devise install if option set
if [ "$USERMODEL" = "2" ]
  then
  echo 
  echo "----> Setting Devise ..."
  rails generate devise:install
  echo
  echo "----> Devise set."
fi

# Add a date_format initializer
echo
echo "----> Adding a date_format initializer ..."
cp ~/railsbricks/assets/date_format/date_format.rb config/initializers/date_format.rb
echo 
echo "----> date_format.rb initializer set."

# Configure application.yml
echo 
echo "----> Setting application.yml ..."
rm config/application.yml
~/railsbricks/assets/figaro/set_figaro.rb $DOMAIN $MAILERDOMAIN $SMTPUSER $SMTPPWD $SENDEREMAIL $SMTPSERVER
echo
echo "----> application.yml set."

# Secret token
echo 
echo "----> Setting secret_token.rb ..."
rm config/initializers/secret_token.rb
~/railsbricks/assets/secret_token/set_secret_token.rb $APPNAME
echo
echo "----> secret_token.rb set."

# Environments mailers (dev+prod)
echo
echo "----> Setting Environments configs ..."
rm config/environments/development.rb
rm config/environments/production.rb
~/railsbricks/assets/environments/set_environments.rb $APPNAME
echo
echo "----> Environments config set."

# Create the user model
if [ "$USERMODEL" = "1" ]
  then 
  echo
  echo "----> Setting Simple User model ..."
  rails g model User username email password_digest admin:boolean slug
  ~/railsbricks/assets/user_model/simple/set_user.rb
  
  rm app/controllers/application_controller.rb
  cp ~/railsbricks/assets/user_model/simple/application_controller.rb app/controllers/application_controller.rb
  
  rm app/models/user.rb
  cp ~/railsbricks/assets/user_model/simple/user.rb app/models/user.rb
  echo
  echo "----> Simple User model set."
elif [ "$USERMODEL" = "2" ]
  then
  echo
  echo "----> Setting Devise User model ..."
  rails g devise User
  ~/railsbricks/assets/user_model/devise/set_user.rb
  
  rm app/controllers/application_controller.rb
  cp ~/railsbricks/assets/user_model/devise/application_controller.rb app/controllers/application_controller.rb
  
  rm app/models/user.rb
  cp ~/railsbricks/assets/user_model/devise/user.rb app/models/user.rb
  
  rm config/initializers/devise.rb
  cp ~/railsbricks/assets/user_model/devise/devise.rb config/initializers/devise.rb
  echo
  echo "----> Devise User model set."
else
  echo "----> No User model to generate."
fi

# Create User seed data 
if [ "$USERMODEL" = "1" ]
  then
  echo
  echo "----> Creating seed data for Simple User Model ..."
  rm db/seeds.rb
  cp ~/railsbricks/assets/seed/simple/seeds.rb db/seeds.rb
  echo "----> seed data for Simple User Model created."
elif [ "$USERMODEL" = "2" ]
  then
  echo
  echo "----> Creating seed data for Devise User Model ..."
  rm db/seeds.rb
  cp ~/railsbricks/assets/seed/devise/seeds.rb db/seeds.rb
  echo "----> seed data for Devise User Model created."
else
  echo
  echo "----> No seed data necessary."
fi

# Updates application.rb
echo 
echo "----> Updating application.rb ..."
rm config/application.rb
cp ~/railsbricks/assets/application/application.rb config/application.rb
echo
echo "----> application.rb set."


exit 1
# Create initial layout
   # TODO
  # if reset css
   # TODO
  # if bootstrap
   # TODO
  # if devise  
   # TODO

# Create index page
  # TODO
  
# Generate admin zone if authentication
  # if simple
   # TODO
  # if devise
   # TODO     

# Updates routes
  
# Migrating DB
echo
echo "----> Initializing the database ..."
rake db:migrate
rake db:seed
echo
echo "----> Database initialized."

# Git
if [ "$GITSET" = "y" ]
  then
  echo
  echo "----> Setting .gitignore ..."
  rm .gitignore
  cp ~/railsbricks/assets/gitignore/gitignore .gitignore
  echo 
  echo "----> .gitignore set."
  
  echo
  echo "----> Initializing Git repository ..."
  git init
  git add -A .
  git commit -m "initial commit (generated by RailsBricks)"
  echo
  echo "----> Local Git repository set."
  
  if [ "$GITREMOTE" = "y" ]
    then
    echo
    echo "----> Setting remote repository ..."
    git remote add origin $GITREMOTEURL
    git push origin master
    echo
    echo "----> Local master branch pushed to origin."
  fi  
fi

# Confirm
echo
echo
echo "************************************************"
echo " RailsBricks generated your app: $APPNAME"
echo
echo " https://github.com/nicoschuele/railsbricks"
echo "************************************************"
echo
echo "Have a great coding time!"
echo



















 
















