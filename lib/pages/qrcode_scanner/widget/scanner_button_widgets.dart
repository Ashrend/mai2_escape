import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:oktoast/oktoast.dart';

class AnalyzeImageFromGalleryButton extends StatelessWidget {
  final void Function(BarcodeCapture) onQRCodeScanned;

  const AnalyzeImageFromGalleryButton({
    super.key,
    required this.controller,
    required this.onQRCodeScanned,
  });

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          color: Colors.white,
          icon: const Icon(Icons.image),
          style: IconButton.styleFrom(
            backgroundColor:
                Theme.of(context).colorScheme.onInverseSurface.withAlpha(128),
          ),
          padding: const EdgeInsets.all(12),
          iconSize: 28,
          onPressed: () async {
            final ImagePicker picker = ImagePicker();

            final XFile? image = await picker.pickImage(
              source: ImageSource.gallery,
            );

            if (image == null) {
              return;
            }

            final BarcodeCapture? barcodes = await controller.analyzeImage(
              image.path,
            );

            if (!context.mounted) {
              return;
            }

            if (barcodes == null) {
              showToast('未发现二维码');
              return;
            }

            onQRCodeScanned(barcodes);
          },
        ),
        const SizedBox(height: 8),
        const Text('相册'),
      ],
    );
  }
}

class ToggleFlashlightButton extends StatelessWidget {
  const ToggleFlashlightButton({required this.controller, super.key});

  final MobileScannerController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, state, child) {
        if (!state.isInitialized || !state.isRunning) {
          return const SizedBox.shrink();
        }

        switch (state.torchState) {
          case TorchState.off:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onInverseSurface
                        .withAlpha(128),
                  ),
                  padding: const EdgeInsets.all(12),
                  iconSize: 28,
                  icon: const Icon(Icons.flash_off),
                  onPressed: () async {
                    await controller.toggleTorch();
                  },
                ),
                const SizedBox(height: 8),
                const Text('打开闪光灯'),
              ],
            );
          case TorchState.on:
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  color: Colors.white,
                  style: IconButton.styleFrom(
                    backgroundColor: Theme.of(context)
                        .colorScheme
                        .onInverseSurface
                        .withAlpha(128),
                  ),
                  padding: const EdgeInsets.all(12),
                  iconSize: 28,
                  icon: const Icon(Icons.flash_on),
                  onPressed: () async {
                    await controller.toggleTorch();
                  },
                ),
                const SizedBox(height: 8),
                const Text('关闭闪光灯'),
              ],
            );
          case TorchState.unavailable:
            return const SizedBox.shrink();
        }
      },
    );
  }
}
