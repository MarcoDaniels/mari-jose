FROM node:current-alpine3.23 AS builder

COPY . .

RUN yarn install --frozen-lockfile
RUN yarn build:elm

FROM nginx:alpine AS runner

COPY --from=builder /dist /usr/share/nginx/html