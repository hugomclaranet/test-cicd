#!/bin/bash

sudo systemctl restart apache2
sudo rm -rf /tmp/config /tmp/scripts /tmp/templates /tmp/appspec.yml
