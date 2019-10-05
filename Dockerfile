FROM nginx:latest

RUN apt-get update && apt-get -y upgrade && apt-get install -y curl unzip && \
  curl -o ct.tgz https://releases.hashicorp.com/consul-template/0.20.1/consul-template_0.20.1_linux_amd64.tgz && \
  tar -xvf ct.tgz && \
  curl -o c.zip https://releases.hashicorp.com/consul/1.6.1/consul_1.6.1_linux_amd64.zip && \
  unzip c.zip
RUN mv /consul /usr/local/sbin
RUN mv /consul-template /usr/local/sbin && mkdir -p /app
COPY entry.sh template.tpl /app/
RUN chmod a+x /usr/local/sbin/consul && chmod a+x /usr/local/sbin/consul-template
