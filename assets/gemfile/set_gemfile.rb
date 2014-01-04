#!/usr/bin/env ruby

user_model = ARGV.shift
layout = ARGV.shift

if user_model == "2"
  devise_gemfile = File.read(ENV['HOME']+"/railsbricks/assets/gemfile/Gemfile_devise")
  File.open("Gemfile", "a") {|file| file.puts devise_gemfile}
end

if layout == "2"
  layout_gemfile = File.read(ENV['HOME']+"/railsbricks/assets/gemfile/Gemfile_bootstrap")
  File.open("Gemfile", "a") {|file| file.puts layout_gemfile}
end