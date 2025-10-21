# Quick Start Guide - TRAVELEASE

This guide will help you get TRAVELEASE running in under 5 minutes.

## Prerequisites

Choose one of the following:
- **Option A**: Docker Desktop installed (Recommended - easiest)
- **Option B**: Node.js 18+, Python 3.9+, and MongoDB 5.0+ installed

## Option A: Docker (Recommended - 5 minutes)

### Step 1: Clone and Navigate
```bash
git clone https://github.com/jha-smriti/TRAVELEASE.git
cd TRAVELEASE
```

### Step 2: Start Everything
```bash
docker-compose up -d
```

### Step 3: Access the Application
- **Main Website**: http://localhost:3000
- **Chatbot API**: http://localhost:5000

### Step 4: View Logs (Optional)
```bash
docker-compose logs -f
```

### Stop the Application
```bash
docker-compose down
```

That's it! 🎉

---

## Option B: Manual Setup (15-20 minutes)

### Step 1: Clone the Repository
```bash
git clone https://github.com/jha-smriti/TRAVELEASE.git
cd TRAVELEASE
```

### Step 2: Start MongoDB
```bash
# Using Docker (easiest)
docker run -d -p 27017:27017 --name travelease-mongodb mongo:7.0

# OR follow MongoDB installation guide for your OS:
# https://docs.mongodb.com/manual/installation/
```

### Step 3: Set Up Node.js Server

#### Install Dependencies
```bash
npm install
```

#### Start Node.js Server
```bash
node index.js
```

The server will run on http://localhost:3000

### Step 4: Set Up Flask Chatbot (In a New Terminal)

#### Navigate to Chatbox Directory
```bash
cd chatbox
```

#### Create Virtual Environment
```bash
# Linux/Mac
python3 -m venv venv
source venv/bin/activate

# Windows
python -m venv venv
venv\Scripts\activate
```

#### Install Dependencies
```bash
pip install -r requirements.txt
```

#### Download NLTK Data and Train Model
```bash
python -c "import nltk; nltk.download('punkt')"
python train.py
```

#### Start Flask Server
```bash
python app.py
```

The chatbot will run on http://localhost:5000

### Step 5: Access the Application
Open your browser and go to http://localhost:3000

---

## Using Startup Scripts

We've provided convenience scripts to start both servers at once:

### Linux/Mac
```bash
chmod +x start.sh
./start.sh
```

### Windows
```bash
start.bat
```

---

## Troubleshooting

### Port Already in Use
If ports 3000 or 5000 are already in use:

```bash
# Find and kill process using port 3000
# Linux/Mac:
lsof -i :3000
kill -9 <PID>

# Windows:
netstat -ano | findstr :3000
taskkill /PID <PID> /F
```

### MongoDB Connection Error
- Ensure MongoDB is running: `docker ps` or check your MongoDB service
- Check the connection string in `index.js` (default: `mongodb://0.0.0.0:27017/touristDB`)

### Python Dependencies Fail to Install
If PyTorch installation fails:
```bash
# Install CPU version
pip install torch==2.0.0 --index-url https://download.pytorch.org/whl/cpu
```

### Application Doesn't Load
1. Check if both servers are running
2. Check console for errors: `docker-compose logs` or check terminal output
3. Verify MongoDB is running and accessible

---

## Next Steps

- 📖 Read [DEPLOYMENT.md](DEPLOYMENT.md) for production deployment
- ☁️ See [CLOUD-DEPLOYMENT.md](CLOUD-DEPLOYMENT.md) for cloud platform guides
- 🐛 Report issues at https://github.com/jha-smriti/TRAVELEASE/issues

---

## Testing the Application

### Test Node.js Server
```bash
curl http://localhost:3000
```

### Test Chatbot
```bash
curl http://localhost:5000/predict \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"message":"hello"}'
```

Expected response:
```json
{"answer":"Hi there! How can I help you?"}
```

---

## Features to Explore

1. **Budget-Based Travel Planning** - Find destinations within your budget
2. **Interactive Chatbot** - Get instant travel advice
3. **YouTube Integration** - Watch destination videos
4. **Weather Forecasts** - Real-time weather information
5. **Maps and Reviews** - Explore destinations and read reviews

Enjoy using TRAVELEASE! 🌍✈️
