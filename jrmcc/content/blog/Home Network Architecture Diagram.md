---
title: "Home Network Architecture Diagram"
date: 2016-09-16T00:00:00Z
---

After spending a good chunk of time on my [Home Cluster](/blog/home-cluster-part-i-motivations/), I've gotten to the point where almost everything is up and running and I wanted to take a moment to document how it's all tied together.

```text
Internet (80/443)
    ||||         +------------------+
    vvvv         | cluster{N}       |
+-------------+  | - consul         |
| Router      |  | - nomad          |
|  \-> nginx ------> - container(s) |
+---------^---+  |   - +---------------------------+
          |      +-----| router-updater            |
          |            | - consul-template         |
          |            |   |_ service change       |
          |            |      |_ render nginx.conf |
          |            |      |_ push nginx.conf   |
          |            +----------------------v----+
          \-----------------------------------/
```

_Sweet ASCII art, bruh!_

Essentially, the internet comes to my house address (yay dns and static IPs) and enters my router. The router has a port forwarding setup to redirect port 80/443 to an nginx instance listening on 8080/8443. nginx then proxies the request, based on host header, to a container on one of the cluster machines.

The nginx config is managed by a `router-updater` container which is constantly watching where the cluster for changes and pushing updates to the router's nginx instance. Ideally, this `consul-template` instance would have lived on the router, but the `go` application isn't compatible with the router's architecture, _c'est la vie_.

The nginx consul template looks something like this:

```text
  # jrmcc
  {{- $service := service "jrmcc" }}
  {{- if $service }}
  upstream jrmcc {
  {{- range $service }}
    server {{ .Address }};
  {{- end }}
  }
  server {
    listen 8080;
    server_name jrm.cc;
    location / {
      proxy_pass       http://jrmcc;
      proxy_set_header X-Forwarded-For $remote_addr;
    }
  }
  {{ else }}
  # Warning, no healthly 'jrmcc' found in service list
  {{ end }}
```
