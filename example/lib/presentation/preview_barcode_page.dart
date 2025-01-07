import 'package:flutter/material.dart';

class PreviewBarcodePage extends StatefulWidget {
  final String barcodeRawValue;
  const PreviewBarcodePage({super.key, required this.barcodeRawValue,});

  @override
  State<PreviewBarcodePage> createState() => _PreviewBarcodePageState();
}

class _PreviewBarcodePageState extends State<PreviewBarcodePage> {

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {

    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: const Text("Preview Image", style: TextStyle(color: Colors.black)),
      ),
      body: Center(
        child: Text(widget.barcodeRawValue),
      ),
    );
  }
}
