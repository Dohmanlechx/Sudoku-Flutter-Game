// import 'package:flutter_driver/flutter_driver.dart';
// import 'package:test/test.dart';
//
// /// To run, write this in the terminal:
//
// /// flutter drive --target=test_driver/app.dart
//
// void main() {
//   group('App Integration Tests', () {
//     FlutterDriver? driver;
//
//     setUpAll(() async {
//       driver = await FlutterDriver.connect();
//     });
//
//     tearDownAll(() {
//       if (driver != null) {
//         driver?.close();
//       }
//     });
//
//     test('AppDrawer: Open by tap and Close by slow scroll', () async {
//       final app = find.byValueKey('sudoku_game');
//       final drawerOpenButton = find.byTooltip('Open navigation menu');
//
//       await Future.delayed(const Duration(seconds: 1));
//       await driver?.tap(drawerOpenButton);
//
//       final newGameText = find.byValueKey('drawer_headline_text');
//       expect(await driver?.getText(newGameText), 'Main Menu');
//
//       await Future.delayed(const Duration(seconds: 1));
//       await driver?.scroll(app, -300, 0, const Duration(seconds: 3));
//       await Future.delayed(const Duration(seconds: 1));
//     });
//   });
// }
