#!/bin/bash

if [ $FRONTEND ]; then
	su - oneadmin -c "one start"
	su - oneadmin -c "sunstone-server start"
	su - oneadmin -c "oneflow-server start"
	cat /var/lib/one/.one/one_auth
	if [ ! -e /READY ]; then
		su - oneadmin -c "mkdir -p .ssh"
		su - oneadmin -c "ssh-keygen -q -f .ssh/id_ed25519 -N \"\" -t ed25519 -C \"\$USER@\$HOSTNAME\""
		cat /var/lib/one/.ssh/id_ed25519.pub
		touch /READY
	fi
fi

if [ $NODE ]; then
	sed -i "s/^Port 22$/Port 2222/" /etc/ssh/sshd_config
	sed -i "s/UsePAM yes/UsePAM no/" /etc/ssh/sshd_config
	dpkg-reconfigure openssh-server
	service libvirtd start
	mkdir -p /var/run/sshd
	/usr/sbin/sshd -E /var/log/sshd.log
	if [ ! -z "$SSH_AUTH_KEY" ]; then
		echo "$SSH_AUTH_KEY" > /var/lib/one/.ssh/authorized_keys2
		mkdir -p /root/.ssh
		echo "$SSH_AUTH_KEY" > /root/.ssh/authorized_keys2
	fi
fi

tail -f /var/log/one/*.{log,error} /var/log/sshd.log
