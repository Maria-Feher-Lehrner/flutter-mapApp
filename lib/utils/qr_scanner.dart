import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerWidget extends StatefulWidget {

  final Function(String) onScanned;
  QrScannerWidget({required this.onScanned});

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

    final parts = code.split(':');
    if (parts.length == 3) {
      final latPart = parts[0].split('=');
      final lonPart = parts[1].split('=');
      if (latPart.length == 2 && lonPart.length == 2) {
        final lat = double.tryParse(latPart[1]);
        final lon = double.tryParse(lonPart[1]);
        final title = parts[2];

        if (lat != null && lon != null) {
          final location = '$lat:$lon:$title';
          widget.onScanned(location);
          Navigator.of(context).pop;
          return;
        }
      }
    }

    widget.onScanned('');
    Navigator.of(context).pop;
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
        title: const Text('QR Scanner'),
      ),
      body: MobileScanner(
        controller: controller,
        fit: BoxFit.cover,
      ),
    );
  }
}
