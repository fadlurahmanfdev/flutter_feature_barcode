export 'core/extension/camera_image_extension.dart';
export 'package:flutter_feature_barcode/flutter_feature_barcode.dart';
export 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_feature_barcode/core/extension/camera_image_extension.dart';
import 'package:flutter_feature_camera/camera.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import 'flutter_feature_barcode_platform_interface.dart';

class FlutterFeatureBarcode {
  static final _orientations = <DeviceOrientation, int>{
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  late BarcodeScanner _barcodeScanner;

  static InputImage? inputImageFromCameraImage(
      CameraImage cameraImage, {
        required int sensorOrientation,
        required DeviceOrientation deviceOrientation,
        required CameraLensDirection cameraLensDirection,
      }) {
    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    InputImageRotation rotation = InputImageRotation.rotation0deg;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation) ?? InputImageRotation.rotation0deg;
    } else if (Platform.isAndroid) {
      var rotationCompensation = _orientations[deviceOrientation];
      if (rotationCompensation == null) return null;
      if (cameraLensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation = (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation) ?? InputImageRotation.rotation0deg;
    }
    log("initialized rotation: $rotation");

    final nv21CameraImageBytes = cameraImage.getNv21Uint8List();

    // get image format
    final format = InputImageFormatValue.fromRawValue(cameraImage.format.raw);
    if (format == null) {
      log("failed to get format, format is null");
      return null;
    }

    final planes = cameraImage.planes;
    if (planes.isEmpty) {
      log("planes is empty");
      return null;
    }

    return InputImage.fromBytes(
      bytes: nv21CameraImageBytes,
      metadata: InputImageMetadata(
        size: Size(cameraImage.width.toDouble(), cameraImage.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: planes.first.bytesPerRow,
      ),
    );
  }

  void initialize(){
    final List<BarcodeFormat> formats = [BarcodeFormat.all];
    _barcodeScanner = BarcodeScanner(formats: formats);
  }

  Future<List<Barcode>> process(InputImage inputImage) async {
    return _barcodeScanner.processImage(inputImage);
  }

  Future<String?> getPlatformVersion() {
    return FlutterFeatureBarcodePlatform.instance.getPlatformVersion();
  }
}
