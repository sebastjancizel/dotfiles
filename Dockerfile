# Use the latest Ubuntu image as the base
FROM ubuntu:latest

# Install required packages and apt-utils
RUN apt update && \
    apt install -y apt-utils && \
    apt install -y curl git zsh sudo

# Create a new user "test" with sudo privileges
RUN useradd -m -s /bin/zsh test && \
    echo "test:test" | chpasswd && \
    usermod -aG sudo test

# Set the user and home directory
USER test
WORKDIR /home/test

RUN git clone https://github.com/sebastjancizel/dotfiles.git

# Set the entrypoint to start an interactive Zsh session
ENTRYPOINT ["/bin/zsh"]
