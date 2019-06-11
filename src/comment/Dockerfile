FROM alpine:3.2

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

RUN apk add --update --no-cache  ruby \
    ruby-json \
    ruby-bundler \
    && apk add ca-certificates \
    && apk add --update --no-cache --virtual .build-deps \
    build-base \
    ruby-dev \
    ruby-rdoc \
    ruby-irb \
    && bundle install --without development:test:assets -j4 \
    && rm -rf /usr/lib/ruby/gems/2.4.0/cache \
    && rm -rf /root/.bundle/cache/compact_index/* \
    && rm -rf /var/cache/* \
    && apk del .build-deps

ADD . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
