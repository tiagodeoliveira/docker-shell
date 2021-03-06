FROM ubuntu:bionic

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM=xterm-256color
ENV EDITOR /usr/bin/vim

# Install a bunch of "necessary" things
RUN apt-get update && \
	apt-get install -y software-properties-common && \
  add-apt-repository ppa:neovim-ppa/stable && \
  add-apt-repository ppa:alessandro-strada/ppa && \
  add-apt-repository ppa:zanchey/asciinema && \
  apt-get install -y \
      locales \
      mosh \
      tmux  \
      neovim  \
      nnn \
      python \
      python-dev \
      python-pip \
      python3-dev \
      python3-pip \
      curl \
      git \
      zsh \
      wget \
      language-pack-en \
      zip \
      jq \
      ruby \
      openjdk-8-jdk \
      ash \
      markdown \
      lynx \
      xdotool \
      maven \
      mercurial \
      libncurses5-dev \
      autoconf \
      asciinema \
      iputils-ping \
      silversearcher-ag \
      pylint \
      erlang \ 
      docker.io \
      docker-compose \
      ngrep \
      linux-tools-4.15.0.20 \
      valgrind \
      google-drive-ocamlfuse \
      openjfx \
      tidy \
      moreutils \ 
      exiftool \ 
      atool \ 
      patool \ 
      vlock

# Config timezone
ENV TZ Europe/Berlin
RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install neovim and some other python stuff
RUN pip install --upgrade pip mock neovim grip azure-cli && \
  update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60 && \
  update-alternatives --config vi && \
  update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60 && \
  update-alternatives --config vim && \
  update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60 && \
  update-alternatives --config editor

# Install shell plugins
RUN wget --quiet https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | bash
RUN curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && cd .. && rm -rf fonts

# Install go
ENV GOVERSION 1.10.2
ENV GOROOT /opt/go
ENV GOPATH /root/.go
RUN cd /opt && wget --quiet https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
  tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
  ln -s /opt/go/bin/go /usr/bin/ && \
  mkdir $GOPATH

# Install clipboard tool
RUN cd /tmp && \ 
	wget --quiet https://github.com/pocke/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz && \
	tar -zxvf lemonade_linux_amd64.tar.gz && \
	mv lemonade /usr/bin && \
	rm -rf lemonade_linux_amd64.tar.gz

# Install kubectl
RUN curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add && \
  apt-add-repository "deb http://apt.kubernetes.io/ kubernetes-xenial main" && \
  apt-get install kubectl

# Install terraform
ENV TERRAFORM_VERSION 0.11.7
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	unzip terraform* && \
	mv terraform /usr/bin && \
	rm -rf terraform*

# Install nvm
ENV NVM_VERSION 0.33.8
ENV NVM_DIR /root/.nvm
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | bash
RUN \. "$NVM_DIR/nvm.sh" && nvm install 10

# Install helm
ENV HELM_VERSION v2.9.1
RUN wget --quiet https://storage.googleapis.com/kubernetes-helm/helm-${HELM_VERSION}-linux-amd64.tar.gz && \
	tar -zxvf helm* && \
	mv linux-amd64/helm /usr/local/bin && \
	rm -rf linux-adm64* && rm -rf helm*

# Install bat
RUN curl -L  https://github.com/sharkdp/bat/releases/download/v0.7.0/bat_0.7.0_amd64.deb -o bat.deb && \
  dpkg -i bat.deb && \
  rm -rf bat.deb

# Config vim
ADD init.vim /root/.config/nvim/init.vim
RUN nvim +PlugInstall +qall +silent

# Config zsh
ADD zshrc /root/.zshrc
RUN chsh -s /usr/bin/zsh

# Add additional configs
ADD tmux.conf /root/.tmux.conf
ADD lemonade.toml /root/.config/lemonade.toml

WORKDIR /src

VOLUME /src
VOLUME /root
VOLUME /keys

CMD ["tmux"]
