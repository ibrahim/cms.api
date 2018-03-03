FROM ruby:2.5.0-slim-stretch
MAINTAINER Ibrahim Ahmed <ia.ibrahim@gmail.com>
RUN apt-get update && apt-get install -y curl build-essential libreadline-dev libssl-dev zlib1g-dev libxml2-dev libxslt-dev git libpq-dev default-libmysqlclient-dev nodejs libcurl4-openssl-dev libffi-dev imagemagick libjpeg-progs pngcrush --fix-missing --no-install-recommends
ENV INSTALL_PATH /app
RUN mkdir -p $INSTALL_PATH
WORKDIR $INSTALL_PATH
COPY Gemfile Gemfile
RUN bundle install --path vendor/cache
COPY . .
ADD ./build/database.yml /app/config/database.yml
VOLUME ["$INSTALL_PATH/public"]
CMD bundle exec puma
