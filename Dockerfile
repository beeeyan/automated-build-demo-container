FROM ubuntu:18.04
LABEL maintainer beeeeyan
#環境変数を設定
ENV DEBIAN_FRONTEND=noninteractive
ENV USER beeeeyan
ENV HOME /home/${USER}
ENV SHELL /bin/bash
ENV PW password

# 種々インストール
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim \
    sudo \
    locales \
    build-essential \
    ca-certificates \
    curl \
    file \
    git && \
    # 一般ユーザーアカウント追加
    useradd -m ${USER} && \
    # 一般ユーザーにsudo権限を付与
    gpasswd -a ${USER} sudo && \
    # 一般ユーザーのパスワードを設定
    echo "${USER}:${PW}" | chpasswd && \
    # ログインシェルを指定
    sed -i.bak -r s#${HOME}:\(.+\)#${HOME}:${SHELL}# /etc/passwd && \
    #　localの設定
    locale-gen en_US.UTF-8 && \
    #　linuxbrewの「Alternative Installation」を実行
    git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew && \
    mkdir /home/linuxbrew/.linuxbrew/bin && \
    ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin && \
    eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv) && \
    #　一度、brew doctorを実行
    brew doctor

# コマンドを実行するUSERを変更
USER ${USER}
# 作業ディレクトリを指定
WORKDIR ${HOME}

# Linuxbrew関連のフォルダ作成
RUN echo ${PW} | sudo -S mkdir -p /home/linuxbrew/.linuxbrew/etc \
    /home/linuxbrew/.linuxbrew/include /home/linuxbrew/.linuxbrew/lib \
    /home/linuxbrew/.linuxbrew/opt /home/linuxbrew/.linuxbrew/sbin \
    /home/linuxbrew/.linuxbrew/share \
    /home/linuxbrew/.linuxbrew/var/homebrew/linked \
    /home/linuxbrew/.linuxbrew/Cellar && \
    # 権限変更
    echo ${PW} | sudo -S chown -R $(whoami) /home/linuxbrew/.linuxbrew/etc \
    /home/linuxbrew/.linuxbrew/include \
    /home/linuxbrew/.linuxbrew/lib \
    /home/linuxbrew/.linuxbrew/opt \
    /home/linuxbrew/.linuxbrew/sbin \
    /home/linuxbrew/.linuxbrew/share \
    /home/linuxbrew/.linuxbrew/var/homebrew/linked \
    /home/linuxbrew/.linuxbrew/Cellar \
    /home/linuxbrew/.linuxbrew/Homebrew /home/linuxbrew/.linuxbrew/bin \
    /home/linuxbrew/.linuxbrew/var/homebrew/locks && \
    # パスの設定
    echo 'export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"' >> .bash_profile
