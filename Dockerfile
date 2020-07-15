FROM python:3.7-alpine3.12

# set label
LABEL maintainer="NG6"

ENV TZ=Asia/Shanghai TASK=1d PUID=1026 PGID=100

# install subfinder
RUN apk update && apk add --no-cache unrar tzdata bash curl \
&& pip install subfinder

# set version for s6 overlay
ARG OVERLAY_VERSION="v2.0.0.1"
ARG OVERLAY_ARCH="amd64"

RUN echo "**** add s6 overlay ****" && \
 curl -o \
 /tmp/s6-overlay.tar.gz -L \
	"https://github.com/just-containers/s6-overlay/releases/download/${OVERLAY_VERSION}/s6-overlay-${OVERLAY_ARCH}.tar.gz" && \
 tar xfz \
	/tmp/s6-overlay.tar.gz -C / && \
 echo "**** create abc user and make our folders ****" && \
 groupmod -g 1000 users && \
 useradd -u 911 -U -d /config -s /bin/false abc && \
 usermod -G users abc && \
 mv /usr/bin/with-contenv /usr/bin/with-contenvb && \
 echo "**** cleanup ****" && \
 apk del --purge \
	curl && \
 rm -rf \
	/tmp/*

# copy local files
COPY root/ /

# volumes
VOLUME /config	/media
