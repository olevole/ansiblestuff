#!/bin/sh
# меняет user cron для рутовый, дописывая строчку для посылки email уведомления при перезагрузке на mymail@
#
ansible-playbook -i /usr/local/ansible/hosts --ask-pass --ask-sudo-pass /usr/local/ansible/playbooks-ginzburg/cronreboot.yml
