vagrant-redmono
===============

redmondo stands for:
- redis
- mongodb
- nodejs

In a nutshell, the aim of this project is to provide enough config to provision a vagrant box with the stack as mentioned above, ready to serve your development.

One thing worth mentioning - in to keep greater degree of control over the environment, this project compiles redis, mongo and node from source. The reason being: There are some difficulties getting the latest version of the stack on Ubuntu 12.04 for example, and the ppa repo does not always allow you to choose the version you want. In my experience, redis ppa had quite poor selection of versions for example.

I have built and tested this project against Ubuntu 12.04 64 bit. If you need 32 it's easy to change:

- add precise32 instead of the 64 version during installation (see below)
- go to Vagrantfile, find the directive config.vm.box = "precise64" and change its value to "precise32"
- done

# Installation
Dead easy. You need to be aware however, that this project uses git submodules, so you need to fetch them, too. It's simple enough.

```bash
git clone https://github.com/jciolek/vagrant-redmono
cd vagrant-redmono
git submodule init
git submodule update
vagrant box add precise64 http://files.vagrantup.com/precise64.box
vagrant up
```

# Future considerations
As I find DigitalOcean really nice, I have an idea of using their awesome API to control the full provisioning process from puppet. That including provisioning a new box of course.

# Give the credit where it's due
My project uses / is inspired by a few open source puppet modules. Here they are:
- https://github.com/puppetlabs/puppetlabs-apt
- https://github.com/puppetlabs/puppetlabs-stdlib
- https://github.com/logicalparadox/puppet-nodejs
- https://github.com/logicalparadox/puppet-redis


