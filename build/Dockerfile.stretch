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
# RUN bundle exec rake RAILS_ENV=production SECRET_TOKEN=b3a12934a959296cd835bf657f6162e9c7238bbf06011cb48153628a9faf489f2a460360a91bcdd3473e8f7a4770de199b2ee29e362689f1bd7feb5c9607cd8f db:create
# RUN bundle exec rake RAILS_ENV=production SECRET_TOKEN=b3a12934a959296cd835bf657f6162e9c7238bbf06011cb48153628a9faf489f2a460360a91bcdd3473e8f7a4770de199b2ee29e362689f1bd7feb5c9607cd8f db:migrate
VOLUME ["$INSTALL_PATH/public"]
CMD bundle exec puma
