# Use the official Python image as a base
FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Install necessary dependencies including curl
RUN apt-get update && apt-get install -y wget unzip gnupg gpg curl

# Install specific version of Chrome (version 114)
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | gpg --dearmor | tee /etc/apt/trusted.gpg.d/google-chrome.gpg
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list'
RUN apt-get update && apt-get install -y google-chrome-stable=114.0.5735.90-1

# Download and install the matching ChromeDriver for version 114
RUN wget -q "https://chromedriver.storage.googleapis.com/114.0.5735.90/chromedriver_linux64.zip" && \
    unzip chromedriver_linux64.zip -d /usr/local/bin/ && \
    chmod +x /usr/local/bin/chromedriver && \
    rm chromedriver_linux64.zip

# Ensure shared memory allocation
RUN mkdir -p /dev/shm && mount -t tmpfs -o size=1G tmpfs /dev/shm

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