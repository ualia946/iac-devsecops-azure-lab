# Usamos una imagen oficial de PHP con el servidor Apache
FROM php:7.4-apache

# Actualizamos la lista de paquetes e instalamos la dependencia necesaria (unzip)
RUN apt-get update && apt-get install -y unzip

# Instalamos las extensiones de PHP que DVWA necesita (mysqli Y pdo_mysql)
RUN docker-php-ext-install mysqli pdo_mysql && docker-php-ext-enable mysqli

# Establecemos el directorio de trabajo
WORKDIR /var/www/html

# Copiamos el archivo zip local al contenedor
COPY dvwa.zip .

# Descomprimimos el zip y limpiamos
RUN unzip dvwa.zip && \
    mv DVWA-master/* . && \
    rm -rf DVWA-master dvwa.zip

# Copiamos la configuración por defecto para que el archivo exista
RUN cp config/config.inc.php.dist config/config.inc.php

# Damos los permisos correctos a la carpeta para que Apache pueda escribir en ella
RUN chown -R www-data:www-data /var/www/html