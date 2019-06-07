#!/bin/bash 
sed -i -e 's/${DS_PROMETHEUS}/Prometheus/g; s/${DS_INFLUXDB}/InfluxDB/g' /var/lib/grafana/dashboards/*.json
source /run.sh
