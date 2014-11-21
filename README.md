Dockerized BIND
===============
This is a Dockerized BIND installation intended for serving as an internal DNS cache. It also allows serving
of internal zones authoritatively, if desired. 

## Running The Container
This container supports a number of options at run-time. At a minimum, you should publish ports 53 and 53/udp.

```bash
docker run -d --name=dns -p 53:53 -p 53:53/udp --restart=on-failure jburks725/bind:latest
```

### Additional run-time options
* Port 953 - you can publish port `953/tcp` to allow RNDC connections (make sure you mount a volume for it)
* RNDC volume - mount a directory to `/rndc` in the container to get a copy of the RNDC key on startup
* Zones volume - mount a directory to `/zones` to serve zones

#### Note on local zones
Each file in `/zones` must be named for the zone it will serve, including the trailing dot. E.g.
* `168.192.in-addr.arpa.`
* `mydomain.local.`
