FROM amazonlinux:2

RUN yum update -y && \
    yum install -y aws-cli && \
    yum clean all

COPY script.sh /

ENTRYPOINT ["/bin/bash", "/script.sh"]
