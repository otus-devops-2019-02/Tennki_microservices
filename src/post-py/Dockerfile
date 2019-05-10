FROM alpine:3.6

WORKDIR /app
ADD . /app


RUN apk add --update --no-cache python3 \
    && apk add --update --no-cache --virtual .build-deps \
    gcc \
    build-base \
    py3-pip \
    python3-dev \
    && pip3 install --no-cache-dir -r /app/requirements.txt \
    && apk del .build-deps

ENV POST_DATABASE_HOST post_db
ENV POST_DATABASE posts

ENTRYPOINT ["python3", "post_app.py"]
