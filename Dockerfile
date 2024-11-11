# For instructions on how to build locally see README.md

FROM hugomods/hugo:exts-0.136.5 AS hugo

ARG BASE_URL=http://localhost:1313/

COPY . /src
WORKDIR /src
RUN hugo version \
    && hugo --environment staging --baseURL=$BASE_URL --destination=/target

# Build runtime image
FROM nginx:1.27-alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY htpasswd /etc/nginx/conf.d/htpasswd
COPY --from=hugo /target /usr/share/nginx/html
