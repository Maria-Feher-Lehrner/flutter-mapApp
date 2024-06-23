import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

Future<String?> scanQrCode(BuildContext context) async {
  return await Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => QrScannerWidget()),
  );
}

class QrScannerWidget extends StatefulWidget {
  @override
  _QrScannerWidgetState createState() => _QrScannerWidgetState();
}

class _QrScannerWidgetState extends State<QrScannerWidget> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen((barcode) {
      if (barcode != null) {
        _handleBarcode(barcode);
      }
    });

    controller.start();
  }

  @override
  void dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    await _subscription?.cancel();
    await controller.dispose();
    super.dispose();
  }

  void _handleBarcode(Barcode barcode) {
    final String code = barcode.rawValue ?? '---';
    Navigator.pop(context, code);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen(_handleBarcode);
        controller.start();
        break;
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        _subscription?.cancel();
        controller.stop();
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Scanner'),
      ),
      body: MobileScanner(
        controller: controller,
        fit: BoxFit.cover,
      ),
    );
  }
}
