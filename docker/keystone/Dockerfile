FROM hogepodge/loci-keystone:rocky-centos
MAINTAINER chris@openstack.org
ADD /wait-for-it.sh /wait-for-it.sh
ADD /start-keystone-api.sh /start-keystone-api.sh
ADD /keystone-uwsgi-admin.ini /keystone-uwsgi-admin.ini
ADD /keystone-uwsgi-public.ini /keystone-uwsgi-public.ini
ADD /wsgi-keystone.conf /wsgi-keystone.conf
ADD /keystone-paste.ini /etc/keystone/keystone-paste.ini
ADD /generate.keystone.conf /generate.keystone.conf
ADD /generate.httpd.conf /generate.httpd.conf
