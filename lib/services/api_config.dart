import 'package:cloud_firestore/cloud_firestore.dart';

class ApiConfig {
  static String? _clientId;
  static String? _clientSecret;
  static String? _imgbbApiKey;

  static Future<void> initialize() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('api_keys')
          .get();

      _clientId = doc.data()?['naver_client_id'];
      _clientSecret = doc.data()?['naver_client_secret'];
      _imgbbApiKey = doc.data()?['img_api_key'];
    } catch (e) {
      rethrow;
    }
  }

  static Map<String, String> getNaverApiKeys() {
    if (_clientId == null || _clientSecret == null) {
      throw Exception('네이버 API 키가 초기화되지 않았습니다.');
    }
    return {
      'clientId': _clientId!,
      'clientSecret': _clientSecret!,
    };
  }

  static String getImgbbApiKey() {
    if (_imgbbApiKey == null) {
      throw Exception('imgBB API 키가 초기화되지 않았습니다.');
    }
    return _imgbbApiKey!;
  }
}
