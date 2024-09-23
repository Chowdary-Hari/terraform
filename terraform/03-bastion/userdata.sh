#!/bin/bash

# Install Ansible using pip and log the output to /opt/userdata.log
pip3.11 install ansible 2>&1 | tee -a /opt/userdata.log

# Run ansible-pull to pull the playbook from the specified Git repository
# Log the output to /opt/userdata.log, and ensure errors are captured as well
ansible-pull -i localhost, -U https://github.com/wavedevops/expense-ansible main.yaml \
  -e component="${component}" 2>&1 | tee -a /opt/userdata.log
