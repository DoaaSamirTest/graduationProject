import 'dart:async';
import 'package:flutter/material.dart';

class ControlPanel extends StatefulWidget {
  final Future<void> Function(String) sendCommand;
  final bool isPickingMedicine;
  final Future<void> Function() pickMedicine;
  final Future<void> Function()? sendHttpTest;

  const ControlPanel({
    super.key,
    required this.sendCommand,
    required this.isPickingMedicine,
    required this.pickMedicine,
    this.sendHttpTest,
  });

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  Timer? _repeatTimer;

  void _startSending(String command) {
    widget.sendCommand(command); // أول مرة فورًا
    _repeatTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      widget.sendCommand(command);
    });
  }

  void _stopSending() {
    _repeatTimer?.cancel();
    _repeatTimer = null;
    widget.sendCommand('S'); // أمر التوقف
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required String command,
  }) {
    return GestureDetector(
      onTapDown: (_) => _startSending(command),
      onTapUp: (_) => _stopSending(),
      onTapCancel: () => _stopSending(),
      child: Icon(icon, size: 50, color: Colors.blue),
    );
  }

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
                    widget.isPickingMedicine
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

            // زرار للأمام
            _buildDirectionButton(icon: Icons.arrow_upward, command: 'F'),

            // لليسار + لليمين
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildDirectionButton(icon: Icons.arrow_back, command: 'L'),
                const SizedBox(width: 60),
                _buildDirectionButton(icon: Icons.arrow_forward, command: 'R'),
              ],
            ),

            // زرار للخلف
            _buildDirectionButton(icon: Icons.arrow_downward, command: 'B'),

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 80),
                child: ElevatedButton(
                  onPressed:
                      widget.isPickingMedicine ? null : widget.pickMedicine,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (widget.isPickingMedicine) ...[
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
                          widget.isPickingMedicine
                              ? 'جارٍ التقاط الدواء...'
                              : 'التقاط الدواء تلقائياً',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
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
