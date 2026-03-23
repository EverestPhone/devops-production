
from flask import Flask, request, jsonify
from prometheus_client import Counter, generate_latest

app = Flask(__name__)

# Real metrics
REQUEST_COUNT = Counter('app_requests_total', 'Total API Requests')

@app.route('/health')
def health():
    REQUEST_COUNT.inc()
    return jsonify({"status": "ok"})

@app.route('/data', methods=['POST'])
def data():
    content = request.json
    return jsonify({"received": content})

@app.route('/metrics')
def metrics():
    return generate_latest(), 200, {'Content-Type': 'text/plain'}

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)
