ARG BASE_IMAGE_VER_ARG=22.4-alpine3.20
ARG BUILD_PLATFORM_ARG=linux/amd64

ARG NODE_ENV_ARG={NODE_ENV:-development}
ARG NODE_PM_ARG=pnpm

ARG INTERNAL_HOST_ARG=${DOCKER_INTERNAL_HOST:-0.0.0.0}
ARG INTERNAL_PORT_ARG=${DOCKER_INTERNAL_PORT:-4200}

ARG WORKDIR_PATH_ARG=/app

#
# ---- Base Image ----
# Used to set up defaults
#
FROM --platform=${BUILD_PLATFORM_ARG} node:${BASE_IMAGE_VER_ARG} AS base

ARG WORKDIR_PATH_ARG

ARG NODE_PM_ARG
ARG NODE_ENV_ARG

ARG INTERNAL_HOST_ARG
ARG INTERNAL_PORT_ARG

# see https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

WORKDIR ${WORKDIR_PATH_ARG}

ENV NODE_PM=${NODE_PM_ARG}
ENV NODE_ENV=${NODE_ENV_ARG}

RUN npm i -g ${NODE_PM}

ENV DOCKER_INTERNAL_HOST=${INTERNAL_HOST_ARG}
ENV DOCKER_INTERNAL_PORT=${INTERNAL_PORT_ARG}

COPY ./ ./

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

ARG NODE_MODULES_PROD_PATH_ARG=./node_modules_prod/
ARG NODE_MODULES_DEV_PATH_ARG=./node_modules_dev/

#
# ---- Dependencies Image ----
# Used to hold cached node_modules and prod_modules separated
#
FROM base AS deps

ARG WORKDIR_PATH_ARG

ARG NODE_MODULES_PROD_PATH_ARG
ARG NODE_MODULES_DEV_PATH_ARG

RUN ${NODE_PM} i -P --modules-dir ${NODE_MODULES_PROD_PATH_ARG}
RUN ${NODE_PM} i


# TODO: for now dev packages cannot be installed separately due esbuild postinstall script
# fix postbuild problem?
#
# RUN ${NODE_PM} i -D --modules-dir ${WORKDIR_PATH_ARG}/${NODE_MODULES_DEV_PATH_ARG} --strict-peer-dependencies

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------

#
# ---- Development Image ----
# Used in development
#
FROM base AS dev

ARG WORKDIR_PATH_ARG

COPY --from=deps /app/node_modules/ ./node_modules/

EXPOSE ${DOCKER_INTERNAL_PORT}

CMD ${NODE_PM} start -c ${NODE_ENV} --host ${DOCKER_INTERNAL_HOST} --hmr --verbose

#
# ---- Build Image ----
# Use for production's build
#
FROM base AS build

ENV NODE_ENV=${NODE_ENV:-production}

COPY --from=deps /app/node_modules/ ./node_modules/

RUN ${NODE_PM} build -c ${NODE_ENV} --aot -

#
# ---- Preview Image ----
# Use for production's preview
#
FROM base AS preview

ENV NODE_ENV=${NODE_ENV:-production}

COPY --from=build app/dist/ ./dist/
# TODO: use node_modules_prod, for now is complaining about vite.js
COPY --from=deps app/node_modules/ ./node_modules/

CMD ${NODE_PM} preview --port ${DOCKER_INTERNAL_PORT} --mode ${NODE_ENV} --host ${DOCKER_INTERNAL_HOST}

#
# ---- Production Image ----
# Use for production
#
FROM nginx:1 as prod

COPY --from=build /app/dist/ /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/conf.d/default.conf
