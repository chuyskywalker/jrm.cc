# A nomad job for the jrmcc blog

job "jrmcc-nomad" {
    type = "service"
    datacenters = [ "dc1" ]
    group "jrmcc-web" {
        count = 1
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
