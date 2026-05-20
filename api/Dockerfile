FROM php:8.2-apache

# Instala as extensões PDO e MySQL necessárias para o PHP conversar com o banco
RUN docker-php-ext-install pdo pdo_mysql

# Habilita o mod_rewrite do Apache (essencial se for usar frameworks ou rotas amigáveis)
RUN a2enmod rewrite

# Ajusta as permissões para a pasta padrão do Apache
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80