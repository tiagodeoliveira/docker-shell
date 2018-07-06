FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
ENV TERM=xterm-256color

# Install a bunch of "necessary" things
RUN apt-get update && \
	apt-get install -y software-properties-common && \
  add-apt-repository ppa:neovim-ppa/stable && \
  add-apt-repository ppa:zanchey/asciinema && \
  apt-get install -y \
			locales \
      mosh \
      tmux  \
      neovim  \
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
      mplayer \
      caca-utils \
      pylint

# Install erlang
ENV OTP_VERSION 20.2.2
ENV REBAR_VERSION 2.6.4
ENV REBAR3_VERSION 3.4.7
ENV OTP_DOWNLOAD_URL "https://github.com/erlang/otp/archive/OTP-${OTP_VERSION}.tar.gz" 
ENV OTP_DOWNLOAD_SHA256 "7614a06964fc5022ea4922603ca4bf1d2cc241f9bd6b7321314f510fd74c7304" 
RUN curl -fSL -o otp-src.tar.gz "$OTP_DOWNLOAD_URL" && \  
  echo "$OTP_DOWNLOAD_SHA256  otp-src.tar.gz" | sha256sum -c - && \  
  export ERL_TOP="/usr/src/otp_src_${OTP_VERSION%%@*}" && \  
  mkdir -vp $ERL_TOP && \    
  tar -xzf otp-src.tar.gz -C $ERL_TOP --strip-components=1 && \  
  rm otp-src.tar.gz && \ 
  ( cd $ERL_TOP \  
    && ./otp_build autoconf \ 
    && gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)" \  
    && ./configure --build="$gnuArch" \ 
    && make -j$(nproc) \  
    && make install ) \ 
  && find /usr/local -name examples | xargs rm -rf \  
  && rm -rf $ERL_TOP /var/lib/apt/lists/*

# Config timezone
ENV TZ Europe/Berlin
RUN echo $TZ > /etc/timezone && \
    rm /etc/localtime && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata

# Install neovim and some other python stuff
RUN pip install --upgrade pip mock neovim grip && \
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
  apt-add-repository 'deb http://apt.kubernetes.io/ kubernetes-$(lsb_release -cs) main' && \
  apt-get install kubectl

# Install azure-client
RUN curl -s https://packages.microsoft.com/keys/microsoft.asc | apt-key add && \
  apt-add-repository 'deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main' && \
	apt-get install azure-cli

# Install terraform
ENV TERRAFORM_VERSION 0.11.7
RUN wget --quiet https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip && \
	unzip terraform* && \
	mv terraform /usr/bin && \
	rm -rf terraform*

# Install nvm
ENV NVM_VERSION 0.33.8
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v${NVM_VERSION}/install.sh | bash
RUN export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh" && nvm install 6.10

# Config vim
ADD init.vim /root/.config/nvim/init.vim
RUN nvim +PlugInstall +qall +silent

# Config zsh
ADD zshrc /root/.zshrc
RUN chsh -s /usr/bin/zsh

# Add additional configs
ADD tmux.conf /root/.tmux.conf
ADD lemonade.toml /root/.config/lemonade.toml

WORKDIR /projects

VOLUME /projects
VOLUME /root
VOLUME /keys

CMD ["tmux"]
