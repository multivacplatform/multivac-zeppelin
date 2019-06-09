# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
FROM ubuntu:16.04
LABEL maintainer="maziyar.panahi@iscpif.fr"
# `Z_VERSION` will be updated by `dev/change_zeppelin_version.sh`
ENV Z_VERSION="0.8.2"
ENV LOG_TAG="[ZEPPELIN_${Z_VERSION}]:" Z_HOME="/home/zeppelin" LANG=en_US.UTF-8 LC_ALL=en_US.UTF-8
RUN echo "$LOG_TAG update and install basic packages" && \
	apt-get -y update && \
	apt-get install -y locales software-properties-common build-essential && \
	locale-gen $LANG && \
	apt -y autoclean && \
	apt -y dist-upgrade

RUN echo "$LOG_TAG install tini related packages" && \
	apt-get install -y wget curl grep sed dpkg && \
	TINI_VERSION=`curl https://github.com/krallin/tini/releases/latest | grep -o "/v.*\"" | sed 's:^..\(.*\).$:\1:'` && \
	curl -L "https://github.com/krallin/tini/releases/download/v${TINI_VERSION}/tini_${TINI_VERSION}.deb" > tini.deb && \
	dpkg -i tini.deb && \
	rm tini.deb

ENV JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64
RUN echo "$LOG_TAG Install java8" && \
	apt-get -y update && \
	apt-get install -y openjdk-8-jdk && \
	rm -rf /var/lib/apt/lists/*

# should install conda first before numpy, matploylib since pip and python will be installed by conda
RUN echo "$LOG_TAG Install miniconda2 related packages" && \
	apt-get -y update && \
	apt-get install -y bzip2 ca-certificates \
	libglib2.0-0 libxext6 libsm6 libxrender1 \
	git mercurial subversion && \
	echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
	wget --quiet https://repo.continuum.io/miniconda/Miniconda2-4.2.12-Linux-x86_64.sh -O ~/miniconda.sh && \
	/bin/bash ~/miniconda.sh -b -p /opt/conda && \
	rm ~/miniconda.sh
ENV PATH /opt/conda/bin:$PATH

RUN echo "$LOG_TAG Install python related packages" && \
	apt-get -y update && \
	apt-get install -y python-dev python-pip && \
	apt-get install -y gfortran && \
	# numerical/algebra packages
	apt-get install -y libblas-dev libatlas-dev liblapack-dev && \
	# font, image for matplotlib
	apt-get install -y libpng-dev libfreetype6-dev libxft-dev && \
	# for tkinter
	apt-get install -y python-tk libxml2-dev libxslt-dev zlib1g-dev && \
	conda config --set always_yes yes --set changeps1 no && \
	conda update -q conda && \
	conda info -a && \
	conda config --add channels conda-forge && \
	conda install -q numpy=1.12.1 pandas=0.21.1 matplotlib=2.1.1 pandasql=0.7.3 ipython=5.4.1 jupyter_client=5.1.0 ipykernel=4.7.0 bokeh=0.12.10 && \
	pip install -q ggplot==0.11.5 grpcio==1.8.2 bkzep==0.4.0

RUN echo "$LOG_TAG Install R related packages" && \
	echo "deb http://cran.rstudio.com/bin/linux/ubuntu xenial/" | tee -a /etc/apt/sources.list && \
	gpg --keyserver keyserver.ubuntu.com --recv-key E084DAB9 && \
	gpg -a --export E084DAB9 | apt-key add - && \
	apt-get -y update && \
	apt-get -y install r-base r-base-dev && \
	R -e "install.packages('knitr', repos='http://cran.us.r-project.org')" && \
	R -e "install.packages('ggplot2', repos='http://cran.us.r-project.org')" && \
	R -e "install.packages('googleVis', repos='http://cran.us.r-project.org')" && \
	R -e "install.packages('data.table', repos='http://cran.us.r-project.org')" && \
	# for devtools, Rcpp
	apt-get -y install libcurl4-gnutls-dev libssl-dev && \
	R -e "install.packages('devtools', repos='http://cran.us.r-project.org')" && \
	R -e "install.packages('Rcpp', repos='http://cran.us.r-project.org')" && \
	Rscript -e "library('devtools'); library('Rcpp'); install_github('ramnathv/rCharts')"

RUN echo "$LOG_TAG Install requirements to build Zeppelin" && \
	curl -sL https://deb.nodesource.com/setup_10.x | bash - && \
	curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
	echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \	
	apt-get update && \
	apt-get -y install nodejs yarn git libfontconfig r-base-dev r-cran-evaluate && \
	wget http://www.eu.apache.org/dist/maven/maven-3/3.3.9/binaries/apache-maven-3.3.9-bin.tar.gz && \
	tar -zxf apache-maven-3.3.9-bin.tar.gz -C /usr/local/ && \
	ln -s /usr/local/apache-maven-3.3.9/bin/mvn /usr/local/bin/mvn && \
	npm config set strict-ssl false && \
	npm install -g bower &&\
	apt -y autoclean

# add zeppelin user and set home directory
# confirm node, nom and maven installation
RUN useradd -ms /bin/bash zeppelin
USER zeppelin
WORKDIR /home/zeppelin
RUN echo '{ "allow_root": true }' > ~/.bowerrc
RUN cat ~/.bowerrc

RUN export MAVEN_OPTS="-Xmx2g -XX:MaxPermSize=1024m"

RUN echo "$LOG_TAG Build Zeppelin $Z_VERSION" && \
	rm -rf zeppelin && \
	git clone https://github.com/multivacplatform/zeppelin && \
	cd zeppelin && \
	git checkout branch-0.8 && \
	./dev/change_scala_version.sh 2.11 && \	
	mvn -X clean package -DskipTests -Pbuild-distr -Dcheckstyle.skip=true -Pspark-2.4 -Pscala-2.11 && \
	mv zeppelin-distribution/target/zeppelin-${Z_VERSION}-SNAPSHOT/zeppelin-${Z_VERSION}-SNAPSHOT ${Z_HOME}

RUN pwd
RUN rm -rf ${Z_HOME}/zeppelin \
	&& rm -rf ~/.m2 \
	&& rm -rf /var/lib/apt/lists/* \
	&& rm -rf /root/.m2 \
	&& rm -rf /root/.npm \
	&& rm -rf /root/.cache/bower \
	&& rm -rf /tmp/*

EXPOSE 8080
EXPOSE 8081

ENTRYPOINT [ "/usr/bin/tini", "--" ]
WORKDIR ${Z_HOME}/zeppelin-${Z_VERSION}-SNAPSHOT
CMD ["bin/zeppelin.sh"]
