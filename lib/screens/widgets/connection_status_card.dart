import 'package:flutter/material.dart';
import 'dart:async';

/// Widget for showing the Bluetooth connection status.
class ConnectionStatusCard extends StatelessWidget {
  final StreamController<String> connectionStatusController;
  final StreamController<bool> isConnectedController;
  final bool isConnected;
  final String connectionStatus;
  const ConnectionStatusCard({
    super.key,
    required this.connectionStatusController,
    required this.isConnectedController,
    required this.isConnected,
    required this.connectionStatus,
  });
  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: StreamBuilder<String>(
          stream: connectionStatusController.stream,
          initialData: connectionStatus,
          builder: (context, snapshot) {
            return Row(
              children: [
                StreamBuilder<bool>(
                  stream: isConnectedController.stream,
                  initialData: isConnected,
                  builder: (context, connectedSnapshot) {
                    return Icon(
                      connectedSnapshot.data!
                          ? Icons.bluetooth_connected
                          : Icons.bluetooth_disabled,
                      color:
                          connectedSnapshot.data! ? Colors.green : Colors.red,
                    );
                  },
                ),
                const SizedBox(width: 10),
                Text(
                  snapshot.data!,
                  style: TextStyle(
                    color: isConnected ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
