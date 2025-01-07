import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_feature_barcode/flutter_feature_barcode.dart';
import 'package:flutter_feature_barcode/flutter_feature_barcode_platform_interface.dart';
import 'package:flutter_feature_barcode/flutter_feature_barcode_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockFlutterFeatureBarcodePlatform
    with MockPlatformInterfaceMixin
    implements FlutterFeatureBarcodePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final FlutterFeatureBarcodePlatform initialPlatform = FlutterFeatureBarcodePlatform.instance;

  test('$MethodChannelFlutterFeatureBarcode is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelFlutterFeatureBarcode>());
  });

  test('getPlatformVersion', () async {
    FlutterFeatureBarcode flutterFeatureBarcodePlugin = FlutterFeatureBarcode();
    MockFlutterFeatureBarcodePlatform fakePlatform = MockFlutterFeatureBarcodePlatform();
    FlutterFeatureBarcodePlatform.instance = fakePlatform;

    expect(await flutterFeatureBarcodePlugin.getPlatformVersion(), '42');
  });
}
