FROM alpine:3.7

RUN mkdir /tmp/mongodb_exporter && \
    cd /tmp/mongodb_exporter && \
    wget https://github.com/percona/mongodb_exporter/releases/download/v0.7.0/mongodb_exporter-0.7.0.linux-amd64.tar.gz && \
    tar -xvzf mongodb_exporter-0.7.0.linux-amd64.tar.gz && \
    mv mongodb_exporter /bin/mongodb_exporter && \
    rm -rf /tmp/mongodb_exporter

EXPOSE 9216

ENTRYPOINT [ "/bin/mongodb_exporter" ]
