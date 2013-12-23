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
And there you go. Your vagrant box is up and running, with nodejs, redis and mongodb, waiting for your app to change the world.

The sample app should be instantly accessbile at http://10.0.0.2/ and reacting to any change you make to it. Check it out!

# The environment

## Guest system (Ubuntu 12.04 64 bit)
I have built and tested this project against Ubuntu 12.04 64 bit. If you need 32 it's easy to change.
- add precise32 instead of the 64 version during installation (see below)
- go to Vagrantfile, find the directive config.vm.box = "precise64" and change its value to "precise32"
- enjoy


## Building blocks
The box provisioned will have the following installed and ready to rock and roll:

- nodejs: v0.10.24 (compiled from source)
- redis: v2.8.3 (compiled from source, listening on port 6379)
- mongodb: latest version from http://downloads-distro.mongodb.org/repo/ubuntu-upstart
- nginx: as a reverse proxy, serving over http and https
- supervisor: to keep your app up and running
- npm modules: supervisor, forever, bower and grunt-cli

also, as an alternative to nginx:
- rinetd: for redirecting external ports (80, 443) to local ones

## Networking
### IP address
The network interface address of the guest is statically assigned as 10.0.0.2, the host will have 10.0.0.1. It makes things easier to access the vagrant box from your local machine - simply put an entry to your hosts file and you are done.

If you use this range in your local network or you do not like that for whatever other reason you have two friens to help you out with it: the Vagrantfile and the URL: http://docs.vagrantup.com/v2/networking/

### Port redirection
The hassle of accessing port 3000 or wotnot if you do not want to run node as root (probably you should not want that) made me add rinetd. This clever little thing neatly redirects external to local ones (localhost). I have set it up for ports 80 and 443 going to 3080 and 3443 respectively. Of course it's configurable, so you can easily change the ports in the Vagrantfile or add your own. Please note port 443 - it's SSL ready.

Later on I have decided to replace rinetd with nginx serving as a reverse proxy. It has serveral advantages:
- can take on the responsibility of serving your node app over ssl
- can serve from multiple vhosts, proxying serveral apps on the same server

I have left rinetd commented out in the main manifest and ready to be deployed if you feel like nginx is too fancy for you.

## How about your app?
The whole purpose of this project is to create dev environment instantly. Ideally, serving your app from the get-go and reacting to changes as you make them. I have some good news for you here - it works like that!

Initially, the directory ./node from this project gets mounted on the VM under /var/node. You can change this setting or add other directories to be mounted in the Vagrantfile. The sample application (my-app) which you can find in ./node is started through node-supervisor, which keeps monitoring file changes. Every time you change something in your app it gets restarted.

node-supervisor is in turn started by supervisord, which makes sure that whenever the latter crashes it will get respawned.

As I usually tend to work on a few projects at the same time, limiting myself to one app in this setup would be silly. Therefore both supervisor and nginx take their configuration from the $apps hash in ./puppet/manifests/default.pp. You can specify as many apps as you want, following the example given. Puppet will create configuration files for them which should keep them running.

The good news don't stop here. If you provision for "production" instead of "development" (you need make the change in puppet/manifests/default.pp) bare node takes care of running your app instead of node-supervisor. 

# Future considerations
As I find DigitalOcean really nice, I have an idea of using their awesome API to control the full provisioning process from puppet. That including provisioning a new box of course.

# Give the credit where it's due
My project uses / is inspired by a few open source puppet modules. Here they are:
- https://github.com/puppetlabs/puppetlabs-apt
- https://github.com/puppetlabs/puppetlabs-stdlib
- https://github.com/logicalparadox/puppet-nodejs
- https://github.com/logicalparadox/puppet-redis


