FROM klakegg/hugo:0.91.2-ext-ubuntu AS hugo

ARG BASE_URL=http://localhost:1313/

COPY . /src
WORKDIR /src
RUN hugo --buildDrafts --baseURL=$BASE_URL --destination=/target --cleanDestinationDir

# Build runtime image
FROM nginx:1.21.1-alpine
COPY default.conf /etc/nginx/conf.d/default.conf
COPY htpasswd /etc/nginx/conf.d/htpasswd
COPY --from=hugo /target /usr/share/nginx/html
