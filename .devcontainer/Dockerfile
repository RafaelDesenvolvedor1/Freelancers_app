FROM ubuntu:22.04

# Evita perguntas interativas durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Instala dependências básicas do sistema e compilação
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openjdk-11-jdk-headless \
    wget \
    && rm -rf /var/lib/apt/lists/*

# Cria um usuário não-root para o VS Code usar (boa prática de segurança)
RUN useradd -ms /bin/bash developer
USER developer
WORKDIR /home/developer

# Baixa e instala o SDK do Flutter (Versão estável)
RUN git clone https://github.com/flutter/flutter.git -b stable /home/developer/flutter
ENV PATH="/home/developer/flutter/bin:/home/developer/flutter/bin/cache/dart-sdk/bin:${PATH}"

# Executa o doctor para baixar os componentes internos do Dart/Flutter
RUN flutter doctor

EXPOSE 8085