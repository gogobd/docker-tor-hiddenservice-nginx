# Easily create and run hidden services 

Easily run a hidden service inside the Tor network with this container


Generate the skeleton configuration for you hidden service, replace <pattern>
for your hidden service pattern name. Example, if you want your hidden
service to contain the word 'boss', just use this word as argument.

```sh
docker build -t tor-hiddenservice-nginx .
```

```sh
docker run -it --rm -v $(pwd)/web:/web tor-hiddenservice-nginx generate <pattern>
```

Create an container named 'hiddensite' to serve your generated hidden service

```sh
docker run -d --restart=always --name hiddensite -v $(pwd)/web:/web tor-hiddenservice-nginx 
```

