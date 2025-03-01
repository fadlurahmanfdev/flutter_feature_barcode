import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'flutter_feature_barcode_platform_interface.dart';

/// An implementation of [FlutterFeatureBarcodePlatform] that uses method channels.
class MethodChannelFlutterFeatureBarcode extends FlutterFeatureBarcodePlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('flutter_feature_barcode');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
