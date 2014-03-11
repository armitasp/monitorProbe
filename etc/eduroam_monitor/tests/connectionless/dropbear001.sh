#!/bin/bash

if grep -q "option PasswordAuth 'on'" "/etc/config/dropbear";
then
	echo HERE
	echo "config dropbear" > /etc/config/dropbear
	echo "option PasswordAuth 'off'" >> /etc/config/dropbear
	echo "option Interface   'lan'" >> /etc/config/dropbear
	echo "option RootPasswordAuth 'on'" >> /etc/config/dropbear
	echo "option Port         '22'" >> /etc/config/dropbear
	reboot
fi
