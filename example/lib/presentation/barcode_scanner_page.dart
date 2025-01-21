import 'dart:developer';

import 'package:example/presentation/preview_barcode_page.dart';
import 'package:example/presentation/widget/camera_control_layout_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/system_chrome.dart';
import 'package:flutter_feature_barcode/flutter_feature_barcode.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:flutter_feature_camera/flutter_feature_camera.dart';

class BarcodeScannerPage extends StatefulWidget {
  const BarcodeScannerPage({super.key});

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> with BaseMixinFeatureCameraV2 {
  FlutterFeatureBarcode featureBarcode = FlutterFeatureBarcode();

  @override
  void initState() {
    super.initState();
    addListener(
      onFlashModeChanged: (flashMode) {
        setState(() {});
      },
    );
    initializeStreamingCamera(
      cameraLensDirection: CameraLensDirection.back,
      onCameraInitialized: onCameraInitialized,
      resolutionPreset: ResolutionPreset.medium,
      imageFormatGroup: ImageFormatGroup.yuv420,
      onCameraInitializedFailure: (exception) {},
    );
  }

  CameraController? cameraController;

  void onCameraInitialized(CameraController controller) {
    cameraController = controller;
    setState(() {});
    featureBarcode.initialize();
    startImageStream(onImageStream: onImageStream);
  }

  @override
  void dispose() {
    stopImageStream();
    disposeCamera();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Barcode Scanner", style: TextStyle(color: Colors.black)),
      ),
      body: Stack(
        children: [
          Container(
            alignment: Alignment.center,
            child: cameraController?.value.isInitialized == true ? CameraPreview(cameraController!) : Container(),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: CameraControlLayoutWidget(
              flashIcon: const Icon(Icons.flash_off),
              onFlashTap: onFlashTap,
              fetchImageGalleryIcon: Icon(Icons.image),
              onFetchImageGallery: onFetchImageGallery,
              switchCameraIcon: const Icon(Icons.autorenew),
              onSwitchCameraTap: onSwitchCameraTap,
            ),
          ),
        ],
      ),
    );
  }

  void onFetchImageGallery() {}

  void onFlashTap() {}

  void onSwitchCameraTap() {}

  double progress = 0.0;

  bool _isProcessingImage = false;

  Future<void> onImageStream(
    CameraImage cameraImage,
    int sensorOrientation,
    DeviceOrientation deviceOrientation,
    CameraLensDirection cameraLensDirection,
  ) async {
    if (!_isProcessingImage) {
      _isProcessingImage = true;
      await Future.delayed(Duration(seconds: 1));
      try {
        final inputImage = FlutterFeatureBarcode.inputImageFromCameraImage(
          cameraImage,
          sensorOrientation: sensorOrientation,
          deviceOrientation: deviceOrientation,
          cameraLensDirection: cameraLensDirection,
        );
        if (inputImage != null) {
          final barcodes = await featureBarcode.process(inputImage);
          Barcode? barcode;
          if (barcodes.isNotEmpty) {
            barcode = barcodes.first;
          }

          if (barcode != null) {
            stopImageStream();
            _isProcessingImage = false;
            _processBarcode(barcode);
          }
        }
      } catch (e) {
        log("failed process input image: $e");
      } finally {
        _isProcessingImage = false;
      }
    }
  }

  void _processBarcode(Barcode barcode) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (_) => PreviewBarcodePage(barcodeRawValue: barcode.rawValue ?? '-')))
        .then((value) {
      if (context.mounted) {
        startImageStream(onImageStream: onImageStream);
      }
    });
  }
}
