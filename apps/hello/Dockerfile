FROM node:16.11.1 AS builder
COPY . /opt/hello
WORKDIR /opt/hello
RUN yarn install

FROM node:16.11.1 AS runner
WORKDIR /opt/hello
COPY --from=builder /opt/hello/node_modules ./node_modules
COPY --from=builder /opt/hello/package.json ./package.json
COPY --from=builder /opt/hello/src ./src
CMD ["yarn", "run", "start"]
