// ignore_for_file: unrelated_type_equality_checks

library queue_control_flutter.util;

import 'dart:typed_data';
import 'dart:ui';

import 'package:blue_thermal_printer/blue_thermal_printer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

BluetoothDevice bluetoothDevice;
BlueThermalPrinter bluetooth = BlueThermalPrinter.instance;

backgroundWidget(context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
    decoration:
        const BoxDecoration(image: DecorationImage(image: AssetImage('assets/tdp-background.png'), fit: BoxFit.cover)),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
      ),
    ),
  );
}

logoWidget(context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 4,
    height: MediaQuery.of(context).size.height / 4,
    child: Image.asset('assets/tdp-logo.png'),
  );
}

supportWidget(context) {
  return SizedBox(
    width: MediaQuery.of(context).size.width / 4,
    height: MediaQuery.of(context).size.height / 4,
    child: Image.asset('assets/tdp-support.png'),
  );
}

printTicket(String category, number) async {
  ByteData bytesAsset = await rootBundle.load("assets/tdp-logo-print-bg.png");
  Uint8List imageBytesFromAsset = bytesAsset.buffer.asUint8List(bytesAsset.offsetInBytes, bytesAsset.lengthInBytes);

  bluetooth.printNewLine();
  bluetooth.printImageBytes(imageBytesFromAsset);
  bluetooth.printNewLine();
  bluetooth.printCustom('_______________________', 1, 1);
  bluetooth.printNewLine();
  bluetooth.printCustom(category, 3, 1);
  bluetooth.printNewLine();
  bluetooth.printCustom('ANTRIAN NOMOR', 2, 1);
  bluetooth.printNewLine();
  bluetooth.printCustom('0$number', 4, 1);
  bluetooth.printNewLine();
  bluetooth.printCustom('_______________________', 1, 1);
  bluetooth.printNewLine();
  bluetooth.printNewLine();
}
