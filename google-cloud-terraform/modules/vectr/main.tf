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
        until apt-get update; do sleep 1; done;
        until apt-get -y install ca-certificates curl gnupg lsb-release apt-transport-https software-properties-common; do sleep 1; done;
        mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        until apt-get update; do sleep 1; done;
        until apt-get -y install docker-ce docker-ce-cli containerd.io docker-compose-plugin unzip collectd jq; do sleep 1; done;
        mkdir -p /opt/vectr
        echo ${google_compute_address.vectr_external_ip.address} > /home/ubuntu/name.txt
        cd /opt/vectr
        wget $(curl 'https://api.github.com/repos/SecurityRiskAdvisors/VECTR/releases?page=1&per_page=1' | jq -r '.[0].assets[] | select(.browser_download_url | endswith(".zip")) | .browser_download_url') -O /opt/vectr/latestRelease.zip
        unzip latestRelease.zip
        NAME=$(head -n 1 /home/ubuntu/name.txt)
        JWS=$(openssl rand -hex 24)
        JWE=$(openssl rand -hex 24)
        sed -i 's/VECTR_PORT=8081/VECTR_PORT=443/' .env
        sed -i "s/VECTR_HOSTNAME=sravectr.internal/VECTR_HOSTNAME=$NAME/" .env
        sed -i "s/VECTR_EXTERNAL_HOSTNAME=/VECTR_EXTERNAL_HOSTNAME=$NAME/" .env
        sed -i "s/JWS_KEY=CHANGEME/JWS_KEY=$JWS/" .env
        sed -i "s/JWE_KEY=CHANGEMENOW/JWE_KEY=$JWE/" .env
        docker compose up -d
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