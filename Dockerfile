FROM node:current-alpine3.16 as build-stage
WORKDIR /app
RUN npm install -g pnpm
COPY pnpm-lock.yaml ./
RUN --mount=type=cache,id=pnpm-store,target=/root/.pnpm-store\
      pnpm fetch
COPY . ./
RUN --mount=type=cache,id=pnpm-store,target=/root/.pnpm-store\
     pnpm -r install --frozen-lockfile --offline
RUN pnpm run build

FROM node:current-alpine3.16 as  production-stage
COPY --from=build-stage /app/dist /app/dist
EXPOSE 7373
CMD npx http-server /app/dist -d false -g -b -p 7373