FROM ruby:2.5
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /vend_o_matic
WORKDIR /vend_o_matic
COPY Gemfile /vend_o_matic/Gemfile
COPY Gemfile.lock /vend_o_matic/Gemfile.lock
RUN bundle install
COPY . /vend_o_matic

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
CMD ["rails", "server", "-b", "0.0.0.0"]
