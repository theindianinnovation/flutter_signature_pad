import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';

class SignaturePreviewPage extends StatelessWidget {
  final Uint8List signature;

  const SignaturePreviewPage({
    Key key,
    @required this.signature,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Colors.black,
    appBar: AppBar(
      leading: CloseButton(),
      title: Text('Store Signature'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.done),
          onPressed: () => storeSignature(context),
        ),
        const SizedBox(width: 8),
      ],
    ),
    body: Center(
      child: Image.memory(signature, width: double.infinity),
    ),
  );

  Future storeSignature(BuildContext context) async {
    final status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    final time = DateTime.now().toIso8601String().replaceAll('.', ':');
    final name = 'signature_$time.png';

    final result = await ImageGallerySaver.saveImage(signature, name: name);
    final isSuccess = result['isSuccess'];
    print(result);

    if (isSuccess) {
      Navigator.pop(context);
      print("Save");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Saved to signature folder!"),));

    } else {
      print("Fail");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content:Text( "Failed to to save!!"),));

    }
  }
}
