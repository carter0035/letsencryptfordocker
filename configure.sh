#!/bin/sh
cat << EOF > /conf/config.json
{
 "apps": {
   "http": {
     "servers": {
       "srv0": {
         "listen": [
           ":4431"   //监听端口
         ],
         "routes": [
           {
             "handle": [
               {
                 "auth_user_deprecated": "user",
                 "auth_pass_deprecated": "pass",
                 "handler": "forward_proxy",
                 "hide_ip": true,
                 "hide_via": true,
                 "probe_resistance": {}
               }
             ]
           },
           {
             "handle": [
               {
                 "handler": "reverse_proxy",
                 "headers": {
                   "request": {
                     "set": {
                       "Host": [
                         "{http.reverse_proxy.upstream.hostport}"
                       ],
                       "X-Forwarded-Host": [
                         "{http.request.host}"
                       ]
                     }
                   }
                 },
                 "transport": {
                   "protocol": "http",
                   "tls": {}
                 },
                 "upstreams": [
                   {
                     "dial": "demo.cloudreve.org:443"
                   }
                 ]
               }
             ]
           }
         ],
         "tls_connection_policies": [
           {
             "match": {
               "sni": [
                 "kaddy-production.up.railway.app"
               ]
             },
             "certificate_selection": {
               "any_tag": [
                 "cert0"
               ]
             }
           }
         ],
         "automatic_https": {
           "disable": true
         }
       }
     }
   },
   "tls": {
     "certificates": {
       "load_files": [
         {
           "certificate": "/root/kaddy-production.up.railway.app.crt",
           "key": "/root/kaddy-production.up.railway.app.key",
           "tags": [
             "cert0"
           ]
         }
       ]
     }
   }
 }
}
EOF
#安装acme：
curl https://get.acme.sh | sh
#添加软链接：
ln -s  /root/.acme.sh/acme.sh /usr/local/bin/acme.sh
#切换CA机构： 
acme.sh --set-default-ca --server letsencrypt
#申请证书： 
acme.sh  --issue -d kaddy-production.up.railway.app -k ec-256 --webroot /usr/share/caddy
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
# Remove temporary directory
# Let's get start
/usr/bin/caddy run
