
FROM ubuntu
RUN apt-get update && apt-get install -y curl
RUN apt-get install -y gnupg2
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv E52529D4
RUN echo 'echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.0 multiverse" > /etc/apt/sources.list.d/mongodb-org-4.0.list'

RUN dpkg-divert --local --rename --add /sbin/init
RUN ln -s /bin/true /sbin/init

RUN apt-get update
RUN apt-get install -y mongodb
# Define mountable directories.
#VOLUME ["/data/db"]
RUN mkdir -p /data/db

EXPOSE 27017
CMD ["usr/bin/mongod", "--smallfiles"]
