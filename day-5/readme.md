# Introduction 
Today, we will deploy an end-to-end solution with Terraform. You will break into 3 teams.

## Cloud
1. Deploy IoT Hub with Private Endpoint
1. Deploy Private DNS Zone for IoT Hub
1. Use Powershell to install Azure IoT Edge on Virtual Machine
1. Use Powershell to download simulation telemetry container
1. Deploy Azure Windows Virtual Machine - bootstrap

## Network Team (use existing CISCO 8000v)
1. Configure Interfaces
1. Configure FQDN Access-Lists
1. Configure Access-Lists
1. Configure SSLVPN

## Cloud
1. Deploy Azure Windows Virtual Machine for Hyper-V
1. Configure Hyper-V as Custom Script Extension to "Bootstrap" host.
1. Deploy Hyper-V Windows Virtual Machine
1. Use Powershell to install Azure IoT Edge on Virtual Machine
1. Use Powershell to download simulation telemetry container
1. Attempt to bootstrap Hyper-V VM

# Resources
The following URLs:
1.	IOT Edge Quickstart: https://learn.microsoft.com/en-us/azure/iot-edge/quickstart?view=iotedge-1.5
1.	Bootstrap a VM host with Powershell: https://silvr.medium.com/bootstrapping-azure-vms-with-powershell-scripts-using-terraform-cab91318dde4
1.	CISCO 8000v on Azure: https://www.cisco.com/c/en/us/td/docs/routers/C8000V/Azure/deploying-cisco-catalyst-8000v-on-microsoft-azure/deploy-c8000v-on-microsoft-azure.html
1.	API references