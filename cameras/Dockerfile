FROM alpine:3.22.4

# Environment variables.
ENV HOME_DIR=/home/server
ENV BIN_DIR=${HOME_DIR}/bin
ENV ETC_DIR=${HOME_DIR}/etc

# Required packages.
RUN apk update && \
    apk add --no-cache bash python3

# Directory structure.
RUN mkdir -p ${BIN_DIR} ${ETC_DIR}

# Required files.
ADD bin/requirements.txt ${BIN_DIR}/
ADD bin/install.sh ${BIN_DIR}/
ADD bin/start.sh ${BIN_DIR}/

# Installation script.
RUN cd ${BIN_DIR} && \
    ./install.sh && \
    ln -s ${BIN_DIR}/start.sh /entrypoint.sh

ADD etc/config.ini.template ${ETC_DIR}/config.ini
ADD bin/server.py ${BIN_DIR}/

WORKDIR ${BIN_DIR}

ENTRYPOINT [ "/entrypoint.sh" ]