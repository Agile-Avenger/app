from flask import Flask, request, jsonify
import requests

app = Flask(__name__)

OLLAMA_API_URL = "http://localhost:11434/api/generate"

@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({"error": "Please provide a message"}), 400
            
        # Prepare the request to Ollama
        ollama_request = {
            "model": "llama3.2:1b",  # You can change this to any model you have pulled
            "prompt": data['message'],
            "stream": False
        }
        
        # Send request to Ollama
        response = requests.post(OLLAMA_API_URL, json=ollama_request)
        
        if response.status_code == 200:
            return jsonify({
                "response": response.json()['response'],
                "model": "llama3.2:1b"
            })
        else:
            return jsonify({
                "error": "Failed to get response from Ollama",
                "status_code": response.status_code
            }), 500
            
    except Exception as e:
        return jsonify({"error": str(e)}), 500

# Route to list available models
@app.route('/models', methods=['GET'])
def list_models():
    try:
        response = requests.get("http://localhost:11434/api/tags")
        if response.status_code == 200:
            return jsonify(response.json())
        else:
            return jsonify({
                "error": "Failed to get models from Ollama",
                "status_code": response.status_code
            }), 500
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)