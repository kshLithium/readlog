// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readlog/screens/reset_password_screen.dart';

void main() {
  testWidgets('ResetPasswordScreen UI test', (WidgetTester tester) async {
    // ResetPasswordScreen 위젯 빌드
    await tester.pumpWidget(const MaterialApp(
      home: ResetPasswordScreen(),
    ));

    // 앱바 타이틀 확인
    expect(find.text('비밀번호 재설정'), findsOneWidget);

    // 안내 텍스트 확인
    expect(find.text('새로운 비밀번호를 설정하세요.'), findsOneWidget);

    // 비밀번호 입력 필드 확인
    expect(find.text('새 비밀번호'), findsOneWidget);
    expect(find.text('비밀번호 확인'), findsOneWidget);

    // 텍스트필드 힌트 텍스트 확인
    expect(find.text('새 비밀번호를 입력해주세요'), findsOneWidget);
    expect(find.text('비밀번호를 다시 입력해주세요'), findsOneWidget);

    // 재설정 버튼 확인
    expect(find.text('비밀번호 재설정'), findsOneWidget);

    // 비밀번호 입력
    await tester.enterText(find.byType(TextField).first, 'newpassword123');
    await tester.enterText(find.byType(TextField).last, 'newpassword123');

    // 재설정 버튼 탭
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    // 스낵바 메시지 확인
    expect(find.text('비밀번호가 재설정되었습니다.'), findsOneWidget);
  });
}
