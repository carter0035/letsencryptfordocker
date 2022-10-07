#!/bin/sh
mkdir -p /etc/caddy/ /usr/share/caddy/ /usr/share/caddy/letsencrypt/ /usr/share/caddy/cert/
unzip /Technology2.zip -d /usr/share/caddy
rm -rf /Technology2.zip
#安装acme：
curl https://get.acme.sh | sh
#添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
#切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
#申请证书： 
acme.sh --issue -d kaddybug-production.up.railway.app -k ec-256 --webroot /usr/share/caddy/letsencrypt
acme.sh --list
acme.sh --installcert -d kaddybug-production.up.railway.app --ecc \
        --key-file /usr/share/caddy/cert/private.key \
        --fullchain-file /usr/share/caddy/cert/cert.crt
ls -R /usr/share/caddy/
ls -R /usr/share/caddy/cert/
ls -R /usr/share/caddy/letsencrypt/
# Remove temporary directory
# Let's get start
#/usr/bin/caddy run
