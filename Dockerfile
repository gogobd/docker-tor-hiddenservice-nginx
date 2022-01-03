FROM debian:bullseye

# Base packages
RUN apt-get update && \
    apt-get -y install \
    nginx \
    tor torsocks ntpdate

ADD ./mkp224o /mkp224o
RUN cd /mkp224o \
 && apt-get -y install gcc libsodium-dev make autoconf automake autoconf \
 && ./autogen.sh && ./configure && make && ls -lah && cp ./mkp224o /bin

# Security and permissions
RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin hidden

# Configure nginx logs to go to Docker log collection (via stdout/stderr)
RUN ln --symbolic --force /dev/stdout /var/log/nginx/access.log
RUN ln --symbolic --force /dev/stderr /var/log/nginx/error.log

# Main script
ADD ./main.sh /main.sh

# Tor Config
ADD ./torrc /etc/tor/torrc

# Add nginx default configuration 
ADD ./nginx.conf /etc/nginx/nginx.conf

# Configuration files and data output folder
VOLUME /web
WORKDIR /web

ENTRYPOINT ["/main.sh"]
CMD ["serve"]

# docker build -t tor-hiddenservice-nginx .
# docker run -it --rm -v $(pwd)/web:/web tor-hiddenservice-nginx generate <pattern>
# docker run -d --restart=always --name hiddensite -v $(pwd)/web:/web tor-hiddenservice-nginx

