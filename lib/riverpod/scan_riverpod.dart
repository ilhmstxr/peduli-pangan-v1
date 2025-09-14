
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../features/shared/providers/riverpod_providers.dart';

class ScanPage extends ConsumerWidget {
  const ScanPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camAsync = ref.watch(cameraControllerProvider);
    return camAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, st) => Scaffold(body: Center(child: Text('Camera error: $e'))),
      data: (cam) {
        final controller = cam.controller;
        if (controller == null || !cam.isInitialized) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () => ref.read(cameraControllerProvider.notifier).toggleTorch(),
                        icon: Icon(cam.isTorchOn ? Icons.flash_on : Icons.flash_off),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          // TODO: trigger AI scan action via another AsyncNotifier
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Scan triggered (wire up to your AI logic).')),
                          );
                        },
                        child: const Icon(Icons.qr_code_scanner),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
