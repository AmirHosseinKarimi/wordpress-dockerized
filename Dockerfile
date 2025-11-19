FROM wordpress:php8.4-apache

# PHP configuration
COPY custom.ini $PHP_INI_DIR/conf.d/

# Install required packages
RUN apt-get update && apt-get install -y \
  curl \
  less \
  bash-completion \
  && rm -rf /var/lib/apt/lists/*

# Install the PHP extension installer script
ADD --chmod=0755 https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

# Install the ionCube Loader extension
RUN install-php-extensions ioncube_loader

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
  chmod +x wp-cli.phar && \
  mv wp-cli.phar /usr/local/bin/wp

# Install bash completion for WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/wp-cli/v2.10.0/utils/wp-completion.bash && \
  mkdir -p /etc/bash_completion.d && \
  mv wp-completion.bash /etc/bash_completion.d/wp && \
  chmod +x /etc/bash_completion.d/wp

# Enable bash completion in .bashrc for www-data user
RUN echo 'if [ -f /etc/bash_completion ]; then' >> /var/www/.bashrc && \
  echo '  . /etc/bash_completion' >> /var/www/.bashrc && \
  echo 'fi' >> /var/www/.bashrc && \
  chown www-data:www-data /var/www/.bashrc
