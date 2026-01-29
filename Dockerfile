# Use Ruby 2.6.5 as the base image
FROM ruby:2.6.5

# Install system dependencies
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    nodejs \
    libsqlite3-dev \
    yarn

# Set the working directory
WORKDIR /app

# Install bundler
RUN gem install bundler -v 2.1.4

# Copy Gemfile and Gemfile.lock
COPY Gemfile Gemfile.lock ./

# Install dependencies
RUN bundle install

# Copy the rest of the application code
COPY . .

# Set environment variables
ENV RAILS_ENV=production
ENV RAILS_SERVE_STATIC_FILES=true
ENV RAILS_LOG_TO_STDOUT=true

# Precompile assets
# Note: SECRET_KEY_BASE is required for asset precompilation in some Rails versions
# You can provide a dummy value here if it's not strictly checked during precompile
RUN bundle exec rake assets:precompile SECRET_KEY_BASE=dummy_key

# Expose port 8080 (Cloud Run default)
EXPOSE 8080

# Start the application
CMD ["bundle", "exec", "puma", "-C", "config/puma.rb"]
