import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:queue_control_flutter/view/display/display.dart';
import 'package:queue_control_flutter/view/operator/operator.dart';
import 'package:queue_control_flutter/view/take/take.dart';
import 'package:universal_io/io.dart';
import 'package:queue_control_flutter/utilities.dart' as util;
import 'package:flutter/foundation.dart' show kIsWeb;

class Dashboard extends StatefulWidget {
  const Dashboard({Key key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  BluetoothDevice bluetoothDevice;
  BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

  List<BluetoothDevice> _devices = [];
  bool _connected = false;

  getAndroidSdk() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.version.sdkInt ?? 30;
  }

  requestBluetoothAccess() async {
    if (Platform.isAndroid && !kIsWeb) {
      if (await getAndroidSdk() > 30) {
        await Permission.bluetooth.request().isGranted;
        await Permission.bluetoothConnect.request().isGranted;
        await Permission.bluetoothScan.request().isGranted;
        await Permission.camera.request().isGranted;
        await Permission.locationWhenInUse.request().isGranted;
      } else {
        await Permission.bluetooth.request().isGranted;
        await Permission.camera.request().isGranted;
        await Permission.locationWhenInUse.request().isGranted;
      }
      if (!mounted) return;
      setState(() {
        bluetoothDevice = util.bluetoothDevice;
      });
      initPlatformState();
    }
  }

  initPlatformState() async {
    bool isConnected = await bluetooth.isConnected;
    List<BluetoothDevice> devices = [];
    try {
      devices = await bluetooth.getBondedDevices();
    } on PlatformException {
      return;
    }

    if (!mounted) return;
    setState(() {
      _devices = devices;
    });

    if (isConnected == true) {
      setState(() {
        _connected = true;
      });
    }
  }

  _connect() {
    if (bluetoothDevice != null) {
      bluetooth.connect(bluetoothDevice).then((value) {
        if (value == true) {
          setState(() => _connected = true);
          util.bluetoothDevice = bluetoothDevice;
          show('Connected.');
        } else {
          show('Failed Connected.');
        }
      });
    } else {
      show('No device selected.');
    }
  }

  _disconnect() {
    bluetooth.disconnect().then((value) {
      if (value == true) {
        setState(() => _connected = false);
        show('Disconnected.');
      } else {
        show('Failed Disconnected.');
      }
    });
  }

  List<DropdownMenuItem<BluetoothDevice>> _getDeviceItems() {
    List<DropdownMenuItem<BluetoothDevice>> items = [];
    if (_devices.isEmpty) {
      items.add(const DropdownMenuItem(
        child: Text('NONE'),
      ));
    } else {
      for (var device in _devices) {
        items.add(DropdownMenuItem(
          child: Text(device.name ?? ""),
          value: device,
        ));
      }
    }
    return items;
  }

  show(
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) async {
    await Future.delayed(const Duration(milliseconds: 100));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        duration: duration,
      ),
    );
  }

  @override
  void initState() {
    requestBluetoothAccess();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          util.backgroundWidget(context),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              util.logoWidget(context),
              bodyWidget(),
              util.supportWidget(context),
            ],
          ),
        ],
      ),
    );
  }

  bodyWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text("Display Antrian"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Display()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          child: const Text("Operator Antrian"),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Operator()),
            );
          },
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          child: const Text("Ambil Antrian"),
          onPressed: () async {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Take()),
            );
          },
        ),
        (Platform.isAndroid && !kIsWeb)
            ? Column(
                children: [
                  const SizedBox(height: 32),
                  const Text(
                    'BLUETOOTH PRINTER SETTING',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text('Device:'),
                      const SizedBox(width: 16),
                      DropdownButton(
                        items: _getDeviceItems(),
                        onChanged: (BluetoothDevice value) => setState(() => bluetoothDevice = value),
                        value: bluetoothDevice,
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.brown),
                        onPressed: () {
                          initPlatformState();
                        },
                        child: const Text(
                          'Refresh',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: _connected ? Colors.red : Colors.green),
                        onPressed: _connected ? _disconnect : _connect,
                        child: Text(
                          _connected ? 'Disconnect' : 'Connect',
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              )
            : const SizedBox(),
      ],
    );
  }
}
