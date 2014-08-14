#!/bin/sh
ansible-playbook -i /usr/local/ansible/hosts --ask-pass --ask-sudo-pass /usr/local/ansible/playbooks-ginzburg/update_stat.yml
