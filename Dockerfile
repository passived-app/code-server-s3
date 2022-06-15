FROM codercom/code-server

ARG PWD=/home/coder/project

ENV PWD=${PWD}

RUN sudo apt-get update
RUN sudo apt-get install python3-pip -y
RUN sudo apt -y install automake nano autotools-dev gettext-base fuse g++ git libcurl4-gnutls-dev libfuse-dev libssl-dev libxml2-dev make pkg-config

RUN git clone https://github.com/s3fs-fuse/s3fs-fuse.git

RUN cd s3fs-fuse && sed -i 's/MAX_MULTIPART_CNT         = 10 /MAX_MULTIPART_CNT         = 1 /' src/fdcache_entity.cpp
RUN cd s3fs-fuse && sudo ./autogen.sh && sudo ./configure && sudo make && sudo make install

RUN sudo cp s3fs-fuse/src/s3fs /usr/local/bin/s3fs

RUN sudo rm -rf s3fs-fuse
RUN sudo echo "user_allow_other" >> /etc/fuse.conf

RUN mkdir -p ${PWD}/script

COPY run_docker.sh run_docker.sh
RUN chmod +x run_docker.sh

RUN sudo chmod 777 ${PWD}

USER coder

WORKDIR ${PWD}

RUN code-server --list-extensions
RUN code-server --install-extension ms-python.python

ENTRYPOINT ["./run_docker.sh"]