# A nomad job for the jrmcc blog

job "jrmcc-nomad" {
    type = "service"
    datacenters = [ "dc1" ]
    group "jrmcc-web" {
        # Attempt to always be running 2 copies, but not on the same host
        count = 2
        constraint {
            distinct_hosts = true
        }
        task "jrmcc-web-frontend" {
            driver = "docker"
            config {
                image = "registry.service.consul/jrmcc"
            }
            resources {
                memory = 256
            }
        }
    }
}
