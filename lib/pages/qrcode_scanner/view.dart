import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'controller.dart';
import 'widget/scanner_button_widgets.dart';
import 'widget/scanner_error_widget.dart';

class QRCodeScannerPage extends StatefulWidget {
  const QRCodeScannerPage({
    super.key,
  });

  @override
  State<QRCodeScannerPage> createState() => _QRCodeScannerPageState();
}

class _QRCodeScannerPageState extends State<QRCodeScannerPage>
    with WidgetsBindingObserver {
  final QRCodeScannerController controller =
      Get.find<QRCodeScannerController>();

  final MobileScannerController scannerController = MobileScannerController(
    torchEnabled: false,
    useNewCameraSelector: true,
    formats: [BarcodeFormat.qrCode],
  );
  StreamSubscription<Object?>? _subscription;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);

    _subscription = scannerController.barcodes.listen(_handleBarcode);

    unawaited(scannerController.start());
  }

  void _handleBarcode(BarcodeCapture barcodes) {
    if (mounted) {
      final barcode = barcodes.barcodes.firstOrNull;
      controller.onQRCodeScanned(barcode);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        _subscription = scannerController.barcodes.listen(_handleBarcode);

        unawaited(scannerController.start());
      case AppLifecycleState.inactive:
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(scannerController.stop());
    }
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    unawaited(_subscription?.cancel());
    _subscription = null;
    super.dispose();
    await scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('扫描二维码')),
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            controller: scannerController,
            errorBuilder: (context, error, child) {
              return ScannerErrorWidget(error: error);
            },
            fit: BoxFit.contain,
          ),
          Align(
            alignment: Alignment.center,
            child: Container(
              alignment: Alignment.bottomCenter,
              margin: EdgeInsets.only(bottom: Get.height * 0.16),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ToggleFlashlightButton(controller: scannerController),
                  const Spacer(),
                  AnalyzeImageFromGalleryButton(
                    controller: scannerController,
                    onQRCodeScanned: (BarcodeCapture barcodes) {
                      if (!mounted) {
                        return;
                      }
                      final barcode = barcodes.barcodes.firstOrNull;
                      controller.onQRCodeScanned(barcode);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
