#!/bin/bash

su - oneadmin -c "one start"
su - oneadmin -c "sunstone-server start"
su - oneadmin -c "oneflow-server start"
cat /var/lib/one/.one/one_auth

tail -f /var/log/one/*.{log,error}
