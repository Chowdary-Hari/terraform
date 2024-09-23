#!/bin/bash
dnf install ansible -y
cd /tmp
git clone https://github.com/wavedevops/expense-ansible.git
cd wavedevops/expense-ansible
#ansible-playbook main.yml -e component=backend -e login_password=ExpenseApp1
ansible-playbook main.yml -e component=frontend
