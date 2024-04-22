FROM node:16-buster

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y openjdk-11-jdk

ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

RUN npm install -g allure-commandline

RUN npm install -g playwright@1.37.0

RUN apt-get install -y libgbm1 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdbus-1-3 libxrandr2 \
    libxshmfence1 libxcomposite1 libxdamage1 libxkbcommon0 libwayland-client0 libpango-1.0-0 libpangocairo-1.0-0 \
    libx11-xcb1 libx11-6 libxcb1 libxfixes3 libxext6 libxcb-dri3-0 libdrm2 libgbm1 libasound2


RUN npx playwright install

WORKDIR /app

COPY . /app



