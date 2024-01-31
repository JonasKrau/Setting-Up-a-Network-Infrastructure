# Setting up Network Infrastructure

## Overview
This Bash script automates the setup of network infrastructure in Google Cloud Platform (GCP). It specifically focuses on creating VPC networks, subnets, Ubuntu-based VM instances, custom images, and firewall rules. The script is tailored for users with basic to intermediate knowledge of GCP, aiming to streamline the initial configuration process for cloud projects.

## Prerequisites
- **Google Cloud Account:** An active Google Cloud account is required.
- **Billing Enabled:** Ensure that your Google Cloud account has billing enabled as the resources created by this script will incur costs.
- **Ubuntu Operating System:** This script needs to be executed on a Ubuntu OS.
- **gcloud CLI Setup:** Before running the script, the Google Cloud CLI should be installed and configured on your machine.


## SSH Key Generation
Generate an SSH key pair for secure access to VM instances:

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
```

## Script Execution
- Clone the repository:

```
git clone https://github.com/JonasKrau/Setting-Up-a-Network-Infrastructure.git
```

 and execute 
 
 ```
 ./gcp-network-vm-setup.sh
 ```

## What's Created:

### VPC Networks
- **cc-network1 and cc-network2**: Two Virtual Private Cloud (VPC) networks for resource management and isolation. VPCs enable secure and isolated network environments within the cloud, essential for organizing cloud-based resources effectively.

### Subnets
- **Within each VPC**: Subnets for `cc-network1` and `cc-network2` are created. These subnets define smaller network areas within the VPCs with specific IP range settings, allowing for more granular control of network traffic and resource allocation.

### Persistent Disk
- **Ubuntu-Based Disk**: A persistent disk is created based on the Ubuntu 22.04 LTS image. 

### Custom Image
- **With Nested Virtualization**: A custom image enabling nested virtualization is created from the persistent disk. Nested virtualization is particularly useful for running VMs within VMs, facilitating various testing and development scenarios.

### Firewall Rules
- **Traffic Control within VPC Networks**: Firewall rules are set up to manage and secure the network traffic within the VPC networks. Specific rules include allowing TCP, ICMP, and UDP traffic for defined IP ranges in the subnets, and a rule to allow SSH traffic from any external IP for secure remote access.

### VM Instances
- **controller, compute1, and compute2**: Three VM instances are created using the custom Ubuntu image with nested virtualization. 


## Costs and Billing
Creating these resources in GCP will incur costs. Regularly review and clean up unneeded resources.

## License
This project is licensed under the Apache License 2.0 - see the [LICENSE](LICENSE) file for details.

## Contact
For queries, contact krause@tu-berlin.de