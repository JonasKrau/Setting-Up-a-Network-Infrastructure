#!/bin/bash

# Creation of VPC-networks: cc-network1 and cc-network2
echo "Creation of VPC-networks: cc-network1 and cc-network2"

# Creation of first VPC network: cc-network1
gcloud compute networks create cc-network1 --subnet-mode=custom

# Creation of second VPC network: cc-network2
gcloud compute networks create cc-network2 --subnet-mode=custom

echo "VPC networks created successfully."


# Creation of subnets for the VPC networks

# Creation of cc-subnet1 with primary and secondary IP range 
echo "Creation of subnet: cc-subnet1 with secondary IP range"
gcloud compute networks subnets create cc-subnet1 \
 --region=europe-west4 \
 --network=cc-network1 \
  --range=10.0.1.0/24 \
  --secondary-range sec-range=10.0.2.0/24


# Creation of cc-subnet2 with primary IP range 
echo "Creation of subnet: cc-subnet2"
gcloud compute networks subnets create cc-subnet2 \
  --region=europe-west4 \
  --network=cc-network2 \
  --range=10.0.3.0/24

echo "Subnets created successfully."


# Creation of disk based on Ubuntu 22.04 LTS Image
echo "Creating a disk based on the 'ubuntu-2204-lts' image with a size of 100GB"

gcloud compute disks create ubuntu-disk \
  --size=100GB \
  --image-family=ubuntu-2204-lts \
  --image-project=ubuntu-os-cloud \
  --type=pd-standard\
  --zone=europe-west4-a

echo "Disk created successfully."


# Creation of a custom image including license for nested virtualization
echo "Creating a custom image with nested virtualization support"
gcloud compute images create custom-ubuntu-image \
  --source-disk ubuntu-disk \
  --source-disk-zone europe-west4-a \
  --licenses "https://www.googleapis.com/compute/v1/projects/vm-options/global/licenses/enable-vmx"

echo "Custom image created successfully."

# Creating a firewall rule that allows all TCP, ICMP, and UDP traffic for the IP ranges of cc-subnet1
echo "Creating firewall rule to allow all traffic for cc-subnet1 and cc-subnet2 for VMs with 'cc' tag"
gcloud compute firewall-rules create cc-allow-all-traffic-network1 \
  --direction=INGRESS \
  --priority=1000 \
  --network=cc-network1 \
  --action=ALLOW \
  --rules=tcp:22,udp,icmp \
  --source-ranges=10.0.1.0/24 \
  --target-tags=cc

# Creating a firewall rule that allows all TCP, ICMP, and UDP traffic for the IP ranges of cc-subnet2
gcloud compute firewall-rules create cc-allow-all-traffic-network2 \
  --direction=INGRESS \
  --priority=1000 \
  --network=cc-network2 \
  --action=ALLOW \
  --rules=tcp:22,udp,icmp \
  --source-ranges=10.0.3.0/24 \
  --target-tags=cc

echo "Firewall rules for both networks created successfully."


# Creating a firewall rule to allow SSH traffic from any external IP address
echo "Creating firewall rule to allow SSH traffic from any external IP"
gcloud compute firewall-rules create allow-external-ssh \
  --direction=INGRESS \
  --priority=1000 \
  --network=cc-network1 \
  --action=ALLOW \
  --rules=tcp:22,icmp \
  --source-ranges=0.0.0.0/0 \
  --target-tags=cc

echo "SSH firewall rule created successfully."



# Creating the 'controller' VM with nested virtualization and external IP on cc-network1
echo "Creating the 'controller' VM with nested virtualization and external IP on cc-network1"
gcloud compute instances create controller \
  --zone=europe-west4-a \
  --machine-type=n2-standard-2 \
  --image=custom-ubuntu-image \
  --tags=cc \
  --network-interface subnet=cc-subnet1 \
  --network-interface subnet=cc-subnet2,no-address

echo "'controller' VM created successfully."


# Creating the 'compute1' VM with nested virtualization and external IP on cc-network1
echo "Creating the 'compute1' VM with nested virtualization and external IP on cc-network1"
gcloud compute instances create compute1 \
  --zone=europe-west4-a \
  --machine-type=n2-standard-2 \
  --image=custom-ubuntu-image \
  --tags=cc \
  --network-interface subnet=cc-subnet1 \
  --network-interface subnet=cc-subnet2,no-address

echo "'compute1' VM created successfully."

# Creating the 'compute2' VM with nested virtualization and external IP on cc-network1
echo "Creating the 'compute2' VM with nested virtualization and external IP on cc-network1"
gcloud compute instances create compute2 \
  --zone=europe-west4-a \
  --machine-type=n2-standard-2 \
  --image=custom-ubuntu-image \
  --tags=cc \
  --network-interface subnet=cc-subnet1 \
  --network-interface subnet=cc-subnet2,no-address

echo "'compute2' VM created successfully."