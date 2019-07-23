FROM debian:10.0-slim

RUN apt-get update -y && apt-get install silversearcher-ag

COPY entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
