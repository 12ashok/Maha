# Stage 1: Build the Spring Boot app
FROM eclipse-temurin:21-jdk AS builder
WORKDIR /app
COPY target/maha-0.0.1-SNAPSHOT.jar app.jar

# Stage 2: Runtime with Apache2 + Spring Boot
FROM ubuntu:22.04

# Install Apache2 and Java
RUN apt-get update && \
    apt-get install -y apache2 openjdk-21-jre && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Enable Apache proxy modules
RUN a2enmod proxy proxy_http

# Configure Apache to proxy requests to Spring Boot
RUN echo '<VirtualHost *:80>\n\
    ProxyPreserveHost On\n\
    ProxyPass / http://localhost:8080/\n\
    ProxyPassReverse / http://localhost:8080/\n\
</VirtualHost>' > /etc/apache2/sites-available/000-default.conf

WORKDIR /app
COPY --from=builder /app/app.jar app.jar

# Expose Apache port
EXPOSE 80

# Start both services: Spring Boot + Apache
CMD java -jar /app/app.jar & apache2ctl -D FOREGROUND
