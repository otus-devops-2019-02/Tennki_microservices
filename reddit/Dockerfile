FROM ubuntu:16.04

RUN apt-get update
RUN apt-get install -y ruby-full ruby-dev build-essential git
RUN gem install bundler && mkdir /reddit
COPY . /reddit

COPY start.sh /start.sh

RUN cd /reddit && bundle install
RUN chmod 0777 /start.sh

CMD ["/start.sh"]
