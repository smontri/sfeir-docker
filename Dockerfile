# syntax=docker/dockerfile:1

FROM demonstrationorg/dhi-node:24.10.0-dev AS build-stage

ENV NODE_ENV=build
WORKDIR /usr/src/app
RUN --mount=type=bind,source=package.json,target=package.json \
    --mount=type=bind,source=package-lock.json,target=package-lock.json \
    --mount=type=cache,target=/root/.npm \
    npm ci --omit=dev

FROM demonstrationorg/dhi-node:24.10 AS runtime-stage

ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY --from=build-stage /usr/src/app/node_modules ./node_modules
COPY src ./src
EXPOSE 3000
CMD ["src/index.js"]
