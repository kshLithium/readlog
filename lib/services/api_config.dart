import 'package:cloud_firestore/cloud_firestore.dart';

class ApiConfig {
  static String? _clientId;
  static String? _clientSecret;

  static Future<void> initialize() async {
    if (_clientId != null && _clientSecret != null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('api_keys')
          .get();

      _clientId = doc.data()?['naver_client_id'];
      _clientSecret = doc.data()?['naver_client_secret'];
    } catch (e) {
      print('API 키 로딩 실패: $e');
    }
  }

  static Map<String, String> getApiKeys() {
    return {
      'clientId': _clientId ?? '',
      'clientSecret': _clientSecret ?? '',
    };
  }
}
