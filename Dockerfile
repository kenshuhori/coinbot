FROM ruby:2.6

WORKDIR coinbot
RUN gem install bundler
RUN gem install mysql2 --platform=ruby
