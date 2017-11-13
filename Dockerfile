FROM ubuntu:latest

ENV DEBIAN_FRONTEND noninteractive
ENV LANG en_US.UTF-8
ENV GOVERSION 1.6.2
ENV GOROOT /opt/go
ENV GOPATH /root/.go

RUN apt-get update
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:neovim-ppa/stable && apt-get update
RUN apt-get install -y tmux neovim python python-dev python-pip python3-dev python3-pip curl git zsh wget language-pack-en zip jq ruby openjdk-8-jdk gradle snappy
RUN pip install --upgrade mock neovim 

RUN update-alternatives --install /usr/bin/vi vi /usr/bin/nvim 60
RUN update-alternatives --config vi
RUN update-alternatives --install /usr/bin/vim vim /usr/bin/nvim 60
RUN update-alternatives --config vim
RUN update-alternatives --install /usr/bin/editor editor /usr/bin/nvim 60
RUN update-alternatives --config editor

RUN curl -fLo /root/.config/nvim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
RUN wget https://github.com/robbyrussell/oh-my-zsh/raw/master/tools/install.sh -O - | zsh || true
RUN git clone https://github.com/powerline/fonts.git --depth=1 && cd fonts && ./install.sh && cd .. && rm -rf fonts
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.6/install.sh | bash
RUN wget https://releases.hashicorp.com/terraform/0.10.3/terraform_0.10.3_linux_386.zip && unzip terraform* && mv terraform /usr/bin
RUN cd /opt && wget https://storage.googleapis.com/golang/go${GOVERSION}.linux-amd64.tar.gz && \
    tar zxf go${GOVERSION}.linux-amd64.tar.gz && rm go${GOVERSION}.linux-amd64.tar.gz && \
    ln -s /opt/go/bin/go /usr/bin/ && \
    mkdir $GOPATH
RUN cd /tmp && wget https://github.com/pocke/lemonade/releases/download/v1.1.1/lemonade_linux_amd64.tar.gz && tar -zxvf lemonade_linux_amd64.tar.gz && mv lemonade /usr/bin

RUN export NVM_DIR="$HOME/.nvm" && \. "$NVM_DIR/nvm.sh" && nvm install 6.10

ADD init.vim /root/.config/nvim/init.vim
ADD zshrc /root/.zshrc
RUN nvim +PlugInstall +qall +silent
RUN chsh -s /usr/bin/zsh

ADD tmux.conf /root/.tmux.conf
ADD lemonade.toml /root/.config/lemonade.toml
VOLUME /projects

WORKDIR /projects

CMD ["/usr/bin/zsh"]
