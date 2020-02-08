FROM ubuntu:18.04
LABEL maintainer beeeeyan
#環境変数を設定
ENV DEBIAN_FRONTEND=noninteractive
ENV USER beeeeyan
ENV HOME /home/${USER}
ENV SHELL /bin/bash

# 種々インストール
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    vim \
    sudo \
    expect \
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
    echo "${USER}:password" | chpasswd && \
    # ログインシェルを指定
    sed -i.bak -r s#${HOME}:\(.+\)#${HOME}:${SHELL}# /etc/passwd && \
    #　localの設定
    locale-gen en_US.UTF-8

# コマンドを実行するUSERを変更
USER ${USER}
# 作業ディレクトリを指定
WORKDIR ${HOME}

COPY enter.exp enter.exp
# Linuxbrewをインストール
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/Linuxbrew/install/master/install.sh)" && \
# RUN expect enter.exp && \
    echo 'export PATH=${HOME}/.linuxbrew/bin:$PATH' >> .bash_profile
