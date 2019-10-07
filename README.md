-- DRAFT --

These scripts will allow you to deploy firewalls, vpns, and identity managers in Azure and AWS using Terraform

Currently an example template is provided for Azure. 

Steps to use: 

1. Install terraform 
https://learn.hashicorp.com/terraform/getting-started/install.html

2. Update the script fw_azure.tf with real values for your environment. 

Currently this script use Azure Application registrations to authenticate and authorize the terraform script. 

The current values for the network assume 10.252.0.0/24. 

You will also need to replace the sample CA root provided with one that works for you. 
( This is temporary as we will be using Radius to manage authentication for the VPN(s). 

After the terraform script finishing running, you will need to ssh into the FreeBSD machines to now install OpnSense. 

On each firewall, substitute the proper values for your wanip, lanip, etc. then run: 

  pkg install -y ca_root_nss
  fetch https://raw.githubusercontent.com/wjwidener/update/master/bootstrap/opnsense-bootstrap.sh
  fetch https://raw.githubusercontent.com/wjwidener/update/master/bootstrap/config.xml
  fetch https://raw.githubusercontent.com/wjwidener/update/master/bootstrap/updateips.sh
  sh ./opnsense-bootstrap.sh -y
  sh ./updateips.sh <wanip> <wansubnet-cidr> <lanip> <lansubnet-cidr> <langw-ip> <wangw-ip>
  cp config.xml /usr/local/etc/config.xml
  reboot

Then install FreeIPA/RedHAt IdM with Radius support and modify your Azure VPN to use Radius. 
<instructions to do so coming soon...>
