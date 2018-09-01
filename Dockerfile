FROM centos:7

MAINTAINER Luan Ngo Minh

# Copy server file
RUN mkdir /var/app
COPY bin/server /var/app/server
RUN chmod -v +x /var/app/counter

# Add nginx repo
COPY config/nginx/nginx.repo /etc/nginx.repo

# Install EPEL and Remi
RUN yum -y install http://rpms.famillecollet.com/enterprise/remi-release-7.rpm

# Update server
RUN yum -y update

#  Install nginx, supervisor
RUN yum -y install nginx supervisor

# Add nginx config
COPY config/nginx/app.conf /etc/nginx/conf.d/app.conf
COPY config/nginx/nginx.conf /etc/nginx/nginx.conf

# Add supervisor config
COPY config/supervisor/goserver.ini /etc/supervisord.d/goserver.ini
COPY config/supervisor/nginx.ini    /etc/supervisord.d/nginx.ini

# Install py pip
RUN curl https://bootstrap.pypa.io/get-pip.py | python && pip install schedule

EXPOSE 80

CMD ["/var/app/server", "-D", "FOREGROUND"]
