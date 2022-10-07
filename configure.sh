#!/bin/sh
mkdir -p /etc/caddy/ /usr/share/caddy/
unzip  -qo /Technology2.zip -d /usr/share/caddy
rm -rf /Technology2.zip

sudo mkdir -p /usr/share/caddy/letsencrypt/
sudo chown $(whoami).$(whoami) /usr/share/caddy/letsencrypt/

#安装acme：
curl https://get.acme.sh | sh
#添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
sudo mkdir -p /root/.acme.sh/kaddybug-production.up.railway.app
#切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
#申请证书： 
acme.sh  --issue -d kaddybug-production.up.railway.app -k ec-256 --webroot /usr/share/caddy/letsencrypt


sudo mkdir -p /etc/nginx/certs/kaddybug-production.up.railway.app
sudo chown root.$(whoami) /etc/nginx/certs/kaddybug-production.up.railway.app
sudo chmod g+w /etc/nginx/certs/kaddybug-production.up.railway.app
acme.sh --install-cert -d kaddybug-production.up.railway.app \
    --cert-file /etc/nginx/certs/kaddybug-production.up.railway.app/cert.pem \
    --key-file /etc/nginx/certs/kaddybug-production.up.railway.app/key.pem \
    --fullchain-file /etc/nginx/certs/kaddybug-production.up.railway.app/fullchain.pem \

ls -R /etc/nginx/certs/kaddybug-production.up.railway.app
ls -R /root/.acme.sh/kaddybug-production.up.railway.app
ls -R /root/.acme.sh/kaddybug-production.up.railway.app_ecc
ls -R /usr/share/caddy/
# Remove temporary directory
# Let's get start
#/usr/bin/caddy run
