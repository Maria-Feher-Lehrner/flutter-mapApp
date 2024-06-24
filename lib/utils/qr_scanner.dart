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
  QrScannerWidgetState createState() => QrScannerWidgetState();
}

class QrScannerWidgetState extends State<QrScannerWidget> with WidgetsBindingObserver {
  final MobileScannerController controller = MobileScannerController();
  StreamSubscription<BarcodeCapture>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = controller.barcodes.listen((BarcodeCapture barcodeCapture) {
      final List<Barcode> barcodes = barcodeCapture.barcodes;
      if (barcodes.isNotEmpty) {
        _handleBarcode(barcodes.first);
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
    print('QR Code scanned: $code'); // Add log

    final parts = code.split(';');
    if (parts.length == 3) {
      final latPart = parts[0].split('=');
      final lonPart = parts[1].split('=');
      if (latPart.length == 2 && lonPart.length == 2) {
        final lat = double.tryParse(latPart[1]);
        final lon = double.tryParse(lonPart[1]);
        final title = parts[2];
        if (lat != null && lon != null) {
          final location = '$lat:$lon:$title';
          print('Parsed location: $location'); // Add log
          Navigator.pop(context, location);
          return;
        }
      }
    }

    print('Failed to parse QR code'); // Add log
    Navigator.pop(context, null);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!controller.value.isInitialized) {
      return;
    }

    switch (state) {
      case AppLifecycleState.resumed:
        _subscription = controller.barcodes.listen((BarcodeCapture barcodeCapture) {
          final List<Barcode> barcodes = barcodeCapture.barcodes;
          if (barcodes.isNotEmpty) {
            _handleBarcode(barcodes.first);
          }
        });
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
