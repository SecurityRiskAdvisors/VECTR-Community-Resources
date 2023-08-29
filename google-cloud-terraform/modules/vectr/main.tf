resource "google_compute_network" "vectr_vpc_network" {
  name                    = "${var.vectr_instance_name}-vpc"
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_firewall" "vectr_allow_ssh_external" {
  name    = "${var.vectr_instance_name}-allow-ssh-external"
  network = google_compute_network.vectr_vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = var.vectr_source_addresses

}

resource "google_compute_firewall" "vectr_allow_tcp_internal" {
  name    = "${var.vectr_instance_name}-allow-tcp-internal"
  network = google_compute_network.vectr_vpc_network.name

  allow {
    protocol = "tcp"
    ports    = ["0-65535"]
  }

  allow {
    protocol = "udp"
    ports    = ["0-65535"]
  }

  allow {
      protocol = "icmp"
  }

  source_ranges = ["${var.vectr_subnet_cidr}"]

}

resource "google_compute_firewall" "vectr_allow_https_external" {
  name    = "${var.vectr_instance_name}-allow-https-external"
  network = google_compute_network.vectr_vpc_network.name

  allow {
      protocol = "tcp"
      ports    = ["443"]
  }

  source_ranges = var.vectr_source_addresses

}

resource "google_compute_firewall" "vectr_allow_icmp_external" {
  name    = "${var.vectr_instance_name}-allow-icmp-external"
  network = google_compute_network.vectr_vpc_network.name

  allow {
      protocol = "icmp"
  }

  source_ranges = var.vectr_source_addresses

}


resource "google_compute_subnetwork" "vectr_vpc_subnet" {
  name          = "${var.vectr_instance_name}-subnet"
  ip_cidr_range = var.vectr_subnet_cidr
  region        = var.vectr_compute_region
  network       = google_compute_network.vectr_vpc_network.id
}

resource "google_compute_address" "vectr_external_ip" {
  name         = "${var.vectr_instance_name}-ext-ip"
  address_type = "EXTERNAL"
}


resource "google_compute_instance" "vectr" {
  name         = "${var.vectr_instance_name}"
  machine_type = "e2-standard-4"
  zone         = var.vectr_compute_zone

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2204-lts"
    }
  }
  metadata = {
      startup-script = <<-EOF1
        #!/bin/bash
        sudo su -
        curl -s -L 'https://github.com/docker/compose/releases/download/1.29.2/docker-compose-Linux-x86_64' -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose
        apt-get update
        apt-get -y install apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
        add-apt-repository \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\"
        apt-get update
        apt-get -y install docker-ce
        apt-get -y install mongodb-clients
        apt-get -y install unzip
        apt-get -y install collectd
        apt-get -y install docker-compose
        mkdir -p /opt/vectr
        echo ${google_compute_address.vectr_external_ip.address} > /home/ubuntu/name.txt
        cd /opt/vectr
        wget https://github.com/SecurityRiskAdvisors/VECTR/releases/download/ce-${var.vectr_version}/sra-vectr-runtime-${var.vectr_version}-ce.zip -P /opt/vectr
        unzip sra-vectr-runtime-${var.vectr_version}-ce.zip
        cd /opt/vectr/
        NAME=$(head -n 1 /home/ubuntu/name.txt)
        JWS=$(openssl rand -hex 24)
        JWE=$(openssl rand -hex 24)
        sed -i 's/VECTR_PORT=8081/VECTR_PORT=443/' .env
        sed -i "s/VECTR_HOSTNAME=sravectr.internal/VECTR_HOSTNAME=$NAME/" .env
        sed -i "s/VECTR_EXTERNAL_HOSTNAME=/VECTR_EXTERNAL_HOSTNAME=$NAME/" .env
        sed -i "s/JWS_KEY=CHANGEME/JWS_KEY=$JWS/" .env
        sed -i "s/JWE_KEY=CHANGEMENOW/JWE_KEY=$JWE/" .env
        docker-compose up -d
        EOF
      EOF1
    }
  network_interface {
    subnetwork = google_compute_subnetwork.vectr_vpc_subnet.id
    access_config {
      nat_ip = google_compute_address.vectr_external_ip.address
    }
  }
}
