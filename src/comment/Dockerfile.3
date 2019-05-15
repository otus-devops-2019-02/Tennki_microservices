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
    && bundle install \
    && apk del .build-deps

ADD . $APP_HOME

ENV COMMENT_DATABASE_HOST comment_db
ENV COMMENT_DATABASE comments

CMD ["puma"]
