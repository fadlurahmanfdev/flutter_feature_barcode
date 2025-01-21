import 'package:example/data/dto/model/feature_model.dart';
import 'package:example/presentation/barcode_scanner_page.dart';
import 'package:example/presentation/preview_barcode_page.dart';
import 'package:example/presentation/widget/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feature_barcode/flutter_feature_barcode.dart';
import 'package:image_picker/image_picker.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final picker = ImagePicker();
  final featureBarcode = FlutterFeatureBarcode();

  List<FeatureModel> features = [
    FeatureModel(
      title: 'Barcode Scanner',
      desc: 'Barcode Scanner',
      key: 'BARCODE_SCANNER',
    ),
    FeatureModel(
      title: 'Pick Image',
      desc: 'Pick Image',
      key: 'PICK_IMAGE',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      featureBarcode.initialize();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        itemCount: features.length,
        itemBuilder: (_, index) {
          final feature = features[index];
          return GestureDetector(
            onTap: () async {
              switch (feature.key) {
                case "BARCODE_SCANNER":
                  Navigator.of(context).push(MaterialPageRoute(builder: (_) => const BarcodeScannerPage()));
                  break;
                case "PICK_IMAGE":
                  picker.pickImage(source: ImageSource.gallery).then((xFile) {
                    if (xFile != null) {
                      featureBarcode.process(InputImage.fromFilePath(xFile.path)).then((barcodes) {
                        if (barcodes.isNotEmpty) {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (_) => PreviewBarcodePage(barcodeRawValue: barcodes.first.rawValue!)));
                        } else {
                          ScaffoldMessenger.of(context)
                              .showSnackBar(const SnackBar(content: Text('No barcode detected')));
                        }
                      });
                    }
                  });
                  break;
              }
            },
            child: ItemFeatureWidget(feature: feature),
          );
        },
      ),
    );
  }
}
