import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

extension FileStorageUtils on File {

  Future<String> uploadFileToFirebase(String imagePath) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    final UploadTask uploadTask = ref.putFile(this);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }

  // Future<String> uploadFileToAWS({required String uniqueUploadKey}) async {
  //   try {
  //     final UploadFileResult result = await Amplify.Storage.uploadFile(
  //         local: this,
  //         key: uniqueUploadKey,
  //         onProgress: (progress) {
  //           print('Fraction completed: ${progress.getFractionCompleted()}');
  //         });
  //     print('Successfully uploaded file: ${result.key}');
  //     return "https://flutterskeletond512d4c16f8d4090befd5fcb60f89d46162806-dev.s3.ap-south-1.amazonaws.com/public/$uniqueUploadKey";
  //
  //     // final GetUrlResult downloadUrl = await Amplify.Storage.getUrl(key: uniqueUploadKey);
  //     // return downloadUrl.url;
  //   } on StorageException catch (e) {
  //     print('Error uploading file: $e');
  //     return "";
  //   }
  // }
}

 void downloadFile(String url) async {

   final downloadsDirectory = await getExternalStorageDirectory();
   final downloadsPath = downloadsDirectory!.path;

   final response = await HttpClient().getUrl(Uri.parse(url));
   final httpClientRequest = await response.close();

   final file = File('$downloadsPath/image.jpg');

   await file.writeAsBytes(await httpClientRequest.expand((chunk) => chunk).toList());

   // print('Image downloaded successfully!${file.path}');
}

extension BytesStorageUtils on Uint8List {
  Future<String> uploadBytesToFirebase(
    String imagePath, {
    SettableMetadata? settableMetadata,
  }) async {
    Reference ref = FirebaseStorage.instance.ref().child(imagePath);
    final UploadTask uploadTask = ref.putData(this, settableMetadata);
    var downloadUrl = await (await uploadTask).ref.getDownloadURL();
    return downloadUrl;
  }
  // Future<String> uploadBytesToAWS({required String uniqueUploadKey}) async {
  //   final tempDir = await getTemporaryDirectory();
  //   File uploadFile = File('${tempDir.path}/$uniqueUploadKey')
  //     ..createSync()
  //     ..writeAsBytesSync(this);
  //   try {
  //     final UploadFileResult result = await Amplify.Storage.uploadFile(
  //         local: uploadFile,
  //         key: uniqueUploadKey,
  //         onProgress: (progress) {
  //           print('Fraction completed: ${progress.getFractionCompleted()}');
  //         });
  //     print('Successfully uploaded file: ${result.key}');
  //     // final GetUrlResult downloadUrl = await Amplify.Storage.getUrl(key: uniqueUploadKey);
  //     return "https://flutterskeletond512d4c16f8d4090befd5fcb60f89d46162806-dev.s3.ap-south-1.amazonaws.com/public/$uniqueUploadKey";
  //   } on StorageException catch (e) {
  //     print('Error uploading file: $e');
  //     return "";
  //   }
  // }
}
