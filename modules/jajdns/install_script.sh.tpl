#!/bin/bash
###################################################################
#Script Name	: install_script.sh
#Description	: Iodine Setup
#Author       	: NomDuProfil
#Project        : JAJDNS
#Website        : valou.io
###################################################################
yum update -y
yum -y install git gcc zlib-devel
cd
git clone https://github.com/yarrick/iodine.git
cd iodine
make install
/usr/local/sbin/iodined -f -c -P ${password} 192.168.12.1 ${ns_domain}&