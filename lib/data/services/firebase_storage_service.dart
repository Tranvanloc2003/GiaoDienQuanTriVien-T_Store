import 'dart:io';
import 'dart:typed_data';
import 'package:admin_panel/utils/exceptions/firebase_exceptions.dart';
import 'package:admin_panel/utils/exceptions/format_exceptions.dart';
import 'package:admin_panel/utils/exceptions/platform_exceptions.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get_core/get_core.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:image_picker/image_picker.dart';

class TFirebaseStorageService extends GetxController {
  static TFirebaseStorageService get instance => Get.find();

  final _firebaseStorage = FirebaseStorage.instance;

  // Update this method to handle both web and mobile platforms
  Future<Uint8List> getImageDataFromAssets(String path) async {
    try {
      if (kIsWeb) {
        // For web, if path starts with 'blob:', it's a blob URL
        if (path.startsWith('blob:')) {
          // Convert blob URL to bytes using an HTTP request
          final response = await HttpClient().getUrl(Uri.parse(path));
          final HttpClientResponse responseData = await response.close();
          final bytes = await responseData.cast<List<int>>().toList();
          return Uint8List.fromList(bytes.expand((x) => x).toList());
        }
      }
      // For other cases (mobile or local assets)
      final data = await rootBundle.load(path);
      return data.buffer.asUint8List();
    } catch (e) {
      print('Error loading image data: $e');
      throw 'Error loading image data: $e';
    }
  }

  // Update upload method to handle both web and mobile
  Future<String> taiHinhAnhData(String path, Uint8List data, String name) async {
    try {
      final ref = _firebaseStorage.ref(path).child(name);
      
      // Upload the file
      final TaskSnapshot uploadTask = await ref.putData(
        data,
        SettableMetadata(
          contentType: 'image/jpeg', // You can adjust content type as needed
        ),
      );

      // Get download URL
      final String downloadUrl = await uploadTask.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      print('Error uploading image: $e');
      throw 'Error uploading image: $e';
    }
  }

  //Returns the download urlof the uploadede image
  Future<String> taiHinhAnhFile(String path, XFile image) async {
    try {
      // Tạo reference đến storage với path
      final ref = _firebaseStorage.ref(path).child(DateTime.now().millisecondsSinceEpoch.toString());
      
      // Upload file
      if (kIsWeb) {
        // Xử lý cho web
        final imageBytes = await image.readAsBytes();
        final uploadTask = await ref.putData(
          imageBytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        return await uploadTask.ref.getDownloadURL();
      } else {
        // Xử lý cho mobile
        final file = File(image.path);
        final uploadTask = await ref.putFile(file);
        return await uploadTask.ref.getDownloadURL();
      }
    } catch (e) {
      throw 'Không thể tải ảnh lên: $e';
    }
  }
}
