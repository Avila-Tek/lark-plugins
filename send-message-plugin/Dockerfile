FROM --platform=linux/amd64 alpine:3.18.9 as base

RUN apk add --no-cache curl jq
RUN apk add openssl

ARG APP_ID
ARG APP_SECRET
ARG RECEIVE_ID_TYPE
ARG RECEIVE_ID
ARG CONTENT
ARG MSG_TYPE

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN echo "👷🏻 Executing Lark Send Message Plugin..."
# ENTRYPOINT ["/entrypoint.sh"]
CMD ["sh", "-c", "/entrypoint.sh"]
