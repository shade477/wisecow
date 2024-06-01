# Use the official Debian image as the base image
FROM debian:latest

# Install necessary packages
RUN apt-get update && \
    apt-get install -y \
    git \
    cowsay \
    fortune \
    netcat-openbsd

# Set the working directory
ENV PATH="/usr/games:${PATH}"
WORKDIR /app

COPY . .

# Make the server script executable
RUN chmod +x /app/wisecow.sh

# Expose the port the server will run on
EXPOSE 4499

CMD [ "./wisecow/wisecow.sh" ]
