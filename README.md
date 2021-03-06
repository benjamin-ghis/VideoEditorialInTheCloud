# Avid Video Editorial In Azure Cloud
 
## Introduction 

This repository contains a collection of modules which allows Avid Enterprise customers to set up a full editorial environment in azure cloud: media transfer, storage, secure remote connection, video and audio editing (MediaComposer, ProTools), monitoring etc... Avid customers are able to either deploy environment via ARM template or Terraform technology. Ansible playbooks are available to automate software configuration on pre-built resources.

Avid storage account is configured for private access only. You will not be able to download installers publicly. Please contact Avid to get a token generated to gain access to it. 
 
## Deployment

Follow each link below to get more details on each technology.

### Terraform 
- This repository covers deployment via [Terraform](https://github.com/avid-technology/VideoEditorialInTheCloud/tree/master/Avid_Edit_In_The_Cloud_Terraform) technology.
 
### Arm Template
- This repository covers deployment via [Arm Template](https://github.com/avid-technology/VideoEditorialInTheCloud/tree/master/Avid_Edit_In_The_Cloud_Arm) technology. 

### Ansible Playbook
- This repository covers configuration via [Ansible Playbooks](https://github.com/avid-technology/VideoEditorialInTheCloud/tree/master/Avid_Edit_In_The_Cloud_Ansible) technology.
 
 
## Prerequisites  
- [Azure subscription](https://portal.azure.com)
- Avid licenses
- Teradici licenses
- Aspera / FileCatalyst / Signiant license(s)
