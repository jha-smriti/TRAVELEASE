@echo off
REM TRAVELEASE Startup Script for Windows
REM This script starts both the Node.js server and Flask chatbot

echo ==================================
echo Starting TRAVELEASE Application
echo ==================================
echo.

REM Check if MongoDB is running
echo Checking MongoDB connection...
netstat -an | find "27017" > nul
if errorlevel 1 (
    echo Warning: MongoDB might not be running on localhost:27017
    echo Please start MongoDB or use Docker: docker-compose up -d mongodb
    echo.
)

REM Start Flask chatbot
echo Starting Flask chatbot on port 5000...
cd chatbox

REM Check if virtual environment exists
if not exist "venv\" (
    echo Creating Python virtual environment...
    python -m venv venv
)

REM Activate virtual environment
call venv\Scripts\activate.bat

REM Install dependencies if not installed
if not exist "data.pth" (
    echo Installing Python dependencies...
    pip install -r requirements.txt
    python -c "import nltk; nltk.download('punkt')"
    echo Training chatbot model...
    python train.py
)

REM Start Flask app in background
start /B python app.py
echo Flask chatbot started on port 5000

cd ..

REM Start Node.js server
echo Starting Node.js server on port 3000...
start /B node index.js
echo Node.js server started on port 3000

echo.
echo ==================================
echo TRAVELEASE is running!
echo ==================================
echo Main Application: http://localhost:3000
echo Chatbot API: http://localhost:5000
echo.
echo Press Ctrl+C to stop
echo.

pause
