import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerErrorWidget extends StatelessWidget {
  const ScannerErrorWidget({super.key, required this.error});

  final MobileScannerException error;

  @override
  Widget build(BuildContext context) {
    String errorMessage;

    switch (error.errorCode) {
      case MobileScannerErrorCode.controllerUninitialized:
        errorMessage = '扫描器未初始化';
      case MobileScannerErrorCode.permissionDenied:
        errorMessage = '未授权相机权限';
      case MobileScannerErrorCode.unsupported:
        errorMessage = '二维码扫描在此设备上不支持';
      default:
        errorMessage = '未知错误';
        break;
    }

    return ColoredBox(
      color: Colors.black,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 16),
              child: Icon(Icons.error, color: Colors.white),
            ),
            Text(
              errorMessage,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              error.errorDetails?.message ?? '',
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
