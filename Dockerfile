FROM amazon/aws-cli:latest
RUN yum -y install jq
ADD ./create_env.sh /tmp/create_env.sh
WORKDIR /tmp
ENTRYPOINT []
