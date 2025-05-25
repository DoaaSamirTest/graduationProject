import 'package:flutter/material.dart';

/// Widget for the robot control panel and medicine picking button.
class ControlPanel extends StatelessWidget {
  final Future<void> Function(String) sendCommand;
  final bool isPickingMedicine;
  final Future<void> Function() pickMedicine;
  const ControlPanel({
    super.key,
    required this.sendCommand,
    required this.isPickingMedicine,
    required this.pickMedicine,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 200,
              width: double.infinity,
              color: Colors.grey.shade300,
              child: Center(
                child:
                    isPickingMedicine
                        ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Colors.blue),
                            SizedBox(height: 16),
                            Text(
                              'جارٍ التقاط الدواء...',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        )
                        : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.videocam, size: 48, color: Colors.grey),
                            SizedBox(height: 8),
                            Text(
                              'كاميرا العربية',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
              ),
            ),
            const Spacer(),
            const Text(
              "لوحة التحكم بالعربية",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            IconButton(
              icon: const Icon(Icons.arrow_upward, size: 50),
              color: Colors.blue,
              onPressed: () => sendCommand('F'),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, size: 50),
                  color: Colors.blue,
                  onPressed: () => sendCommand('L'),
                ),
                const SizedBox(width: 60),
                IconButton(
                  icon: const Icon(Icons.arrow_forward, size: 50),
                  color: Colors.blue,
                  onPressed: () => sendCommand('R'),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.arrow_downward, size: 50),
              color: Colors.blue,
              onPressed: () => sendCommand('B'),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ElevatedButton(
                onPressed: isPickingMedicine ? null : pickMedicine,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isPickingMedicine) ...[
                        SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        ),
                        SizedBox(width: 8),
                      ],
                      Icon(Icons.psychology),
                      SizedBox(width: 8),
                      Text(
                        isPickingMedicine
                            ? 'جارٍ التقاط الدواء...'
                            : 'التقاط الدواء تلقائياً',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
