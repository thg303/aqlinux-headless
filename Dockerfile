FROM node:12.10-stretch-slim
MAINTAINER Ali Ghanavatian "ghanavatian.ali@gmail.com"

RUN for i in $(seq 1 8); do mkdir -p "/usr/share/man/man${i}"; done

RUN apt update && apt install -y nano postgresql-client

ENV NODE_ROOT /src

RUN mkdir $NODE_ROOT
WORKDIR $NODE_ROOT

# RUN npm i -g strapi@3.0.0-beta.18.7

COPY yarn.lock yarn.lock
COPY package.json package.json

RUN yarn
COPY . $NODE_ROOT

EXPOSE 1337

ARG ENV
ENV NODE_ENV ${ENV}

ARG START_WITH
ENV START ${START_WITH}

VOLUME ["/src/api", "/src/public", "src/extensions"]


# RUN yarn strapi install graphql

RUN NODE_ENV=$NODE_ENV yarn build # needed for production

ENTRYPOINT yarn "$START"
# ENTRYPOINT tail -f /etc/issue
