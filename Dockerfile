FROM node:alpine
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
COPY pnpm-lock.yaml /usr/src/app/
RUN npm install
COPY ./src /usr/src/app/src
RUN npm run build
EXPOSE 7373
CMD npx http-server ./dist -d false -g -b -p 7373