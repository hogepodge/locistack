Locistack
=========

Locistack is a basic OpenStack installer built on `OpenStack Loci`_ and
`Docker Compose`_. It serves many purposes, including being a fast,
non-HA OpenStack deployment useful for small clusters and testing. It is
being developed as a proof-of-concept platform for functional testing of
OpenStack Loci.

Getting Started
---------------

Locistack is being develped on CentOS_. For the time being this will
remain the target OS, as expanding on that adds complexity. At some point
I will consider adding Alpine_, Ubuntu_, and Suse_ support, but as this
is still a one-person project I'll favor moving forward in completeness
over additional support.

Locistack has three major phases for deployment: config, build, and
deploy. These should be done in order for a successful deployment (in the
future config may be split up into host-config and guest-config, since
they have different targets). 

config
~~~~~~
In the config directory you can install everythin you need by executing
``make_ all``. This will install docker as well as other essential
packages, load the necessary kernel modules you will need to operate the
cluster, create TLS certificates (this is an interactive step), and
create and mount a Cinder storage loopback device.

If you've already run ``make all`` on a system you've rebooted, you only
need to run ``make post-boot`` to reload the kernel and security settings
and remount the loop device.

Once you've configured the host, you need to edit the ``config/config``
file to match the settings for your system.

build
~~~~~
The next step is to build your Loci and supporting containers. In the
build directory ``make locistack`` will build all of your containers. Be
sure to set your ``DOCKERHUB_NAMESPACE`` and other build related variable
in the Makefile.

You can also optionally build some images to boot in your OpenStack
environment. Right now there is support for a CentOS-based Kubernetes
image. You can build it with ``make centos7-k8s.qcow2``.

deploy
~~~~~~
With your configuration and build done, deploy OpenStack with ``make up``
in the deploy directory. This will run ``docker-compose`` in daemon mode.
You can bring the cluster down with ``make down``, shut the cluster down
and remove state with ``make down-v``, and follow all of the logs with
``make logs``.

Connect to your cluster with ``make client``, then within the client source
your credentials with ``source /scripts/common/admin``. Since the
certificates are unsigned you'll need to run the OpenStack Client in
insecure mode, ``openstack --insecure``.


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
