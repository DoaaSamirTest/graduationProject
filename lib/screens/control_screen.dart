import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:permission_handler/permission_handler.dart'
    show
        FuturePermissionStatusGetters,
        Permission,
        PermissionActions,
        PermissionCheckShortcuts,
        openAppSettings;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import '../models/medicine.dart';
import 'widgets/connection_status_card.dart';
import 'widgets/device_list.dart';
import 'widgets/control_panel.dart';

class ControlScreen extends StatefulWidget {
  final Medicine? medicine;

  const ControlScreen({super.key, this.medicine});

  @override
  ControlScreenState createState() => ControlScreenState();
}

class ControlScreenState extends State<ControlScreen> {
  // Bluetooth variables
  BluetoothConnection? _connection;
  BluetoothDevice? _selectedDevice;
  List<BluetoothDevice> _devicesList = [];

  // UI state variables
  bool _isConnecting = false;
  bool _isDisconnecting = false;
  bool _isConnected = false;
  bool _isButtonEnabled = true;
  String _connectionStatus = "Not Connected";

  // Stream controllers
  final StreamController<String> _connectionStatusController =
      StreamController<String>.broadcast();
  final StreamController<bool> _isConnectedController =
      StreamController<bool>.broadcast();

  // Medicine picking state
  bool _isPickingMedicine = false;

  @override
  void initState() {
    super.initState();
    _initializeBluetooth();
    FlutterBluetoothSerial.instance.state.then((state) {
      setState(() {});
    });
    FlutterBluetoothSerial.instance.onStateChanged().listen((
      BluetoothState state,
    ) {
      setState(() {});
      if (state == BluetoothState.STATE_ON) {
        _getPairedDevices();
      }
    });
  }

  @override
  void dispose() {
    _connectionStatusController.close();
    _isConnectedController.close();
    _disconnect();
    super.dispose();
  }

  // =================== Bluetooth Logic ===================

  /// Initializes Bluetooth and requests permissions.
  Future<void> _initializeBluetooth() async {
    try {
      bool isAvailable =
          await FlutterBluetoothSerial.instance.isAvailable ?? false;
      if (!isAvailable) {
        _showToast("Bluetooth not available on this device");
        return;
      }
      bool hasPermissions = await _requestBluetoothPermissions();
      if (!hasPermissions) return;
      bool isEnabled = await FlutterBluetoothSerial.instance.isEnabled ?? false;
      if (!isEnabled) {
        bool enabled =
            await FlutterBluetoothSerial.instance.requestEnable() ?? false;
        if (!enabled) {
          _showToast("Bluetooth activation was canceled");
          return;
        }
        await Future.delayed(const Duration(seconds: 2));
      }
      await _getPairedDevices();
    } catch (e) {
      _showToast("Error initializing Bluetooth: \\${e.toString()}");
    }
  }

  /// Gets paired Bluetooth devices.
  Future<void> _getPairedDevices() async {
    try {
      bool hasPermissions = await _requestBluetoothPermissions();
      if (!hasPermissions) {
        _showToast("Bluetooth permissions denied");
        return;
      }
      List<BluetoothDevice> devices =
          await FlutterBluetoothSerial.instance.getBondedDevices();
      setState(() {
        _devicesList = devices;
      });
      if (_devicesList.isEmpty) {
        _showToast("No devices found. Please pair your device first");
      }
    } on PlatformException catch (e) {
      if (e.code == 'need_bluetooth_connect_permission') {
        _showToast("Please grant Bluetooth permissions in app settings");
        await openAppSettings();
      } else {
        _showToast("Bluetooth error: \\${e.message}");
      }
    } catch (e) {
      _showToast("Error getting paired devices: \\${e.toString()}");
      debugPrint("Error details: $e");
    }
  }

  /// Requests Bluetooth and location permissions.
  Future<bool> _requestBluetoothPermissions() async {
    try {
      if (await Permission.bluetoothConnect.request().isGranted &&
          await Permission.bluetoothScan.request().isGranted) {
        return true;
      }
      if (await Permission.location.request().isGranted) {
        return true;
      }
      if (await Permission.bluetoothConnect.isPermanentlyDenied ||
          await Permission.bluetoothScan.isPermanentlyDenied) {
        await openAppSettings();
      }
      return false;
    } catch (e) {
      debugPrint("Permission error: $e");
      return false;
    }
  }

  /// Connects to a Bluetooth device.
  Future<void> _connect(BluetoothDevice device) async {
    bool hasPermissions = await _requestBluetoothPermissions();
    if (!hasPermissions) {
      _showToast("Cannot connect without Bluetooth permissions");
      return;
    }
    if (_isConnecting || _isConnected) return;
    setState(() {
      _isConnecting = true;
      _isButtonEnabled = false;
      _connectionStatus = "Connecting...";
      _connectionStatusController.add(_connectionStatus);
    });
    try {
      _connection = await BluetoothConnection.toAddress(device.address);
      setState(() {
        _isConnected = true;
        _isConnecting = false;
        _selectedDevice = device;
        _connectionStatus = "Connected to \\${device.name}";
        _connectionStatusController.add(_connectionStatus);
        _isConnectedController.add(true);
      });
      _showToast("Successfully connected to \\${device.name}");
      _connection!.input!
          .listen((Uint8List data) {
            String incomingData = ascii.decode(data);
            debugPrint("Received: $incomingData");
          })
          .onDone(() {
            _disconnect();
          });
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _isButtonEnabled = true;
        _connectionStatus = "Connection failed";
        _connectionStatusController.add(_connectionStatus);
      });
      _showToast("Failed to connect: \\${e.toString()}");
    }
  }

  /// Disconnects from the Bluetooth device.
  Future<void> _disconnect() async {
    if (_connection == null || _isDisconnecting) return;
    setState(() {
      _isDisconnecting = true;
      _isButtonEnabled = false;
      _connectionStatus = "Disconnecting...";
      _connectionStatusController.add(_connectionStatus);
    });
    try {
      await _connection!.close();
      setState(() {
        _isConnected = false;
        _isDisconnecting = false;
        _isButtonEnabled = true;
        _connection = null;
        _selectedDevice = null;
        _connectionStatus = "Disconnected";
        _connectionStatusController.add(_connectionStatus);
        _isConnectedController.add(false);
      });
      _showToast("Disconnected successfully");
    } catch (e) {
      _showToast("Error disconnecting: \\${e.toString()}");
    }
  }

  /// Sends a command to the connected Bluetooth device.
  Future<void> _sendCommand(String command) async {
    if (!_isConnected || _connection == null) {
      _showToast("Not connected to any device");
      return;
    }
    try {
      _connection!.output.add(Uint8List.fromList(command.codeUnits));
      await _connection!.output.allSent;
      debugPrint("Command sent: $command");
    } catch (e) {
      _showToast("Failed to send command: \\${e.toString()}");
      _disconnect();
    }
  }

  /// Shows a toast message.
  void _showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black54,
      textColor: Colors.white,
    );
  }

  /// Simulates picking up medicine.
  Future<void> _pickMedicine() async {
    setState(() {
      _isPickingMedicine = true;
    });
    await Future.delayed(Duration(seconds: 3));
    setState(() {
      _isPickingMedicine = false;
    });
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('تم التقاط الدواء \\${widget.medicine?.name} بنجاح!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  // =================== UI ===================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("التحكم بالعربية"),
        elevation: 0,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _getPairedDevices,
            tooltip: "تحديث الأجهزة",
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ConnectionStatusCard(
              connectionStatusController: _connectionStatusController,
              isConnectedController: _isConnectedController,
              isConnected: _isConnected,
              connectionStatus: _connectionStatus,
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  _devicesList.isEmpty
                      ? const Center(
                        child: Text(
                          "لا توجد أجهزة\nيرجى إقران جهازك من إعدادات البلوتوث",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                      : _devicesList.isNotEmpty && !_isConnected
                      ? DeviceList(
                        devicesList: _devicesList,
                        isConnected: _isConnected,
                        selectedDevice: _selectedDevice,
                        isButtonEnabled: _isButtonEnabled,
                        isConnecting: _isConnecting,
                        connect: _connect,
                        disconnect: _disconnect,
                      )
                      : _isConnected
                      ? ControlPanel(
                        sendCommand: _sendCommand,
                        isPickingMedicine: _isPickingMedicine,
                        pickMedicine: _pickMedicine,
                      )
                      : const SizedBox(),
            ),
          ],
        ),
      ),
    );
  }
}
