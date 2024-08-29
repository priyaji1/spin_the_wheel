import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:spin_game/main.dart' as app;
import 'package:spin_game/util/app_constant.dart';
import 'package:spin_game/util/common_widget.dart';
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  defineIntegrationTest();
}
const okButtonKey = ValueKey('OkButton');
void defineIntegrationTest() {
  testWidgets('app launch', (tester) async {
    app.main();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();

    // Wrap the ElevatedButton widget in a Scaffold for testing

    expect(find.text(AppConstants.spinNow), findsOneWidget); // Check if ElevatedButton exists

    await tester.tap(find.text(AppConstants.spinNow)); // Use the defined key here
    await tester.pump(const Duration(seconds: 10));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey(okButtonKey)));
  });
}
