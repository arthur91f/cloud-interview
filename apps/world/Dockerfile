FROM php:7.2.34-apache AS builder
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" && \
    php -r "if (hash_file('sha384', 'composer-setup.php') === '906a84df04cea2aa72f40b5f787e49f22d4c2f19492ac310e8cba5b96ac8b64115ac402c8cd292b8a03482574915d1a8') \ 
        { echo 'Installer verified'; } \
    else \
        { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
    php composer-setup.php && \
    php -r "unlink('composer-setup.php');" && \
    mv composer.phar /usr/local/bin/composer && \
    apt-get update && \
    apt-get install -y git
COPY . /opt/world
WORKDIR /opt/world
RUN composer install

FROM builder AS runner
WORKDIR /opt/world
COPY --from=builder /opt/world/composer.json ./composer.json
COPY --from=builder /opt/world/composer.lock ./composer.lock
COPY --from=builder /opt/world/public ./public
CMD ["composer", "run", "dev:start"]
