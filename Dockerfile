FROM amazon/aws-cli:latest
RUN yum -y install jq \
 && yum clean all \
 && rm -rf /var/cache/yum
ADD ./create_env.sh /tmp/create_env.sh
WORKDIR /tmp
ENTRYPOINT []
