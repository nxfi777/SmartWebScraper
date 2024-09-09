# Use the official Python image as a base
FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Install wget, unzip, and gnupg
RUN apt-get update && apt-get install -y wget unzip gnupg

# Install ChromeDriver
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y google-chrome-stable
RUN LATEST_VERSION=$(wget -q -O - https://chromedriver.storage.googleapis.com/LATEST_RELEASE) && \
    wget -q https://chromedriver.storage.googleapis.com/${LATEST_VERSION}/chromedriver_linux64.zip
RUN unzip chromedriver_linux64.zip -d /usr/local/bin/
RUN chmod +x /usr/local/bin/chromedriver

# Copy the requirements file
COPY requirements.txt .

# Install the dependencies
RUN pip install -r requirements.txt

# Copy the application code
COPY . .

# Expose the port for Streamlit
EXPOSE 8501

# Run the command to start Streamlit
CMD ["streamlit", "run", "streamlit_app.py"]