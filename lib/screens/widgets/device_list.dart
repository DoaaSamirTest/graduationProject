import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

/// Widget for listing Bluetooth devices and connect/disconnect buttons.
class DeviceList extends StatelessWidget {
  final List<BluetoothDevice> devicesList;
  final bool isConnected;
  final BluetoothDevice? selectedDevice;
  final bool isButtonEnabled;
  final bool isConnecting;
  final Function(BluetoothDevice) connect;
  final Function disconnect;
  const DeviceList({
    super.key,
    required this.devicesList,
    required this.isConnected,
    required this.selectedDevice,
    required this.isButtonEnabled,
    required this.isConnecting,
    required this.connect,
    required this.disconnect,
  });
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: devicesList.length,
      itemBuilder: (context, index) {
        final device = devicesList[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.bluetooth),
            title: Text(device.name ?? "اسم غير معروف"),
            subtitle: Text(device.address),
            trailing:
                isConnected && selectedDevice?.address == device.address
                    ? IconButton(
                      icon: const Icon(Icons.cable, color: Colors.green),
                      onPressed: () => disconnect(),
                    )
                    : ElevatedButton(
                      onPressed: isButtonEnabled ? () => connect(device) : null,
                      child:
                          isConnecting &&
                                  selectedDevice?.address == device.address
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                              : const Text("اتصال"),
                    ),
          ),
        );
      },
    );
  }
}
