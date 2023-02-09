FROM alpine

COPY ./coverage.sh /

ARG lcov-file="./coverage/lcov.info"

ENTRYPOINT ["/coverage.sh"]
