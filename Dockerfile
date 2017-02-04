## Pulling Centos 6 base image from Docker Hub###
FROM centos:centos6

### Installing python 2.7 along with dependencies ###

RUN yum groupinstall -y development

RUN yum install -y zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel wget tar 

RUN cd /opt && \
    wget --no-check-certificate https://www.python.org/ftp/python/2.7.6/Python-2.7.6.tar.xz && \
    tar xf Python-2.7.6.tar.xz && \
    cd Python-2.7.6 && \
    ./configure --prefix=/usr/local && \
    make && make altinstall

#### Making python 2.7 as default version ####

RUN ln -s /usr/local/bin/python2.7 /usr/local/bin/python


 #### Download JDK ####
RUN cd /opt;wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/7u55-b13/jdk-7u55-linux-x64.tar.gz; pwd

RUN cd /opt;tar xvf jdk-7u55-linux-x64.tar.gz
RUN alternatives --install /usr/bin/java java /opt/jdk1.7.55/bin/java 2

 #### Download Apache Tomcat 7

RUN cd /tmp;wget http://apache.cs.utah.edu/tomcat/tomcat-7/v7.0.75/bin/apache-tomcat-7.0.75.tar.gz

 # untar and move to proper location

RUN cd /tmp;tar xvf apache-tomcat-7.0.75.tar.gz

RUN cd /tmp;mv apache-tomcat-7.0.75 /opt/tomcat7

RUN chmod -R 755 /opt/tomcat7

ENV JAVA_HOME /opt/jdk1.7.0_55

####Installing mongodb 3.4.2 from binary######

RUN curl -O https://fastdl.mongodb.org/linux/mongodb-linux-x86_64-3.4.2.tgz

RUN tar -zxvf mongodb-linux-x86_64-3.4.2.tgz

RUN mkdir -p mongodb

RUN cp -R -n mongodb-linux-x86_64-3.4.2/ mongodb

RUN mkdir -p /data/db
RUN cp /mongodb/mongodb-linux-x86_64-3.4.2/bin/mongod /usr/local/bin

RUN echo 'mongod --fork --logpath=/var/log/mongod.log' >> /start.sh
RUN echo '/opt/tomcat7/bin/catalina.sh run' >> /start.sh
RUN echo 'tail -f /dev/null' >> /start.sh
RUN chmod a+x /start.sh
EXPOSE 27017 8080

### Starting Tomcat 7 and Mongod at bootup###
CMD bash -x /start.sh
