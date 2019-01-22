FROM alpine:3.8
RUN apk add --no-cache openssh-client openssl bash curl wget tar gzip ca-certificates

# Install kubectl
ADD https://storage.googleapis.com/kubernetes-release/release/v1.13.1/bin/linux/amd64/kubectl /usr/local/bin/kubectl 
RUN chmod +x /usr/local/bin/kubectl
ENV KUBECONFIG=/data/generated/auth/kubeconfig

# Add the etcdtool script
ADD etcdtool.sh /usr/local/bin/etcdtool.sh

# Set the entrypoint
#CMD ["/bin/bash"]
ENTRYPOINT ["etcdtool.sh"]
