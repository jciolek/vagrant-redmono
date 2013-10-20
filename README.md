vagrant-redmono
===============

redmondo stands for:
- redis
- mongodb
- nodejs

In a nutshell, the aim of this project is to provide enough config to provision a vagrant box with the stack as mentioned above, ready to serve your development.

One thing worth mentioning - in order to keep greater degree of control over the environment, this project compiles redis and nodejs from source. The reason being: There are some difficulties getting the latest version of the stack on Ubuntu 12.04 for example, and the ppa repo does not always allow you to choose the version you want. In my experience, redis ppa had quite poor selection of versions.

# Installation
Dead easy. You need to be aware however, that this project uses git submodules, so you need to fetch them, too. It's simple enough, covered in the installation steps below.

## Requirements
Of course you are going to need Vagrant and VirtualBox. If you are using Ubuntu 12.04 on your machine (like myself) my suggestion is do not go for the repo version of the packages, but rather get them from the vendor:
- https://www.virtualbox.org/wiki/Linux_Downloads
- http://downloads.vagrantup.com/tags/v1.3.3

## The final steps
```bash
git clone https://github.com/jciolek/vagrant-redmono
cd vagrant-redmono
git submodule init
git submodule update
vagrant box add precise64 http://files.vagrantup.com/precise64.box
vagrant up
```
And there you go. Your vagrant box is up and running, with nodejs, redis and mongodb, waiting for your app to change the world. Have fun!


# The environment

## Guest system (Ubuntu 12.04 64 bit)
I have built and tested this project against Ubuntu 12.04 64 bit. If you need 32 it's easy to change.
- add precise32 instead of the 64 version during installation (see below)
- go to Vagrantfile, find the directive config.vm.box = "precise64" and change its value to "precise32"
- enjoy


## Building blocks
The box provisioned will have the following installed and ready to rock and roll:

- nodejs: v0.10.18 (compiled from source)
- redis: v2.4.14 (compiled from source, listening on port 6379)
- mongodb: latest version from http://downloads-distro.mongodb.org/repo/ubuntu-upstart
- rinetd: for redirecting external ports (80, 443) to local ones
- npm modules: forever, bower and grunt-cli


## Networking
### IP address
The network interface address of the guest is statically assigned as 10.0.0.2, the host will have 10.0.0.1. It makes things easier to access the vagrant box from your local machine - simply put an entry to your hosts file and you are done.

If you use this range in your local network or you do not like that for whatever other reason you have two friens to help you out with it: the Vagrantfile and the URL: http://docs.vagrantup.com/v2/networking/

### Port redirection
The hassle of accessing port 3000 or wotnot if you do not want to run node as root (probably you should not want that) made me add rinetd. This clever little thing neatly redirects external to local ones (localhost). I have set it up for ports 80 and 443 going to 3080 and 3443 respectively. Of course it's configurable, so you can easily change the ports in the Vagrantfile or add your own. Please note port 443 - it's SSL ready.

# Future considerations
As I find DigitalOcean really nice, I have an idea of using their awesome API to control the full provisioning process from puppet. That including provisioning a new box of course.

# Give the credit where it's due
My project uses / is inspired by a few open source puppet modules. Here they are:
- https://github.com/puppetlabs/puppetlabs-apt
- https://github.com/puppetlabs/puppetlabs-stdlib
- https://github.com/logicalparadox/puppet-nodejs
- https://github.com/logicalparadox/puppet-redis


