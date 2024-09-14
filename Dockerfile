FROM ubuntu:20.04

# Create app directory and set permissions
RUN mkdir -p /app && chmod 777 /app
WORKDIR /app

# Environment settings
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Kolkata

# Install required packages
RUN apt-get update && \
    apt-get install -y \
    git \
    aria2 \
    wget \
    curl \
    busybox \
    unzip \
    unrar \
    tar \
    python3 \
    python3-pip \
    ffmpeg \
    p7zip-full \
    p7zip-rar && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Install rclone
RUN wget https://rclone.org/install.sh && \
    bash install.sh

# Download and set up gclone
RUN mkdir /app/gautam && \
    wget -O /app/gautam/gclone.gz https://git.io/JJMSG && \
    gzip -d /app/gautam/gclone.gz && \
    chmod 0755 /app/gautam/gclone

# Copy and install Python dependencies
COPY requirements.txt .
RUN pip3 install --no-cache-dir -r requirements.txt

# Copy application files
COPY . .

# Ensure start.sh is executable
RUN chmod +x start.sh

# Run the script to start the bot and app
CMD ["bash", "start.sh"]
