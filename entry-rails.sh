#!/bin/bash
echo "Starting Consul"
sleep 10 && consul agent -join=consulserver -data-dir=/consul -config-dir=/etc/consul.d &
echo "Starting rails..."
rm -rf /app/foo/tmp/pids/*
cd /app/foo
bundle exec rails s -b 0.0.0.0
