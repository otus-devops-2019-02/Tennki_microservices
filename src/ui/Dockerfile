FROM alpine:3.6

ENV APP_HOME /app
RUN mkdir $APP_HOME
WORKDIR $APP_HOME
ADD Gemfile* $APP_HOME/

RUN apk add --update --no-cache  ruby \
    ruby-json \
    ruby-bundler \
    && apk add --update --no-cache --virtual .build-deps \
    build-base \
    ruby-dev \
    ruby-rdoc \
    ruby-irb \
    && bundle install --without development:test:assets -j4 \
    && rm -rf /usr/lib/ruby/gems/2.4.0/cache \
    && rm -rf /root/.bundle/cache/compact_index/* \
    && rm -rf /var/cache/* \
    && find /usr/lib/ruby/gems/2.4.0/gems/ -name "*.c" -delete \
    && find /usr/lib/ruby/gems/2.4.0/gems/ -name "*.o" -delete \
    && apk del .build-deps

ADD . $APP_HOME

ENV POST_SERVICE_HOST post
ENV POST_SERVICE_PORT 5000
ENV COMMENT_SERVICE_HOST comment
ENV COMMENT_SERVICE_PORT 9292

CMD ["puma"]
