FROM ubuntu:latest

# Create a new user "test"
RUN useradd -m -s /bin/zsh test

# Set the home directory for the "test" user
RUN usermod -d /guests/test test

# Install basic utilities
RUN apt-get update && \
    apt-get install -y git curl vim tmux sudo tree

# Install fd, rg, fzf, ag (silver surfer)
RUN apt-get install -y fd-find ripgrep silversearcher-ag bat

# Create a symlink to make bat accessible with the bat command
RUN ln -s /usr/bin/batcat /usr/bin/bat

# Install zsh and oh-my-zsh
RUN apt-get install -y zsh

# Set zsh as the default shell
SHELL ["/bin/zsh", "-c"]

# Set the user and home directory
USER test
WORKDIR /guests/test

# Install Oh My Zsh
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

# Export ZSH environment variable
ENV ZSH="/guests/test/.oh-my-zsh"

# Install fzf
RUN git clone --depth 1 https://github.com/junegunn/fzf.git /guests/test/.fzf && /guests/test/.fzf/install --all

# Copy local .zshrc to the home directory of the "test" user
COPY .zshrc /guests/test/.zshrc
COPY .tmux.conf /guests/test/.tmux.conf

# Install zsh plugins
RUN git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$ZSH/custom}/themes/powerlevel10k
RUN git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-$ZSH/custom}/plugins/zsh-autosuggestions
RUN git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
RUN git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
RUN git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab

CMD ["/bin/zsh"]

