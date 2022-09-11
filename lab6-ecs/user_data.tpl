#!/bin/bash

#Update all packages

sudo yum update -y
sudo yum install -y ecs-init
sudo service docker start
sudo start ecs
