FROM ubuntu:20.04

ADD test_linux_amd64 /test
ADD entrypoint.sh /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
