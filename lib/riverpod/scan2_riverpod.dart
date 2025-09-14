
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:camera/camera.dart';
import '../features/shared/providers/riverpod_providers.dart';

class Scan2Page extends ConsumerWidget {
  const Scan2Page({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final camAsync = ref.watch(cameraControllerProvider);
    return camAsync.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (e, _) => Scaffold(body: Center(child: Text('Camera error: $e'))),
      data: (cam) {
        final controller = cam.controller;
        if (controller == null || !cam.isInitialized) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }
        return Scaffold(
          appBar: AppBar(title: const Text('Scan v2')),
          body: Stack(
            fit: StackFit.expand,
            children: [
              CameraPreview(controller),
              Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () => ref.read(cameraControllerProvider.notifier).toggleTorch(),
                        icon: Icon(cam.isTorchOn ? Icons.flash_on : Icons.flash_off),
                        label: Text(cam.isTorchOn ? 'Matikan Flash' : 'Nyalakan Flash'),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
