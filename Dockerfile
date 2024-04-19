# Użyj obrazu Node.js jako bazy, ponieważ Node jest wymagany dla npm i Playwright
FROM node:14-buster

# Ustawienie zmiennej środowiskowej, aby uniknąć interaktywnego konfigurowania strefy czasowej podczas instalacji pakietów
ENV DEBIAN_FRONTEND=noninteractive

# Instalacja OpenJDK 11
RUN apt-get update && apt-get install -y openjdk-11-jdk

# Ustawienie JAVA_HOME i dodanie do ścieżki
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64
ENV PATH $JAVA_HOME/bin:$PATH

# Instalacja AWS CLI
RUN curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip" \
    && unzip awscliv2.zip \
    && ./aws/install

# Instalacja Allure Commandline
RUN npm install -g allure-commandline

# Instalacja Playwright w specyficznej wersji
RUN npm install -g playwright@1.37.0

RUN apt-get install -y libgbm1 libnss3 libnspr4 libatk1.0-0 libatk-bridge2.0-0 libcups2 libdbus-1-3 libxrandr2 \
    libxshmfence1 libxcomposite1 libxdamage1 libxkbcommon0 libwayland-client0 libpango-1.0-0 libpangocairo-1.0-0 \
    libx11-xcb1 libx11-6 libxcb1 libxfixes3 libxext6 libxcb-dri3-0 libdrm2 libgbm1 libasound2

# Instalacja wszystkich zależności przeglądarek dla Playwright
RUN npx playwright install




# Ustawienie pracy w katalogu /app
WORKDIR /app

# Kopiowanie aplikacji do kontenera (jeśli potrzebne)
COPY . /app

# Port, który może być używany przez aplikacje (jeśli potrzebne)
EXPOSE 8080

# Polecenie wykonywane podczas uruchamiania kontenera (dostosuj do swoich potrzeb)
