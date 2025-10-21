# Cloud Platform Deployment Guides

This document provides step-by-step instructions for deploying TRAVELEASE on various cloud platforms.

## Table of Contents
- [AWS Deployment](#aws-deployment)
- [Google Cloud Platform](#google-cloud-platform)
- [Microsoft Azure](#microsoft-azure)
- [Heroku](#heroku)
- [DigitalOcean](#digitalocean)
- [Render](#render)
- [Railway](#railway)

---

## AWS Deployment

### Option 1: AWS EC2 (Virtual Machine)

#### Prerequisites
- AWS account
- AWS CLI installed and configured

#### Steps

1. **Launch EC2 Instance**
   ```bash
   # Using AWS Console:
   # - Choose Ubuntu 20.04 or later
   # - Instance type: t2.medium or larger
   # - Configure security group to allow ports 22, 80, 443, 3000, 5000
   ```

2. **Connect to Instance**
   ```bash
   ssh -i your-key.pem ubuntu@your-instance-ip
   ```

3. **Install Docker and Docker Compose**
   ```bash
   # Update system
   sudo apt-get update
   sudo apt-get upgrade -y

   # Install Docker
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   sudo usermod -aG docker ubuntu

   # Install Docker Compose
   sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose

   # Logout and login again for group changes to take effect
   exit
   ```

4. **Deploy Application**
   ```bash
   # Clone repository
   git clone https://github.com/jha-smriti/TRAVELEASE.git
   cd TRAVELEASE

   # Start services
   docker-compose up -d

   # Check status
   docker-compose ps
   ```

5. **Configure Reverse Proxy (Optional but Recommended)**
   ```bash
   # Install nginx
   sudo apt-get install nginx -y

   # Create nginx configuration
   sudo nano /etc/nginx/sites-available/travelease
   ```

   Add this configuration:
   ```nginx
   server {
       listen 80;
       server_name your-domain.com;

       location / {
           proxy_pass http://localhost:3000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }

       location /predict {
           proxy_pass http://localhost:5000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

   ```bash
   # Enable site
   sudo ln -s /etc/nginx/sites-available/travelease /etc/nginx/sites-enabled/
   sudo nginx -t
   sudo systemctl restart nginx
   ```

### Option 2: AWS ECS (Elastic Container Service)

1. **Build and Push Docker Image to ECR**
   ```bash
   # Create ECR repository
   aws ecr create-repository --repository-name travelease

   # Get login credentials
   aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com

   # Build and tag image
   docker build -t travelease .
   docker tag travelease:latest YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/travelease:latest

   # Push to ECR
   docker push YOUR_ACCOUNT_ID.dkr.ecr.us-east-1.amazonaws.com/travelease:latest
   ```

2. **Create ECS Task Definition**
   - Use AWS Console or CLI to create task definition
   - Configure container with image from ECR
   - Set port mappings (3000, 5000)
   - Configure environment variables

3. **Create ECS Service**
   - Create ECS cluster
   - Create service using task definition
   - Configure load balancer

### Option 3: AWS Elastic Beanstalk

1. **Install EB CLI**
   ```bash
   pip install awsebcli
   ```

2. **Initialize and Deploy**
   ```bash
   eb init -p docker travelease
   eb create travelease-env
   eb open
   ```

---

## Google Cloud Platform

### Option 1: Google Compute Engine (VM)

1. **Create VM Instance**
   ```bash
   gcloud compute instances create travelease-vm \
     --image-family=ubuntu-2004-lts \
     --image-project=ubuntu-os-cloud \
     --machine-type=e2-medium \
     --zone=us-central1-a
   ```

2. **SSH into Instance**
   ```bash
   gcloud compute ssh travelease-vm --zone=us-central1-a
   ```

3. **Follow the same Docker installation and deployment steps as AWS EC2**

### Option 2: Google Cloud Run

1. **Build and Push to Container Registry**
   ```bash
   # Set project
   gcloud config set project YOUR_PROJECT_ID

   # Build image
   gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/travelease

   # Or use Docker
   docker build -t gcr.io/YOUR_PROJECT_ID/travelease .
   docker push gcr.io/YOUR_PROJECT_ID/travelease
   ```

2. **Deploy to Cloud Run**
   ```bash
   gcloud run deploy travelease \
     --image gcr.io/YOUR_PROJECT_ID/travelease \
     --platform managed \
     --region us-central1 \
     --allow-unauthenticated \
     --port 3000
   ```

### Option 3: Google Kubernetes Engine (GKE)

1. **Create GKE Cluster**
   ```bash
   gcloud container clusters create travelease-cluster \
     --num-nodes=2 \
     --machine-type=e2-medium \
     --zone=us-central1-a
   ```

2. **Deploy Application**
   ```bash
   kubectl create deployment travelease --image=gcr.io/YOUR_PROJECT_ID/travelease
   kubectl expose deployment travelease --type=LoadBalancer --port 80 --target-port 3000
   ```

---

## Microsoft Azure

### Option 1: Azure Virtual Machines

1. **Create VM**
   ```bash
   az vm create \
     --resource-group travelease-rg \
     --name travelease-vm \
     --image UbuntuLTS \
     --admin-username azureuser \
     --generate-ssh-keys
   ```

2. **Open Ports**
   ```bash
   az vm open-port --port 3000 --resource-group travelease-rg --name travelease-vm
   az vm open-port --port 5000 --resource-group travelease-rg --name travelease-vm
   ```

3. **SSH and Deploy**
   ```bash
   ssh azureuser@YOUR_VM_IP
   # Follow Docker installation and deployment steps
   ```

### Option 2: Azure Container Instances

1. **Create Container Registry**
   ```bash
   az acr create --resource-group travelease-rg --name traveleaseacr --sku Basic
   ```

2. **Build and Push**
   ```bash
   az acr build --registry traveleaseacr --image travelease:latest .
   ```

3. **Deploy Container**
   ```bash
   az container create \
     --resource-group travelease-rg \
     --name travelease \
     --image traveleaseacr.azurecr.io/travelease:latest \
     --dns-name-label travelease \
     --ports 3000 5000
   ```

### Option 3: Azure App Service

1. **Create App Service Plan**
   ```bash
   az appservice plan create --name travelease-plan --resource-group travelease-rg --is-linux --sku B1
   ```

2. **Create Web App**
   ```bash
   az webapp create --resource-group travelease-rg --plan travelease-plan --name travelease-app --deployment-container-image-name traveleaseacr.azurecr.io/travelease:latest
   ```

---

## Heroku

### Quick Deploy

1. **Install Heroku CLI**
   ```bash
   # macOS
   brew tap heroku/brew && brew install heroku

   # Ubuntu
   curl https://cli-assets.heroku.com/install.sh | sh
   ```

2. **Login and Create App**
   ```bash
   heroku login
   heroku create travelease-app
   ```

3. **Deploy with Docker**
   ```bash
   heroku stack:set container
   git push heroku main
   ```

4. **Add MongoDB**
   ```bash
   heroku addons:create mongolab:sandbox
   ```

5. **Set Environment Variables**
   ```bash
   heroku config:set NODE_ENV=production
   ```

6. **Open Application**
   ```bash
   heroku open
   ```

---

## DigitalOcean

### Option 1: Droplet (VM)

1. **Create Droplet**
   - Use DigitalOcean Console
   - Choose Ubuntu 20.04
   - Select plan (at least 2GB RAM recommended)
   - Add SSH key

2. **SSH and Deploy**
   ```bash
   ssh root@your-droplet-ip
   # Follow Docker installation and deployment steps
   ```

### Option 2: App Platform

1. **Connect GitHub Repository**
   - Go to DigitalOcean App Platform
   - Connect your GitHub account
   - Select TRAVELEASE repository

2. **Configure Build Settings**
   - Dockerfile will be automatically detected
   - Configure environment variables
   - Set resources (CPU, RAM)

3. **Deploy**
   - Click "Deploy"
   - App Platform will build and deploy automatically

### Option 3: DigitalOcean Kubernetes

1. **Create Kubernetes Cluster**
   ```bash
   doctl kubernetes cluster create travelease-cluster --region nyc1 --node-pool "name=worker-pool;size=s-2vcpu-2gb;count=2"
   ```

2. **Deploy Application**
   ```bash
   kubectl apply -f k8s-deployment.yml
   ```

---

## Render

### Quick Deploy

1. **Sign up at render.com**

2. **Create New Web Service**
   - Connect GitHub repository
   - Render will detect Dockerfile automatically

3. **Configure**
   - Name: travelease
   - Environment: Docker
   - Plan: Free or Starter

4. **Add Environment Variables**
   ```
   MONGODB_URI=your-mongodb-uri
   NODE_ENV=production
   ```

5. **Deploy**
   - Click "Create Web Service"
   - Render will automatically build and deploy

---

## Railway

### Quick Deploy

1. **Sign up at railway.app**

2. **New Project from GitHub**
   - Connect GitHub account
   - Select TRAVELEASE repository

3. **Add MongoDB**
   - Click "New"
   - Select "Database" → "MongoDB"
   - Copy connection string

4. **Configure Environment Variables**
   ```
   MONGODB_URI=your-railway-mongodb-uri
   NODE_ENV=production
   ```

5. **Deploy**
   - Railway will automatically detect Dockerfile
   - Application will be deployed automatically

---

## Post-Deployment Steps

After deploying on any platform:

1. **Verify Deployment**
   ```bash
   curl https://your-app-url.com
   curl https://your-app-url.com/predict -X POST -H "Content-Type: application/json" -d '{"message":"hello"}'
   ```

2. **Configure Custom Domain** (Optional)
   - Add DNS records pointing to your deployment
   - Configure SSL/TLS certificate

3. **Set Up Monitoring**
   - Enable platform-specific monitoring tools
   - Set up alerts for downtime or errors

4. **Configure Backups**
   - Set up automated database backups
   - Store backups in separate location

## Troubleshooting

### Common Issues

1. **Port Binding Issues**
   - Ensure ports 3000 and 5000 are not in use
   - Check firewall/security group settings

2. **MongoDB Connection**
   - Verify MONGODB_URI environment variable
   - Ensure MongoDB is accessible from your deployment

3. **Memory Issues**
   - PyTorch requires significant memory
   - Use at least 2GB RAM for production

4. **Build Timeouts**
   - Increase build timeout in platform settings
   - Consider using pre-built base images

## Cost Optimization

- **Use free tiers** for development/testing
- **Right-size resources** based on traffic
- **Use spot/preemptible instances** for non-critical workloads
- **Set up auto-scaling** for variable traffic
- **Use managed databases** to reduce operational overhead

## Support

For deployment issues:
- Check platform-specific documentation
- Review application logs
- GitHub Issues: https://github.com/jha-smriti/TRAVELEASE/issues
