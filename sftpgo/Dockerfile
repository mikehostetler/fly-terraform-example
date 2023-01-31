FROM drakkan/sftpgo:v2.4-alpine-slim

COPY sftpgo.yaml .
COPY --chown=sftpgo:sftpgo lib /var/lib/sftpgo

CMD [ "sftpgo", "serve" ]