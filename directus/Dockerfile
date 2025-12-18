FROM directus/directus:11.12.0

ENV PORT=8080
EXPOSE 8080

# for extensions later on
# COPY ./extensions /directus/extensions

USER root

# copy schema 
COPY ./schema /directus/template/src/schema

COPY ./extensions /directus/extensions
# RUN chown -R node:node /directus/extensions
USER node
