FROM ubuntu:latest  

# Install Apache2
RUN apt-get update && \
    apt-get install -y apache2 && \
    apt-get clean && rm -rf /var/lib/apt/lists/*  

# Set working directory
WORKDIR /var/www/html  

# Copy project files to the container
COPY . /var/www/html  

# Expose port 80 for web traffic
EXPOSE 80  

# Start Apache in the foreground to keep the container running
CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]
