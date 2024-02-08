
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:tulip_app/util/context_util_ext.dart';
import 'package:tulip_app/util/extensions.dart';

class ZoomInImagePage extends StatefulWidget {
  final dynamic imagePath;
  const ZoomInImagePage({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<ZoomInImagePage> createState() => _ZoomInImagePageState();
}

class _ZoomInImagePageState extends State<ZoomInImagePage> {
   Future<File>? _imageFile;
   String? _networkImageUrl;

   @override
  void initState() {
    super.initState();
    if (widget.imagePath.runtimeType.toString() == "Asset") {
      _loadImage();
    } else {
      _networkImageUrl = widget.imagePath;
    }
   }

  Future<void> _loadImage() async {
    // Get the path where the asset will be saved temporarily
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;

    // Save the asset to the temporary path
    var asset = widget.imagePath;
    ByteData byteData = await asset.getByteData();
    List<int> imageData = byteData.buffer.asUint8List();
    String imagePath = '$tempPath/${asset.name}';
    File imageFile = File(imagePath);
    await imageFile.writeAsBytes(imageData);

    setState(() {
      _imageFile = Future.value(imageFile);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black38,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          child: Stack(
            children: [
              Center(
                child: _networkImageUrl ==null ?FutureBuilder<File>(
                  future: _imageFile,
                  builder: (context, snapshot) {
                    if (snapshot.data != null) {
                      return SizedBox(
                        height: 50.h, // Adjust the height as needed
                        child: PhotoView(
                          imageProvider: FileImage(snapshot.data!),
                          heroAttributes: PhotoViewHeroAttributes(
                            tag: widget.imagePath.hashCode.toString(),
                          ),
                        ),
                      );
                    } else {
                      return const CircularProgressIndicator(); // Loading indicator
                    }
                  },
                ) : SizedBox(
                  height: 50.h, // Adjust the height as needed
                  child: PhotoView(
                    // enableRotation: true,
                    imageProvider: NetworkImage(_networkImageUrl!),
                    heroAttributes: PhotoViewHeroAttributes(
                      tag: widget.imagePath.hashCode.toString(),
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: (){
                  context.pop();
                },
                child: Container(
                  margin: EdgeInsets.only(top: 7.h,right: 3.h),
                  alignment: Alignment.topRight,
                  child: Icon(Icons.close,
                  size: 30,color: Colors.white),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
