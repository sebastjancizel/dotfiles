# Use the latest Ubuntu image as the base
FROM ubuntu:latest

# Install required packages and apt-utils
RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y curl git zsh sudo

# Create a new user "test" with sudo privileges
RUN useradd -m -s /bin/zsh test && \
    echo "test:test" | chpasswd && \
    usermod -aG sudo test

# Set the user and home directory
USER test
WORKDIR /home/test

COPY . .

# Set the entrypoint to start an interactive Zsh session
ENTRYPOINT ["/bin/zsh"]
