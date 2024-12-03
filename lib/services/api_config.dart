import 'package:cloud_firestore/cloud_firestore.dart';

class ApiConfig {
  static String? _clientId;
  static String? _clientSecret;

  static Future<void> initialize() async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('config')
          .doc('api_keys')
          .get();

      _clientId = doc.data()?['naver_client_id'];
      _clientSecret = doc.data()?['naver_client_secret'];

      // 디버깅을 위한 출력
      print('API 키 로딩 성공: $_clientId, $_clientSecret');
    } catch (e) {
      print('API 키 로딩 실패: $e');
      // 에러를 다시 던져서 호출하는 쪽에서 처리할 수 있게 함
      rethrow;
    }
  }

  static Map<String, String> getApiKeys() {
    if (_clientId == null || _clientSecret == null) {
      throw Exception('API 키가 초기화되지 않았습니다.');
    }
    return {
      'clientId': _clientId!,
      'clientSecret': _clientSecret!,
    };
  }
}
