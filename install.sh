#!/bin/bash
# auth : gfw-breaker

baseDir=/usr/share/nginx/html

rpm -ihv http://installrepo.kaltura.org/releases/kaltura-release.noarch.rpm
yum install -y kaltura-nginx-1.16.0-2

rm -fr /etc/nginx/conf.d/*

mkdir -p $baseDir
wget http://gfw-breaker.win/videos/shenyun2020.mp4 -O pages/sample.mp4


server_ip=$(ifconfig | grep "inet addr" | sed -n 1p | cut -d':' -f2 | cut -d' ' -f1)

cp common/* /etc/nginx/
cp sites/* /etc/nginx/conf.d
cp pages/* $baseDir

mv /etc/init.d/kaltura-nginx /etc/init.d/nginx

chkconfig nginx on
service nginx restart

cd $baseDir
for v in *.mp4; do
	sed -e "s/#serverip#/$server_ip/g" \
		-e "s/#video#/$v/g" template.html > $v.html
done


