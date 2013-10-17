vagrant-redmono
===============

redmondo stands for:
- redis
- mongodb
- nodejs

In a nutshell, the aim of this project is to provide enough config to provision a vagrant box with the stack as mentioned above, ready to serve your development.

One thing worth mentioning - in to keep greater degree of control over the environment, this project compiles redis, mongo and node from source. The reason being: There are some difficulties getting the latest version of the stack on Ubuntu 12.04 for example, and the ppa repo does not always allow you to choose the version you want. In my experience, redis ppa had quite poor selection of versions for example.

# Future considerations
As I find DigitalOcean really nice, I have an idea of using their awesome API to control the full provisioning process from puppet. That including provisioning a new box of course.

# Give the credit where it's due
My project uses / is inspired by a few open source puppet modules. Here they are:
- https://github.com/puppetlabs/puppetlabs-apt
- https://github.com/puppetlabs/puppetlabs-stdlib
- https://github.com/logicalparadox/puppet-nodejs
- https://github.com/logicalparadox/puppet-redis


