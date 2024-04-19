# Use a Playwright-ready Node.js image
FROM mcr.microsoft.com/playwright:v1.37.0-jammy

# Set non-interactive frontend (avoids some prompts)
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Etc/UTC
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk-amd64

# Update system and install Java, AWS CLI, and any other dependencies
RUN apt-get update && apt-get install -y \
    openjdk-11-jdk \
    awscli \
    tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime \
    && dpkg-reconfigure --frontend noninteractive tzdata

# Configure JAVA_HOME and PATH environment variables
RUN echo "export JAVA_HOME=${JAVA_HOME}" >> /etc/bash.bashrc \
    && echo "export PATH=${JAVA_HOME}/bin:${PATH}" >> /etc/bash.bashrc

# Install npm global packages
RUN npm install -g allure-commandline

# Set the working directory
WORKDIR /app

# Copy application code
COPY . /app

# Install application dependencies
RUN npm install



# Prepare environment variables and directories for Allure and AWS
RUN mkdir -p /app/allure-results /app/allure-report

# Set additional environment variables via the Dockerfile if required
ENV AWS_DEFAULT_REGION=eu-central-1

# Command to run our app and test process
CMD ["sh", "-c", "aws configure set aws_access_key_id $AWS_ACCESS_KEY_ID && \
                  aws configure set aws_secret_access_key $AWS_SECRET_ACCESS_KEY && \
                  aws s3 cp s3://allure-poc-wojtek/allure-reports/latest/history ./allure-results/history --recursive && \
                  npm test && \
                  allure generate allure-results --clean && \
                  aws s3 sync ./allure-report s3://allure-poc-wojtek/allure-reports/$UNIQUE_REPORT_DIR --acl public-read && \
                  aws s3 rm s3://allure-poc-wojtek/allure-reports/latest --recursive && \
                  aws s3 cp --recursive ./allure-report s3://allure-poc-wojtek/allure-reports/latest/ && \
                  aws s3 cp --recursive ./allure-report/history s3://allure-poc-wojtek/allure-reports/latest/history/ && \
                  echo 'Allure report is available at https://allure-poc-wojtek.s3.eu-central-1.amazonaws.com/allure-reports/${UNIQUE_REPORT_DIR}/index.html'"]
