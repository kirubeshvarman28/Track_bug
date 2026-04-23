import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'results_screen.dart';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  final _targetController = TextEditingController();
  String _scanType = 'Quick';
  bool _isStarting = false;

  void _startScan() async {
    final target = _targetController.text.trim();
    if (target.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a target URL or IP')),
      );
      return;
    }

    setState(() => _isStarting = true);

    try {
      final response = await ApiService.startScan(target, _scanType);
      final scanId = response['id'];
      
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => ResultsScreen(scanId: scanId)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting scan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isStarting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Scan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Target Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _targetController,
              decoration: InputDecoration(
                labelText: 'URL or IP Address',
                hintText: 'e.g., example.com or 192.168.1.1',
                prefixIcon: const Icon(Icons.language),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: const Color(0xFF2C2C2C),
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Scan Type',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Card(
              color: const Color(0xFF2C2C2C),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Column(
                children: [
                  RadioListTile<String>(
                    title: const Text('Quick Scan', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Fast port scan for common vulnerabilities.'),
                    value: 'Quick',
                    groupValue: _scanType,
                    activeColor: const Color(0xFFC6FF00),
                    onChanged: (value) {
                      setState(() => _scanType = value!);
                    },
                  ),
                  const Divider(height: 1, color: Colors.black45),
                  RadioListTile<String>(
                    title: const Text('Full Scan', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: const Text('Deep scan including service versions & scripts.'),
                    value: 'Full',
                    groupValue: _scanType,
                    activeColor: const Color(0xFFC6FF00),
                    onChanged: (value) {
                      setState(() => _scanType = value!);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 48),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isStarting ? null : _startScan,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC6FF00),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isStarting
                    ? const SizedBox(
                        height: 24,
                        width: 24,
                        child: CircularProgressIndicator(strokeWidth: 3, color: Colors.black),
                      )
                    : const Text('START SCAN', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
