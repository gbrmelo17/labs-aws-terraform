#!/usr/bin/bash

cd /home/ec2-user
mkdir actions-runner && cd actions-runner
curl -o actions-runner-linux-x64-2.294.0.tar.gz -L https://github.com/actions/runner/releases/download/v2.294.0/actions-runner-linux-x64-2.294.0.tar.gz
#echo "${hash}  actions-runner-linux-x64-2.290.1.tar.gz" | shasum -a 256 -c
tar xzf ./actions-runner-linux-x64-2.294.0.tar.gz
chown -R ec2-user .
sudo -u ec2-user -- ./config.sh --url https://github.com/gbrmelo17/labs-aws-terraform --token ${token} --name ${name_runner} --work _work --runnergroup Default --labels ${name_runner} --unattended --runasservice
sudo -u ec2-user -- ./run.sh

