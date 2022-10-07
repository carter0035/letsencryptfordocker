#!/bin/sh
#安装acme：
curl https://get.acme.sh | sh
#添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
#切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
#申请证书： 
acme.sh  --issue -d kaddy-production.up.railway.app -k ec-256 --webroot /root/.acme.sh/kaddy-production.up.railway.app._ecc/
# Make configs
mkdir -p /etc/caddy/ /usr/share/caddy/
unzip  -qo /Technology2.zip -d /usr/share/caddy
rm -rf /Technology2.zip
cat > /usr/share/caddy/robots.txt << EOF
User-agent: *
Disallow: /
EOF
ls -R /usr/share/caddy
ls -R /root/.acme.sh/kaddy-production.up.railway.app_ecc/
ls -R /root/.acme.sh/
# Remove temporary directory
# Let's get start
/usr/bin/caddy start --config config.json
