###############
# Build Stage #
###############
FROM razonyang/hugo:exts as builder
# Base URL
ARG HUGO_BASEURL=gcc-ensibs.fr
ENV HUGO_BASEURL=${HUGO_BASEURL}
# Build site
COPY . /src
RUN hugo 
# Set the fallback 404 page if defaultContentLanguageInSubdir is enabled, please replace the `en` with your default language code.
# RUN cp ./public/en/404.html ./public/404.html

###############
# Final Stage #
###############
FROM nginx:alpine
# Copy static site
COPY --from=builder /src/public /usr/share/nginx/html

# Copy nginx configuration file
COPY ./default.conf /etc/nginx/conf.d/default.conf

# Expose port 80
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]