import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

const String imagekitApiBaseUrl = 'https://upload.imagekit.io/api';

Future<String> uploadCollectionAvatar({
  String folder = "/Hollama/Collections/Avatars",
  required String fileName,
  bool overwriteCustomMetadata = true,
  bool isPrivateFile = false,
  bool isPublished = true,
  bool useUniqueFileName = true,
  bool overwriteFile = true,
  bool overwriteTags = true,
  bool overwriteAITags = true,
  required File file,
  required String token,
}) async {
  final url = Uri.parse('$imagekitApiBaseUrl/v2/files/upload');

  try {
    var request = http.MultipartRequest('POST', url);
    request.fields['folder'] = folder;
    request.fields['fileName'] = fileName;
    request.fields['overwriteCustomMetadata'] =
        overwriteCustomMetadata.toString();
    request.fields['isPrivateFile'] = isPrivateFile.toString();
    request.fields['isPublished'] = isPublished.toString();
    request.fields['useUniqueFileName'] = useUniqueFileName.toString();
    request.fields['overwriteFile'] = overwriteFile.toString();
    request.fields['overwriteTags'] = overwriteTags.toString();
    request.fields['overwriteAITags'] = overwriteAITags.toString();
    request.fields['token'] = token;

    // 添加文件
    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    // 发送请求
    final response = await request.send();
    if (response.statusCode == 200) {
      final responseBody = await response.stream.bytesToString();
      final responseData = json.decode(responseBody);
      return responseData['url'];
    } else {
      throw Exception('Failed to upload file');
    }
  } catch (error) {
    print(error);
    rethrow;
  }
}

Future<String> uploadAvatar({
  required File file,
  required String token,
}) async {
  final String fileName = file.path.split('/').last;
  final String imageKitToken = await getImageKitToken(token, fileName);

  return await uploadCollectionAvatar(
    fileName: fileName,
    file: file,
    token: imageKitToken,
  );
}

Future<String> getImageKitToken(String token, String fileName) async {
  final url = Uri.parse(
      'http://0.0.0.0:8006/api/upload/imagekit/token?file_name=$fileName');

  final response = await http.get(
    url,
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    final responseBody = json.decode(response.body);
    if (responseBody['status']) {
      return responseBody['token'];
    } else {
      throw Exception('Failed to get token: ${responseBody['message']}');
    }
  } else {
    throw Exception('Failed to get token: ${response.statusCode}');
  }
}
