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

RUN apt-get install -y libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdbus-1-3 libxrandr2 libxshmfence1 libxcomposite1 libxdamage1 libxkbcommon0 libx11-xcb1 libxcb1


RUN npx playwright install

WORKDIR /app

COPY . /app



