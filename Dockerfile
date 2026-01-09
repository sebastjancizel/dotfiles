FROM ubuntu:latest

RUN apt update && apt install -y curl git zsh sudo build-essential

RUN useradd -m -s /bin/zsh dev && \
    echo "dev ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER dev
WORKDIR /home/dev

COPY --chown=dev:dev . /home/dev/dotfiles

RUN cd /home/dev/dotfiles && ./install.sh

ENTRYPOINT ["/bin/zsh"]
