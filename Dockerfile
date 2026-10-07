FROM alpine:latest

WORKDIR /app

RUN apk add --no-cache curl bash jq

RUN curl -L -o xray.zip https://github.com/XTLS/Xray-core/releases/latest/download/Xray-linux-64.zip && \
    unzip xray.zip && \
    rm xray.zip && \
    chmod +x xray

EXPOSE 8080

CMD ["sh", "-c", "jq -n --arg port \"${PORT:-8080}\" --arg uuid \"${UUID:-d3b07384-d113-4ed1-9eaa-6238ad5ff000}\" '{inbounds:[{port:($port|tonumber),protocol:\"vless\",settings:{clients:[{id:$uuid}],decryption:\"none\"},streamSettings:{network:\"ws\",wsSettings:{path:\"/\"}}}],outbounds:[{protocol:\"freedom\"}]}' > config.json && ./xray run -c config.json"]
