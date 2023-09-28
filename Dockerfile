# Use a lightweight web server image
FROM nginx:alpine

# Remove the default Nginx index.html file
RUN rm -rf /usr/share/nginx/html/*

# Copy your web application files from the "app" folder to the Nginx HTML folder
COPY ./app /usr/share/nginx/html

# Expose port 80 for web traffic
EXPOSE 80