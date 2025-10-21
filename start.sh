#!/bin/bash

# TRAVELEASE Startup Script
# This script starts both the Node.js server and Flask chatbot

set -e

echo "=================================="
echo "Starting TRAVELEASE Application"
echo "=================================="
echo ""

# Check if MongoDB is running
echo "Checking MongoDB connection..."
if ! nc -z localhost 27017 2>/dev/null; then
    echo "⚠️  Warning: MongoDB is not running on localhost:27017"
    echo "   Please start MongoDB or use Docker: docker-compose up -d mongodb"
    echo ""
fi

# Start Flask chatbot in background
echo "Starting Flask chatbot on port 5000..."
cd chatbox

# Check if virtual environment exists
if [ ! -d "venv" ]; then
    echo "Creating Python virtual environment..."
    python3 -m venv venv
fi

# Activate virtual environment
source venv/bin/activate

# Install dependencies if not installed
if [ ! -f "data.pth" ]; then
    echo "Installing Python dependencies..."
    pip install -r requirements.txt
    python -c "import nltk; nltk.download('punkt')"
    echo "Training chatbot model..."
    python train.py
fi

# Start Flask app
python app.py &
FLASK_PID=$!
echo "✓ Flask chatbot started (PID: $FLASK_PID)"

cd ..

# Start Node.js server
echo "Starting Node.js server on port 3000..."
node index.js &
NODE_PID=$!
echo "✓ Node.js server started (PID: $NODE_PID)"

echo ""
echo "=================================="
echo "TRAVELEASE is running!"
echo "=================================="
echo "Main Application: http://localhost:3000"
echo "Chatbot API: http://localhost:5000"
echo ""
echo "Press Ctrl+C to stop all services"
echo ""

# Wait for both processes
wait $FLASK_PID $NODE_PID
