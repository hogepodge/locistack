
Locistack
=========

Locistack is a basic OpenStack installer built on `OpenStack Loci`_ and
`Docker Compose`_. It serves many purposes, including being a fast,
non-ha OpenStack deployment useful for small clusters and testing. It is
being developed as a proof-of-concept platform for functional testing of
OpenStack Loci.

Getting Started
---------------

Locistack is being develped on CentOS_. For the time being this will
remain the target OS, as expanding on that adds complexity. At some point
I will consider adding Alpine_, Ubuntu_, and Suse_ support, but as this
is still a one-person project I'll favor moving forward in completeness
over additional support.

All of that to say, Step 1 is to go get CentOS_ if you want to run this.

Step 2 is to `install Docker`_, `Docker Compose`, and Git_.

With your host is set up, Step 3 is to fetch this project with ``git clone
https://github.com/hogepodge/locistack``.

For Step 4 you need to do a bit of setup to load kernel modules and make
selinux permissive (yes yes I know...). You also need to create a
permanent storage volume for glance and mount it to loopback device
`/dev/loop0`.  Locistack provides make_ targets to do all those things.

.. codeblock:: shell

   cd locistack
   make kernel-images
   make glance-storage
   make mount-glance-storage

You'll need to build your custom Loci images for Step 5. Do that by
setting environment variable inside of the ``Makefile`` to match your
`Docker Hub`_ account settings and executing ``make locistack``. This is
going to take a while. It's the longest step in the process.

For Step 6 It's time to configure Locistack! Do this by editing the
environment variables in ``config`` and please don't come crying to me
when your publicly visible OpenStack cloud is owned because you didn't
change the default passwords.

With that out of the way, the final step is to call ``docker-compose up
-d``. You can follow the progress of all of the containers starting by
running ``docker-compose logs -f`` and you can even optionally follow the
loga of just one container. I suggest ``docker-compose logs -f
post-install`` since it's the container that does all the final
initializing of things like images and networks and security groups.

With that done, go ahead and try out your cloud. You can bring up an
`OpenStack client`_ with ``make openstack-client``. Call ``source
/scripts/common/adminrc`` when the container starts and run ``openstack``
to interact with your cluster.

Have a good time with OpenStack and Loci!

.. image:: loci.jpg

.. _OpenStack Loci: http://git.openstack.org/cgit/openstack/loci/
.. _Docker Compose: https://docs.docker.com/compose/
.. _CentOS: https://www.centos.org
.. _Alpine: https://alpinelinux.org
.. _Ubuntu: https://www.ubuntu.com
.. _Suse: https://www.opensuse.org
.. _install Docker: https://get.docker.com
.. _Git: https://git-scm.com
.. _make: https://www.gnu.org/software/make/
.. _OpenStack client: https://docs.openstack.org/python-openstackclient/pike/
