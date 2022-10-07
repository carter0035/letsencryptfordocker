#!/bin/sh
#安装acme：
curl https://get.acme.sh | sh
#添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
#切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
#申请证书： 
acme.sh  --issue -d kaddy-production.up.railway.app -k ec-256 --webroot /var/www/letsencrypt

sudo mkdir -p /etc/nginx/certs/example.com
sudo chown root.$(whoami) /etc/nginx/certs/kaddy-production.up.railway.app
sudo chmod g+w /etc/nginx/certs/kaddy-production.up.railway.app
acme.sh --install-cert -d kaddy-production.up.railway.app \
    --cert-file /etc/nginx/certs/example.com/cert.pem \
    --key-file /etc/nginx/certs/example.com/key.pem \
    --fullchain-file /etc/nginx/certs/example.com/fullchain.pem \
    --reloadcmd "service nginx reload"
# Make configs
mkdir -p /etc/caddy/ /usr/share/caddy/
unzip  -qo /Technology2.zip -d /usr/share/caddy
rm -rf /Technology2.zip
cat > /usr/share/caddy/robots.txt << EOF
User-agent: *
Disallow: /
EOF


ls -R /etc/nginx/certs/
# Remove temporary directory
# Let's get start
#/usr/bin/caddy run
