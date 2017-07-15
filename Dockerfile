# written by Benoit Sarda
# ejbca container. uses bsarda/jboss by copy/paste.
#
#   bsarda <b.sarda@free.fr>
#
#FROM centos:centos7.2.1511
#FROM centos:7
FROM debian:latest
LABEL maintainer "b.sarda@free.fr"

# expose
EXPOSE 8443

# declare vars
ENV DB_SERVER=192.168.63.5 \
		DB_PORT=5432 \
		DB_NAME=netbox \
		DB_USER=netbox \
		DB_PASSWORD=P@ssw0rd! \
		SU_NAME=admin \
		SU_MAIL=admin@localhost \
		SU_PASSWORD=P@ssw0rd! \
		SSL_COUNTRY=FR \
		SSL_STATE=IDF \
		SSL_CITY=Paris \
		SSL_ORG=Lab
COPY ["init.sh", "stop.sh", \
			"/usr/local/bin/"]

RUN	chmod 750 /usr/local/bin/init.sh && chmod 750 /usr/local/bin/stop.sh

RUN mkdir /var/netbox -p && \
		apt-get update && \
		apt-get install -y python3 python3-dev python3-pip && \
		apt-get install -y libpng-dev libjpeg-dev libxml2-dev libxslt1-dev libffi-dev graphviz libpq-dev libssl-dev zlib1g-dev && \
		apt-get install -y gcc musl-dev curl git && \
		apt-get install -y apache2 libapache2-mod-wsgi-py3 && \
		apache2ctl stop && \
		update-alternatives --install /usr/bin/python python /usr/bin/python3 1

RUN git clone -b master https://github.com/digitalocean/netbox.git /var/netbox && \
		cd /var/netbox && pip3 install -r requirements.txt && \
		pip3 install pytz pyasn1 bcrypt libnacl PyNaCl coreapi openapi_codec simplejson ConfigParser gunicorn && \
		cp /var/netbox/netbox/netbox/configuration.example.py /var/netbox/netbox/netbox/configuration.py

CMD ["/usr/local/bin/init.sh"]
