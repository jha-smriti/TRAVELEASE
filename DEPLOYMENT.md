# TRAVELEASE Deployment Guide

This guide provides comprehensive instructions for deploying the TRAVELEASE application using various methods.

## Table of Contents
- [Prerequisites](#prerequisites)
- [Deployment Options](#deployment-options)
  - [Docker Deployment (Recommended)](#docker-deployment-recommended)
  - [Manual Deployment](#manual-deployment)
  - [Cloud Deployment](#cloud-deployment)
- [Environment Configuration](#environment-configuration)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### For Docker Deployment
- Docker Engine 20.10+
- Docker Compose 1.29+

### For Manual Deployment
- Node.js 18+ and npm
- Python 3.9+
- MongoDB 5.0+

## Deployment Options

### Docker Deployment (Recommended)

Docker deployment is the easiest and most reliable way to deploy TRAVELEASE. It packages the entire application with all dependencies.

#### Step 1: Clone the Repository
```bash
git clone https://github.com/jha-smriti/TRAVELEASE.git
cd TRAVELEASE
```

#### Step 2: Build and Run with Docker Compose
```bash
# Build and start all services
docker-compose up -d

# Check logs
docker-compose logs -f

# Stop services
docker-compose down
```

The application will be available at:
- **Main Application**: http://localhost:3000
- **Chatbot API**: http://localhost:5000

#### Step 3: Verify Deployment
```bash
# Check running containers
docker-compose ps

# Test the Node.js server
curl http://localhost:3000

# Test the Flask chatbot
curl http://localhost:5000
```

### Manual Deployment

#### Step 1: Install MongoDB
Follow the official MongoDB installation guide: https://docs.mongodb.com/manual/installation/

Start MongoDB:
```bash
# Linux/Mac
sudo systemctl start mongod

# Or if using Docker for MongoDB only
docker run -d -p 27017:27017 --name travelease-mongodb mongo:7.0
```

#### Step 2: Setup Node.js Application
```bash
# Install dependencies
npm install

# Start the Node.js server
node index.js
```

The Node.js server will run on port 3000.

#### Step 3: Setup Flask Chatbot
```bash
# Navigate to chatbox directory
cd chatbox

# Create virtual environment
python -m venv venv

# Activate virtual environment
# On Linux/Mac:
source venv/bin/activate
# On Windows:
venv\Scripts\activate

# Install dependencies
pip install -r requirements.txt

# Download NLTK data
python -c "import nltk; nltk.download('punkt')"

# Train the model (if not already trained)
python train.py

# Run Flask app
python app.py
```

The Flask chatbot will run on port 5000.

### Cloud Deployment

#### Deploy to AWS

##### Using EC2:
1. Launch an EC2 instance (Ubuntu 20.04 or later)
2. Install Docker and Docker Compose
3. Clone the repository
4. Run `docker-compose up -d`
5. Configure security groups to allow traffic on ports 3000 and 5000

##### Using ECS (Elastic Container Service):
1. Build the Docker image: `docker build -t travelease:latest .`
2. Push to Amazon ECR
3. Create an ECS task definition using the image
4. Deploy to ECS cluster

#### Deploy to Google Cloud Platform

##### Using Compute Engine:
1. Create a VM instance
2. Install Docker and Docker Compose
3. Clone the repository
4. Run `docker-compose up -d`

##### Using Cloud Run:
1. Build the image: `docker build -t gcr.io/[PROJECT-ID]/travelease .`
2. Push to Container Registry: `docker push gcr.io/[PROJECT-ID]/travelease`
3. Deploy to Cloud Run

#### Deploy to Azure

##### Using Azure Container Instances:
1. Build the image
2. Push to Azure Container Registry
3. Deploy using Azure Portal or CLI

#### Deploy to Heroku

Heroku deployment requires a Procfile and some modifications:

1. Create a `Procfile`:
```
web: node index.js
chatbot: cd chatbox && python app.py
```

2. Create `heroku.yml`:
```yaml
build:
  docker:
    web: Dockerfile
```

3. Deploy:
```bash
heroku create travelease-app
heroku stack:set container
git push heroku main
```

#### Deploy to DigitalOcean

##### Using Droplets:
1. Create a Droplet (Ubuntu 20.04+)
2. Install Docker and Docker Compose
3. Clone the repository
4. Run `docker-compose up -d`

##### Using App Platform:
1. Connect your GitHub repository
2. Configure build settings
3. Deploy

## Environment Configuration

### Required Environment Variables

Copy `.env.example` to `.env` and configure:

```bash
cp .env.example .env
```

Edit `.env`:
```
MONGODB_URI=mongodb://localhost:27017/touristDB
NODE_ENV=production
PORT=3000
FLASK_PORT=5000
```

### Production Considerations

1. **Database**: Use a managed MongoDB service (MongoDB Atlas, AWS DocumentDB)
   ```
   MONGODB_URI=mongodb+srv://username:password@cluster.mongodb.net/touristDB
   ```

2. **Security**: 
   - Use strong passwords
   - Enable SSL/TLS
   - Configure firewalls
   - Use environment variables for secrets

3. **Scaling**:
   - Use a load balancer (nginx, AWS ELB)
   - Scale horizontally with multiple containers
   - Use container orchestration (Kubernetes, Docker Swarm)

## Monitoring and Maintenance

### Health Checks
```bash
# Check Node.js server
curl http://localhost:3000

# Check Flask chatbot
curl http://localhost:5000/predict -X POST -H "Content-Type: application/json" -d '{"message": "hello"}'
```

### Viewing Logs
```bash
# Docker Compose logs
docker-compose logs -f

# Individual service logs
docker-compose logs -f web
docker-compose logs -f mongodb
```

### Backup MongoDB Data
```bash
# Create backup
docker exec travelease-mongodb mongodump --out /data/backup

# Copy backup from container
docker cp travelease-mongodb:/data/backup ./mongodb-backup
```

## Troubleshooting

### Port Already in Use
```bash
# Find process using port 3000
lsof -i :3000
# or
netstat -ano | grep 3000

# Kill the process
kill -9 <PID>
```

### MongoDB Connection Issues
- Ensure MongoDB is running: `docker-compose ps`
- Check MongoDB logs: `docker-compose logs mongodb`
- Verify connection string in `.env`

### Docker Build Fails
```bash
# Clear Docker cache
docker system prune -a

# Rebuild without cache
docker-compose build --no-cache
```

### Python Dependencies Issues
If torch installation fails, try:
```bash
pip install torch==2.0.0 --index-url https://download.pytorch.org/whl/cpu
```

## Performance Optimization

1. **Use a reverse proxy** (nginx) for serving static files
2. **Enable caching** for API responses
3. **Compress responses** using gzip
4. **Use a CDN** for static assets
5. **Optimize Docker images** (multi-stage builds, alpine base)

## Security Best Practices

1. **Never commit secrets** to the repository
2. **Use environment variables** for configuration
3. **Keep dependencies updated**: `npm audit fix`, `pip list --outdated`
4. **Enable HTTPS** in production
5. **Implement rate limiting** for APIs
6. **Validate and sanitize** user inputs

## Support

For issues and questions:
- GitHub Issues: https://github.com/jha-smriti/TRAVELEASE/issues
- Project Repository: https://github.com/jha-smriti/TRAVELEASE

## License

This project is licensed under the MIT License.
