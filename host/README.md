# TITLE
The project runs on a virtualbox VMs based on ubuntu20.04

## Create the VM
### Download image
Ubuntu 20.04.3 live-server amd64
https://ubuntu.com/download/server
### Create VM
Open virtualbox and create a new virtual machine
- name and OS :
    - name: ornikar
    - machine directory: default (/home/afa-perso/VirtualBox VMs)
    - type: Linux
    - version: Ubuntu 64bits
- Memory size: 4096MB
- hard disk:
    - bullet point: create a virtual hard disk now
    - hard disk file type: VDI (VirtualBox Disk Image)
    - dynamic size: false
    - size: 25Gio
Once the VMs has been created set up some configuration:
- CPU: 4
- Activate PAE/NX: true
- Activate VT-x/AMD-v imbricated: can't be ticked on my machine (so it will be impossible to use a virtualisation system inside the VM)
- put the iso image downloaded in the virtual disk reader
- network: bridge access wlp2s0
### First boot on the VM (OS installation)
- language: English
- keyboard:
    - layout: french
    - variant: french
- network connection: default
- proxy configuration: default (empty)
- configure ubuntu archive mirror: default (http://fr.archive.ubuntu.com/ubuntu)
- storage configuration: default (use entire disk, set up this disk as an lvm group)
- profile setup:
    - your name: afa
    - your server's name: ornikar
    - username: afa
    - password: in keepassXC-personnal.kdbx
- ssh setup
    - install OpenSSH server: true
    - Import SSH identity:
        - source: from GitHub
        - GitHub Username: arthur91f
    - allow password authentication over SSH: false
- feature server snap:
    - don't install anything proposed even docker because minikube won't works with snap docker ;)
- create a snapshot to not have to redo that action 
### Install tools
- connect on ssh to that VM
- copy paste 1-install_minikube.sh in the shell
- 
