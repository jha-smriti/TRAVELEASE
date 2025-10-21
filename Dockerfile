# Multi-stage Dockerfile for TRAVELEASE

# Stage 1: Build Node.js application
FROM node:20-alpine AS node-app

WORKDIR /app

# Copy package files
COPY package*.json ./

# Install Node.js dependencies
RUN npm ci --only=production

# Copy Node.js application files
COPY index.js ./
COPY app.js ./
COPY public ./public

# Stage 2: Build Python Flask application
FROM python:3.9-slim AS python-app

WORKDIR /app/chatbox

# Copy Python requirements first for better caching
COPY chatbox/requirements.txt ./requirements.txt 2>/dev/null || echo "Flask==2.1.2\ntorch==2.0.0\ntorchvision==0.15.0\nnltk==3.8.1\nflask-cors\nnumpy<2.0\nwerkzeug==2.0.3" > requirements.txt

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy chatbox files
COPY chatbox ./

# Download NLTK data
RUN python -c "import nltk; nltk.download('punkt')"

# Stage 3: Final multi-service image
FROM python:3.9-slim

# Install Node.js in the Python image
RUN apt-get update && apt-get install -y curl && \
    curl -fsSL https://deb.nodesource.com/setup_20.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Copy Node.js app from stage 1
COPY --from=node-app /app /app

# Copy Python app from stage 2
COPY --from=python-app /app/chatbox /app/chatbox

# Install Python dependencies
COPY chatbox/requirements.txt ./chatbox/requirements.txt 2>/dev/null || echo "Flask==2.1.2\ntorch==2.0.0\ntorchvision==0.15.0\nnltk==3.8.1\nflask-cors\nnumpy<2.0\nwerkzeug==2.0.3" > /app/chatbox/requirements.txt
RUN pip install --no-cache-dir -r /app/chatbox/requirements.txt

# Expose ports
EXPOSE 3000 5000

# Create a start script
RUN echo '#!/bin/bash\nset -e\n\
echo "Starting Flask chatbot..."\n\
cd /app/chatbox && python app.py &\n\
FLASK_PID=$!\n\
echo "Flask started with PID $FLASK_PID"\n\
\n\
echo "Starting Node.js server..."\n\
cd /app && node index.js &\n\
NODE_PID=$!\n\
echo "Node.js started with PID $NODE_PID"\n\
\n\
wait $FLASK_PID $NODE_PID' > /app/start.sh && chmod +x /app/start.sh

CMD ["/app/start.sh"]
