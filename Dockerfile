# Dockerfile
FROM node:alpine

# adding required file
RUN apk add --no-cache make gcc g++ curl py-pip pkgconfig pixman-dev cairo-dev pango-dev libjpeg-turbo-dev giflib-dev

# create destination directory
RUN mkdir -p /usr/src/nuxt-app
WORKDIR /usr/src/nuxt-app

# update and install dependency
RUN apk update && apk upgrade
RUN apk add git

# copy the app, note .dockerignore
COPY . /usr/src/nuxt-app/
RUN npm install
RUN npm run build

EXPOSE 3000

ENV NUXT_HOST=0.0.0.0
ENV NUXT_PORT=3000

CMD [ "npm", "start" ]