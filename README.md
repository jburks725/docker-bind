Dockerized BIND
===============
This is a Dockerized BIND installation intended for serving as an internal
DNS cache. It also allows serving of internal zones authoritatively, if desired.

## Getting/Building The Container
If you just want a DNS cache, you can simply pull `jburks725/bind:latest` and
run it as below. If you want to serve your own internal zones, you have two
options.

### Zone File Naming Convention
The start script in this container will automatically add any zone files it
finds in the `/zones` directory as master zones in BIND. To accomplish this,
your zone files must be named the same as the canonical name of the zone to
serve, including the trailing dot.

  * To serve a reverse zone for 192.168.0.0/16: `168.192.in-addr.arpa.`
  * To serve a forward zone for foo.local: `foo.local.`

Structure of BIND zone files is beyond the scope of this README. There is a
good reference here: http://www.zytrax.com/books/dns/ch6/mydomain.html

### Internal Zones - Completely Static
This method allows you to set up static internal zones. To modify these zones,
you will need to rebuild your image and re-run your container.

  1. Clone down the Github repo (https://github.com/jburks725/docker-bind.git)
  2. Add one or more BIND zone files to the `zones/` directory in the working
  directory, following the naming convention above
  3. Build the image normally: `docker build -t yourname/bind .`

### Internal Zones - Volumes and RNDC Updates
If you'd like to be able to update your internal zones without rebuilding the
image every time, you may take advantage of Docker's VOLUME and `exec` features.
The image is already setup with a `/zones` volume, so you may pull and run the
image without modification. You'll just need to mount a directory with zone
files (pay attention to the naming convention above) to the `/zones` location.

## Running The Container - DNS Cache or Static Zones
If you've pulled the image and just want to run a cache, or you've built your
own image with static zones per the above instructions, you may simply run it,
exposing ports 53 and 53/udp, as below.

```bash
# If you built your own image, be sure to substitute your image tag below
docker run -d --name=dns -p 53:53 -p 53:53/udp --restart=on-failure \ jburks725/bind:latest
```

## Running The Container - Volumes and RNDC Updates
If you'd like to be able to update your internal zones using the Docker VOLUME
method described above, simply mount a directory on your Docker host to the
`/zones` volume on the container:

```bash
docker run -d --name=dns -p 53:53 -p 53:53/udp -v /path/to/zonefiles:/zones:ro \
--restart-on-failure jburks725/bind:latest
```

You may then modify the zones in this directory on your Docker host (being sure
to update your serial numbers when you do), then reload the zones using RNDC:

```bash
docker exec dns rndc reload
```

You may check the `docker logs dns` output to verify that your new zone serial
numbers were loaded, or you may `dig` the SOA record for the zone.
