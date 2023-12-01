# Use a base image with Java and Maven
FROM adoptopenjdk:8-jdk-hotspot

# Set the working directory in the container
WORKDIR /app

# Copy the project files to the container
COPY . .

#Install Maven
RUN apt-get update && \
    apt-get install -y maven

# Download and set up ChromeDriver (if required)
ARG CHROME_DRIVER_VERSION="119.0.6045.105"
RUN apt-get install -y wget unzip && \
    wget -q --continue -P /tmp "https://edgedl.me.gvt1.com/edgedl/chrome/chrome-for-testing/${CHROME_DRIVER_VERSION}/linux64/chromedriver-linux64.zip" && \
    unzip -q /tmp/chromedriver-linux64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver-linux64

# Install Chrome in the container (if required)
# Example for installing Chrome, adjust according to your needs
# RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
#     echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
#     apt-get update && \
#     apt-get install -y google-chrome-stable

# Set up any additional configurations or dependencies

# Set the command to run the UI tests
CMD ["mvn", "test", "-Dgroups=business.service.unittests", "-DexcludedGroups=business.service.integrationtests"]
#CMD ["mvn", "clean", "test"]