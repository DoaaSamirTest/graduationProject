import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:gproject/models/medicine.dart';
import 'package:gproject/utils/http_test_service.dart';

class ControlPanel extends StatefulWidget {
  final Future<void> Function(String) sendCommand;
  final bool isPickingMedicine;
  final Future<void> Function() pickMedicine;
  final Future<void> Function()? sendHttpTest;
  final Medicine medicine;

  const ControlPanel({
    super.key,
    required this.sendCommand,
    required this.isPickingMedicine,
    required this.pickMedicine,
    required this.medicine,
    this.sendHttpTest,
  });

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  Timer? _repeatTimer;
  late Medicine _medicine;
  bool _isAutoDriving = false;

  void _startSending(String command) {
    if (_isAutoDriving) return; // Disable manual controls during auto-driving
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

  void _autoDriving() {
    setState(() {
      _isAutoDriving = true;
    });
    _repeatTimer?.cancel();
    _repeatTimer = null;
    widget.sendCommand('A'); // أمر التحرك التلقائي
  }

  void _stopAutoDriving() {
    setState(() {
      _isAutoDriving = false;
    });
    widget.sendCommand('S'); // إرسال أمر التوقف
  }

  Widget _buildDirectionButton({
    required IconData icon,
    required String command,
  }) {
    return GestureDetector(
      onTapDown: (_) => _startSending(command),
      onTapUp: (_) => _stopSending(),
      onTapCancel: () => _stopSending(),
      child: Icon(
        icon,
        size: 50,
        color: _isAutoDriving ? Colors.grey : Colors.blue,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    _medicine = widget.medicine;
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
              child: Mjpeg(
                isLive: true,
                stream: 'http://192.168.218.190:5000/video_feed',
                error: (context, error, stack) {
                  debugPrint("MJPEG Error: $error");
                  return Center(child: Text("MJPEG Error: $error"));
                },
                fit: BoxFit.cover,
                timeout: const Duration(seconds: 30),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "لوحة التحكم بالعربية",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // زرار للأمام
            if (!_isAutoDriving) ...[
              _buildDirectionButton(icon: Icons.arrow_upward, command: 'F'),
            ],

            // لليسار + لليمين
            if (!_isAutoDriving) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildDirectionButton(icon: Icons.arrow_back, command: 'L'),
                  const SizedBox(width: 60),
                  _buildDirectionButton(
                    icon: Icons.arrow_forward,
                    command: 'R',
                  ),
                ],
              ),
            ],

            // زرار للخلف
            if (!_isAutoDriving) ...[
              _buildDirectionButton(icon: Icons.arrow_downward, command: 'B'),
            ],

            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: 80),
                child: ElevatedButton(
                  onPressed: _isAutoDriving ? null : _autoDriving,
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
                        if (_isAutoDriving) ...[
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
                          _isAutoDriving ? "جار التحرك ..." : 'التحرك التلقائي',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            if (_isAutoDriving) ...[
              const SizedBox(height: 10),
              ElevatedButton.icon(
                onPressed: _stopAutoDriving,
                icon: Icon(Icons.stop_circle),
                label: Text("إيقاف التحرك التلقائي"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],

            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () async {
                await HttpTestService.sendMedicineNameToServer(
                  context,
                  _medicine.name,
                );
              },
              icon: Icon(Icons.send),
              label: Text('إرسال اسم الدواء'),
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
