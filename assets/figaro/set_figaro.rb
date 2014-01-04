#!/usr/bin/env ruby

file = "config/application.yml"
domain = ARGV.shift
mailer_domain = ARGV.shift
smtp_user = ARGV.shift
smtp_pwd = ARGV.shift
sender_email = ARGV.shift
smtp_server = ARGV.shift

File.open(file, "w") do |f|
  f.puts "# ENV VARIABLES"
  f.puts "DOMAIN: \"#{domain}\""
  f.puts "MAILER_DOMAIN: \"#{mailer_domain}\""
  f.puts "SMTP_USER: \"#{smtp_user}\""
  f.puts "SMTP_PWD: \"#{smtp_pwd}\""
  f.puts "SENDER_EMAIL: \"#{sender_email}\""
  f.puts "SMTP_SERVER: \"#{smtp_server}\""
end