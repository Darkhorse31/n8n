# Use official n8n image
FROM n8nio/n8n:latest

# Expose the n8n port
EXPOSE 5678

# Set the working directory
WORKDIR /home/node

# The base image already has the entrypoint configured
# No additional configuration needed - this just wraps the official image
