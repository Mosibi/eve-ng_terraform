# Install EVE-NG using Terraform
EVE-NG is a graphical network emulator which can be used to create complex virtual network setups that reflect the (to be) real world. This project installs EVE-NG together with Cumulux VX, a virtual Cumulus appliance, using Terraform. 

Terraform uses providers to interact with an infrastructure provider like AWS, Google Cloud or VMWare. In this case, I use the libvirt provider, which has to be installed separately.

## Prepare your work environment
### Install Terraform
Installing Terraform is very simple, [download](https://www.terraform.io/downloads.html) the CLI binary for your platform and place in your $PATH, for example in your personal bin directory ~/bin/. For example

```lang=shell
wget https://releases.hashicorp.com/terraform/0.12.26/terraform_0.12.26_linux_amd64.zip
unzip -x terraform_0.12.26_linux_amd64.zip 
mv terraform ~/bin/terraform
mv terraform ~/bin/terraform_0.12.26_linux_amd64 
rm ~/bin/terraform
ln -s ~/bin/terraform_0.12.26_linux_amd64 ~/bin/terraform
```

### Install libvirt provider for Terraform
First create the directory where the Terraform plugins are read from
```lang=shell
mkdir -p ~/.terraform.d/plugins
```

Download the latest version of the plugin and place it in the plugins directory. The example below assumes you are working on a Red Hat family system, visit https://github.com/dmacvicar/terraform-provider-libvirt/releases to download the plugin for another platform.

```lang=shell
wget https://github.com/dmacvicar/terraform-provider-libvirt/releases/download/v0.6.2/terraform-provider-libvirt-0.6.2+git.1585292411.8cbe9ad0.Fedora_28.x86_64.tar.gz
tar xvzf terraform-provider-libvirt-0.6.2+git.1585292411.8cbe9ad0.Fedora_28.x86_64.tar.gz -C ~/.terraform.d/plugins/
```

### Download EVE-NG community edition
[Download](https://www.eve-ng.net/index.php/download/) the community edition in OVF format and unzip it in this project directory. After unzipping, the vmdk image must be converted to the QCOW2 format

```lang=shell
unzip -x ~/Downloads/EVE-COMM-VM.zip
qemu-img convert EVE-COMM-VM/EVE-COMM-VM-0.vmdk -f vmdk -O qcow2 EVE-COMM-VM/EVE-COMM-VM-0.qcow2
```

### Download Cumulus VX
[Download](https://cumulusnetworks.com/products/cumulus-vx/download/thanks/kvm-411-/) Cumulus-VX version 4.1.1 and put it in the cumulus directory in this project

```lang=shell
mkdir cumulus
mv ~/Downloads/cumulus-linux-4.1.1-vx-amd64-qemu.qcow2 cumulus/
```

## Install EVE-NG using Terraform
When the project directory is not initialized yet as a Terraform project, the following commands must be ran. To be clear, this is only necesarry one time.

```lang=shell
terraform init
terraform plan
```

**Install EVE-NG**
```lang=shell
terraform apply
```

![Install demo](install.gif)