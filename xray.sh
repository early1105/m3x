#!/bin/sh
##

# Set ARG

PORT=8080
#ARCH="64"
cat <<EOF >/etc/xray/config.json
{
    "log": {
        "loglevel": "warning"
    },
    "inbounds": [
        {
            "port": '$PORT',
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'",
                        "flow": "xtls-rprx-direct"
                    }
                ],
                "decryption": "none",
                "fallbacks": [
                    {
                        "dest": 3001
                    },
                    {
                        "path": "/'$UUID'-trojan",
                        "dest": 3002
                    },
                    {
                        "path": "/'$UUID'-vmess",
                        "dest": 3003
                    }
                ]
            },
            "streamSettings": {
                "network": "tcp"
            }
        },
        {
            "port": 3001,
            "listen": "127.0.0.1",
            "protocol": "vless",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ],
                "decryption": "none"
            },
            "streamSettings": {
                "network": "ws",
                "wsSettings": {
                    "path": "/'$UUID'-vless"
                }
            }
        },
        {
            "port": 3002,
            "listen": "127.0.0.1",
            "protocol": "trojan",
            "settings": {
                "clients": [
                    {
                        "password": "'$UUID'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/'$UUID'-trojan"
                }
            }
        },
        {
            "port": 3003,
            "listen": "127.0.0.1",
            "protocol": "vmess",
            "settings": {
                "clients": [
                    {
                        "id": "'$UUID'"
                    }
                ]
            },
            "streamSettings": {
                "network": "ws",
                "security": "none",
                "wsSettings": {
                    "path": "/'$UUID'-vmess"
                }
            }
        }
    ],
    "outbounds": [
        {
            "protocol": "freedom"
        }
    ]
}
EOF


chmod +x /usr/bin/xray/xray
ls -la /usr/bin/xray/*
echo "Install done"
echo "--------------------------------"
echo "V2Ray UUID: ${UUID}"
echo "--------------------------------"

# Run v2ray
/usr/bin/xray/xray run -config=/etc/xray/config.json
