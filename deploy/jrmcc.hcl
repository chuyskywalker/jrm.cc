# A nomad job for the jrmcc blog

job "jrmcc-nomad" {
    type = "service"
    datacenters = [ "dc1" ]
    group "jrmcc-web" {
        count = 15
        task "jrmcc-web-frontend" {
            driver = "docker"
            config {
                image = "chuyskywalker/jrmcc"
            }
            resources {
                memory = 256
            }
        }
    }
}
