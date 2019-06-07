FROM grafana/grafana:5.0.0
ADD ./provisioning /etc/grafana/provisioning
ADD ./dashboards /var/lib/grafana/dashboards
ADD ./kostyl.sh /kostyl.sh
ENTRYPOINT [ "/kostyl.sh" ]
