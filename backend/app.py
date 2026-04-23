from flask import Flask, request, jsonify
from flask_cors import CORS
from scanner import run_scan
import uuid
import threading

app = Flask(__name__)
CORS(app)

# In-memory store for scan results
scans = {}

@app.route('/scan', methods=['POST'])
def start_scan():
    data = request.json
    target = data.get('target')
    scan_type = data.get('type', 'Quick')
    
    if not target:
        return jsonify({"error": "Target is required"}), 400

    scan_id = str(uuid.uuid4())
    scans[scan_id] = {
        "id": scan_id,
        "target": target,
        "status": "running",
        "type": scan_type,
        "results": []
    }
    
    # Run scan in background
    thread = threading.Thread(target=run_scan_background, args=(scan_id, target, scan_type))
    thread.start()
    
    return jsonify({"id": scan_id, "message": "Scan started"}), 202

def run_scan_background(scan_id, target, scan_type):
    try:
        results = run_scan(target, scan_type)
        scans[scan_id]["status"] = "completed"
        scans[scan_id]["results"] = results
    except Exception as e:
        scans[scan_id]["status"] = "failed"
        scans[scan_id]["error"] = str(e)

@app.route('/results/<scan_id>', methods=['GET'])
def get_results(scan_id):
    if scan_id not in scans:
        return jsonify({"error": "Scan not found"}), 404
    return jsonify(scans[scan_id])

@app.route('/recent_scans', methods=['GET'])
def recent_scans():
    # Return last 10 scans
    recent = list(scans.values())[-10:]
    recent.reverse()
    return jsonify(recent)

if __name__ == '__main__':
    app.run(debug=True, port=5000, host="0.0.0.0")
