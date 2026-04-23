import 'dart:async';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ResultsScreen extends StatefulWidget {
  final String scanId;

  const ResultsScreen({super.key, required this.scanId});

  @override
  State<ResultsScreen> createState() => _ResultsScreenState();
}

class _ResultsScreenState extends State<ResultsScreen> {
  Map<String, dynamic>? _scanData;
  Timer? _timer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchResults();
    // Poll for updates every 3 seconds if not completed
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_scanData != null && _scanData!['status'] != 'running') {
        timer.cancel();
      } else {
        _fetchResults();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _fetchResults() async {
    try {
      final data = await ApiService.getScanResults(widget.scanId);
      if (mounted) {
        setState(() {
          _scanData = data;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching results: $e');
    }
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high': return Colors.redAccent;
      case 'medium': return Colors.orangeAccent;
      case 'low': return Colors.yellowAccent;
      default: return Colors.blueAccent;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Scan Results')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final status = _scanData?['status'] ?? 'unknown';
    final target = _scanData?['target'] ?? 'Unknown';
    final type = _scanData?['type'] ?? 'Unknown';
    final results = _scanData?['results'] ?? [];
    final error = _scanData?['error'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target: $target', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Text('Type: $type Scan', style: const TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    if (status == 'running')
                      const CircularProgressIndicator(color: Color(0xFFC6FF00))
                    else if (status == 'completed')
                      const Icon(Icons.check_circle, color: Colors.greenAccent, size: 32)
                    else
                      const Icon(Icons.error, color: Colors.redAccent, size: 32),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Threats Detected',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            if (status == 'running')
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(),
                      SizedBox(height: 16),
                      Text('Scanning in progress...', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),
              )
            else if (status == 'failed')
              Expanded(
                child: Center(
                  child: Text('Scan failed: $error', style: const TextStyle(color: Colors.redAccent)),
                ),
              )
            else if (results.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No vulnerabilities detected!\nYour system looks secure.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.greenAccent, fontSize: 16),
                  ),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final item = results[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: const Color(0xFF2C2C2C),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: _getSeverityColor(item['severity']), width: 1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        leading: Icon(
                          Icons.warning_amber_rounded,
                          color: _getSeverityColor(item['severity']),
                        ),
                        title: Text(item['title'] ?? 'Unknown Issue', style: const TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: Text('Severity: ${item['severity']}', style: TextStyle(color: _getSeverityColor(item['severity']))),
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(item['description'] ?? 'No description provided.'),
                                const SizedBox(height: 12),
                                const Text('Fix Suggestion:', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
                                const SizedBox(height: 4),
                                Text(item['fix'] ?? 'No fix provided.', style: const TextStyle(color: Color(0xFFC6FF00))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
