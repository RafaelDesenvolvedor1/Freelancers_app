FROM php:8.2-apache

# Instala as extensões PDO e MySQL necessárias para o PHP conversar com o banco
RUN docker-php-ext-install pdo pdo_mysql

# Habilita o mod_rewrite do Apache (essencial se for usar frameworks ou rotas amigáveis)
RUN a2enmod rewrite

# Permite que .htaccess funcione no diretório /var/www/html
RUN sed -i 's/AllowOverride None/AllowOverride All/g' /etc/apache2/apache2.conf

# Ajusta as permissões para a pasta padrão do Apache
RUN chown -R www-data:www-data /var/www/html

EXPOSE 80