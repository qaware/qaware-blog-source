FROM klakegg/hugo:0.73.0 AS hugo

ARG BASE_URL=http://localhost:1313/

COPY . /src
WORKDIR /src
RUN hugo --buildDrafts --minify --baseURL=$BASE_URL --destination=/target

# Build runtime image
FROM nginx:1.18.0-alpine
COPY --from=hugo /target /usr/share/nginx/html
