
# Tourism Guide Project

Welcome to the Tourism Guide Project! This guide is designed to help you explore various tourist destinations with ease and convenience, offering a range of features to enhance your travel planning experience.

One of the key features of our project is budget selectivity through database integration. You can choose your travel destinations based on your budget preferences, ensuring you find the best options within your desired price range. Our database includes various packages, allowing you to view detailed pricing for adults and children, helping you make informed decisions.

For instant assistance, our chatbot, powered by a Flask application, is at your service. The chatbox feature provides immediate help and answers to your travel-related queries, ensuring you have support whenever you need it.

To enhance your travel experience, we've integrated various APIs. The YouTube API allows you to watch travel videos directly from YouTube, giving you a visual glimpse of your destinations. Additionally, the Weather API provides real-time weather forecasts for your selected destinations, helping you plan your trips accordingly.

The Tourism Guide Project is designed to be your ultimate travel companion, making it easier for you to plan, explore, and enjoy your trips. We hope you find it helpful and enjoy using our platform as much as we enjoyed creating it for you.

## Getting Started

### Prerequisites

- Node.js
- Mongoose
- Body-Parser
- Express
- MongoDB
- Flask

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/jha-smriti/travel_jp.git
   ```

2. **Navigate to the project directory**:
   ```bash
   cd travel_jp
   ```

3. **Install dependencies for Node.js application**:
   ```bash
   npm install
   npm i mongoose express body-parser
   ```

4. **Start the Node.js server**:
   ```bash
   node index.js
   ```

5. **Navigate to the Flask application directory and open virtual environment**:
   ```bash
   cd chatbox
   python -m venv venv
   venv\Scripts\activate
   ```

6. **Install Flask dependencies**:
   ```bash
   pip install "numpy<2.0" Flask==2.1.2 torch==2.0.0 torchvision==0.15.0 nltk==3.8.1
   pip install werkzeug==2.0.3
   ```

7. **Train the chatbox**:
   ```bash
   python -c "import nltk; nltk.download('punkt')"
   python train.py
   ```

8. **Run the Flask app**:
   ```bash
   python app.py
   ```

## Usage

### Quick Start with Docker (Recommended)

The easiest way to run TRAVELEASE is using Docker:

```bash
# Clone the repository
git clone https://github.com/jha-smriti/TRAVELEASE.git
cd TRAVELEASE

# Start all services with Docker Compose
docker-compose up -d

# Access the application at http://localhost:3000
```

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

### Web Interface
Open your web browser and navigate to `http://localhost:3000` to explore the tourism guide.

### Chatbot
Interact with the chatbot for any travel-related queries.

### Review and Contact
Use the respective sections to leave reviews or contact us.

## Contributing

We welcome contributions to improve the Tourism Guide Project. Feel free to fork the repository and submit pull requests.

## Deployment

TRAVELEASE can be deployed using multiple methods:

- **Docker** (Recommended): `docker-compose up -d`
- **Manual**: Follow the installation steps above
- **Cloud Platforms**: AWS, GCP, Azure, Heroku, DigitalOcean

See [DEPLOYMENT.md](DEPLOYMENT.md) for comprehensive deployment instructions including:
- Docker deployment with docker-compose
- Manual deployment steps
- Cloud platform deployment guides (AWS, GCP, Azure, Heroku, DigitalOcean)
- Environment configuration
- Production best practices
- Troubleshooting tips

## License

This project is licensed under the MIT License.
