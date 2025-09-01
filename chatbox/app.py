import logging
from flask import Flask, send_from_directory, request, jsonify
from flask_cors import CORS
from chat import get_response

app = Flask(__name__)
CORS(app)
logging.basicConfig(level=logging.DEBUG)

# Serve the index.html file from the public directory
@app.route("/", methods=["GET"])
def index_get():
    return send_from_directory('../public', 'index.html')

# Endpoint for chat response
@app.route("/predict", methods=["POST"])
def predict():
    text = request.get_json().get("message")
    response = get_response(text)
    message = {"answer": response}
    return jsonify(message)

if __name__ == "__main__":
    app.run(debug=True, port=5000)
