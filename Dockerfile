##

FROM alpine:latest

WORKDIR /root
ADD xray.sh /root/xray.sh
RUN apk add --no-cache --virtual .build-deps ca-certificates curl \
 && curl -L -H "Cache-Control: no-cache" -o /xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip \
 && mkdir /usr/bin/xray /etc/xray \
 && touch /etc/xray/config.json \
 && unzip /xray.zip -d /usr/bin/xray \
 && rm -rf /xray.zip /usr/bin/xray/*.sig /usr/bin/xray/doc /usr/bin/xray/*.json /usr/bin/xray/*.dat /usr/bin/xray/sys* \
 && chgrp -R 0 /etc/xray \
 && chmod -R g+rwx /etc/xray
 RUN chmod +x /root/xray.sh
 ENTRYPOINT ["sh", "/root/xray.sh"]
 EXPOSE 80
