FROM directus/directus:11.12.0

ENV PORT=8055
EXPOSE 8055

USER root
RUN corepack enable
RUN npm i -g @directus/extensions-sdk



# Build custom extensions
# Build-time arg (comes from docker-compose .env)
ARG ENVIRONMENT=production
ENV ENVIRONMENT=${ENVIRONMENT}

# Build custom extensions ONLY in develop
RUN set -eux; \
  if [ "${ENVIRONMENT}" = "develop" ]; then \
    echo "=> ENVIRONMENT=develop, building custom extensions"; \
    for ext in /directus/extensions/*; do \
      [ -d "$ext" ] || continue; \
      [ -f "$ext/package.json" ] || continue; \
      echo "-> Building $(basename "$ext")"; \
      cd "$ext"; \
      if [ -f package-lock.json ]; then \
        npm ci --include=dev || npm i --include=dev; \
      else \
        npm i --include=dev; \
      fi; \
      npm run build; \
    done; \
  else \
    echo "=> ENVIRONMENT=${ENVIRONMENT}, skipping extensions build"; \
  fi


# Copy extensions source into the image
COPY ./extensions /directus/extensions

# Copy entrypoint last
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

USER node
# ENTRYPOINT ["/docker-entrypoint.sh"]
