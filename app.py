from flask import Flask, request, jsonify, render_template, send_file
import requests
import os
from werkzeug.utils import secure_filename
import base64

app = Flask(__name__)

# Configuration
UPLOAD_FOLDER = 'uploads'
ALLOWED_EXTENSIONS = {'png', 'jpg', 'jpeg'}
OLLAMA_API_URL = "http://localhost:11434/api/generate"

# Ensure upload folder exists
if not os.path.exists(UPLOAD_FOLDER):
    os.makedirs(UPLOAD_FOLDER)

app.config['UPLOAD_FOLDER'] = UPLOAD_FOLDER

def allowed_file(filename):
    return '.' in filename and filename.rsplit('.', 1)[1].lower() in ALLOWED_EXTENSIONS

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/chat', methods=['POST'])
def chat():
    try:
        data = request.get_json()
        
        if not data or 'message' not in data:
            return jsonify({"error": "Please provide a message"}), 400
            
        ollama_request = {
            "model": "llama3.2:1b",
            "prompt": data['message'],
            "stream": False
        }
        
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

@app.route('/analyze', methods=['POST'])
def analyze_image():
    try:
        if 'image' not in request.files:
            return jsonify({"error": "No image file provided"}), 400
        
        file = request.files['image']
        disease_type = request.form.get('diseaseType')
        
        if file.filename == '':
            return jsonify({"error": "No selected file"}), 400
            
        if not disease_type:
            return jsonify({"error": "No disease type selected"}), 400
            
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            filepath = os.path.join(app.config['UPLOAD_FOLDER'], filename)
            file.save(filepath)
            
            # Convert image to base64 for Ollama
            with open(filepath, "rb") as image_file:
                encoded_image = base64.b64encode(image_file.read()).decode('utf-8')
            
            # Prepare prompt for image analysis
            prompt = f"""Analyze this medical image for signs of {disease_type}.
            Provide a detailed analysis including:
            1. Primary findings
            2. Confidence level
            3. Additional observations
            4. Recommendations"""
            
            # Send request to Ollama with image
            ollama_request = {
                "model": "llama3.2:1b",
                "prompt": prompt,
                "images": [encoded_image],
                "stream": False
            }
            
            response = requests.post(OLLAMA_API_URL, json=ollama_request)
            
            # Clean up uploaded file
            os.remove(filepath)
            
            if response.status_code == 200:
                analysis = response.json()['response']
                return jsonify({
                    "success": True,
                    "analysis": analysis,
                    "diseaseType": disease_type
                })
            else:
                return jsonify({
                    "error": "Failed to analyze image",
                    "status_code": response.status_code
                }), 500
                
        return jsonify({"error": "Invalid file type"}), 400
        
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(debug=True, port=5000)