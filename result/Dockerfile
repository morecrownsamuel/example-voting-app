
# Stage 1: Install application dependencies
FROM node:22-bookworm-slim@sha256:de170b39439eb0e5a3444ad7d60b015614a381e10fecae2e30ec9e735122f38d AS build

WORKDIR /usr/local/app

COPY package*.json ./

RUN npm ci --omit=dev && npm cache clean --force

COPY . .

# Stage 2: Runtime image without npm
FROM node:22-bookworm-slim@sha256:de170b39439eb0e5a3444ad7d60b015614a381e10fecae2e30ec9e735122f38d AS runtime

WORKDIR /usr/local/app

# Remove npm and its command links from the runtime image
RUN rm -rf /usr/local/lib/node_modules/npm \
    /usr/local/bin/npm \
    /usr/local/bin/npx

COPY --from=build --chown=node:node /usr/local/app /usr/local/app
COPY --from=build --chown=node:node /usr/local/app/node_modules /node_modules

ENV PORT=80

EXPOSE 80

USER node

CMD ["node", "server.js"]
