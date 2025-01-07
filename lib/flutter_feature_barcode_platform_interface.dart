import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'flutter_feature_barcode_method_channel.dart';

abstract class FlutterFeatureBarcodePlatform extends PlatformInterface {
  /// Constructs a FlutterFeatureBarcodePlatform.
  FlutterFeatureBarcodePlatform() : super(token: _token);

  static final Object _token = Object();

  static FlutterFeatureBarcodePlatform _instance = MethodChannelFlutterFeatureBarcode();

  /// The default instance of [FlutterFeatureBarcodePlatform] to use.
  ///
  /// Defaults to [MethodChannelFlutterFeatureBarcode].
  static FlutterFeatureBarcodePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [FlutterFeatureBarcodePlatform] when
  /// they register themselves.
  static set instance(FlutterFeatureBarcodePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
