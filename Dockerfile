ARG DOCKER_REPO

# vue cli 3
FROM alpine:3.8 as vue-cli-3

RUN \
  apk add npm --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/main && \
  npm i yarn -g && \
  # work directories
  mkdir /code && \
  # global packages
  yarn global add @vue/cli && \
  echo '### 1.Finish ###'


WORKDIR /code

# vue cli 3 development
FROM ${DOCKER_REPO}vue-cli-3 as vue-cli-3-dev

COPY ./src/.npmrc /root/
COPY ./src/.yarnrc /root/

RUN \
  apk add nginx git --update --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/main && \
  echo '### 2.Finish ###'

COPY ./src/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443 8080 8000
ENTRYPOINT ["/bin/sh"]

# static as service
FROM alpine:3.8 as static-service

RUN \
  apk add nginx --update --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/main && \
  mkdir /srv/web-app && \
  echo '### 3.Finish ###'

COPY ./src/nginx.conf /etc/nginx/nginx.conf
EXPOSE 80 81
CMD ["nginx", "-g", "daemon off;"]


# ionic v3
FROM alpine:3.8 as ionic-cli-3
RUN \
  apk add npm --update --repository http://dl-cdn.alpinelinux.org/alpine/edge/main && \
  npm i -g ionic@3.20.1 && \
  mkdir /code && \
  echo '### 1. Ionic env Finished!'

WORKDIR /code

# ionic v3 dev
FROM ${DOCKER_REPO}ionic-cli-3 as ionic-cli-3-dev

COPY ./src/.npmrc /root/
COPY ./src/.yarnrc /root/

RUN \
  apk add curl --update --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/main && \
  npm i -g cordova && \
  echo '### 2.Finish ###'

# COPY ./src/nginx.conf /etc/nginx/nginx.conf

EXPOSE 8100 35729 53703
ENTRYPOINT ["/bin/sh"]

# wp4 static dev
FROM ${DOCKER_REPO}vue-cli-3 as wp4-static-dev

COPY ./src/.npmrc /root/
COPY ./src/.yarnrc /root/

RUN \
  apk add nginx git --update --repository http://dl-cdn.alpinelinux.org/alpine/v3.8/main && \
  echo '### 2.Finish ###'

COPY ./src/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443
ENTRYPOINT ["/bin/sh"]
