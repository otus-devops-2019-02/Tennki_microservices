FROM golang as build
RUN git clone https://github.com/openshift/autoheal.git 
RUN cd autoheal && make


FROM golang
COPY --from=build /go/autoheal/_output/local/bin/linux/amd64/autoheal /bin/autoheal
EXPOSE 9099
ADD autoheal.yml /etc/autoheal.yml
ENTRYPOINT [ "/bin/autoheal" ]
