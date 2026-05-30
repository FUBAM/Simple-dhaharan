import 'package:dio/dio.dart';

import 'api_service.dart';

class UploadService {
  Future<String> uploadCover(String imagePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imagePath),
    });

    final response = await ApiService.dio.post('/upload/cover', data: formData);

    return response.data['image_url'];
  }

  Future<String> uploadStepImage(String imagePath) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(imagePath),
    });

    final response = await ApiService.dio.post('/upload/step', data: formData);

    return response.data['image_url'];
  }
}
