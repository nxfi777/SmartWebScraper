# Use the official Python image as a base
FROM python:3.10-slim

# Set the working directory to /app
WORKDIR /app

# Install necessary dependencies including curl, Chromium, and Chromium Driver
RUN apt-get update && apt-get install -y wget unzip gnupg gpg curl \
    chromium chromium-driver

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