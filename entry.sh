#!/bin/bash
echo "Starting Consul"
sleep 10 && consul agent -join=consulserver -data-dir=/consul -config-dir=/etc/consul.d &
sleep 20 && consul-template -template "/app/template.tpl:/etc/nginx/conf.d/default.conf" -once
echo "Starting NGINX"
nginx -g "daemon off;"
