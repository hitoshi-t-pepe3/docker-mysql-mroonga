FROM centos:centos6
MAINTAINER pepechoko

# rpmforge && epel install
RUN \
  rpm --import http://apt.sw.be/RPM-GPG-KEY.dag.txt && \
  rpm -ivh http://apt.sw.be/redhat/el6/en/x86_64/rpmforge/RPMS/rpmforge-release-0.5.3-1.el6.rf.x86_64.rpm && \
  rpm -ivh http://ftp-srv2.kddilabs.jp/Linux/distributions/fedora/epel/6/x86_64/epel-release-6-8.noarch.rpm

# for php 5.5
RUN \
 rpm -ivh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm

RUN yum install -y --enablerepo=epel,mysql56 \
  mysql \
  mysql-devel \
  mysql-server \
  mysql-utilities \
  supervisor

RUN mkdir -p \
  /var/log/mysql \
  /var/log/supervisor


RUN \
  service mysqld start && \ 
    sleep 5s && \
    mysql -e "GRANT ALL ON *.* to 'root'@'%'; FLUSH PRIVILEGES" 

RUN \
	rpm -ivh http://packages.groonga.org/centos/groonga-release-1.1.0-1.noarch.rpm

RUN yum install -y --disablerepo=* --enablerepo=groonga \
	mecab \
  mecab-devel \
  mecab-ipadic  \

RUN yum install -y --disablerepo=* --enablerepo=groonga \
  groonga-libs \
  groonga-tokenizer-mecab \ 
  groonga-normalizer-mysql 

RUN \
	yum localinstall http://y-ken.github.io/package/centos/6/x86_64/mysql56-mroonga-3.05-1.el6.x86_64.rpm

EXPOSE 3306

# VOLUME /var/lib/mysql

CMD ["/usr/bin/mysqld_safe"]
