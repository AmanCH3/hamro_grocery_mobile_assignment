import 'dart:async'; // Import for Timer
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hamro_grocery_mobile/splash/splash_screen.dart';
import 'package:hamro_grocery_mobile/splash/welcome_view.dart';

void main() {
  group('SplashScreen', () {
    testWidgets(
      'displays logo, text, and progress indicator on initial render',
      (WidgetTester tester) async {
        await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

        final logoFinder = find.descendant(
          of: find.byType(ConstrainedBox),
          matching: find.byType(Image),
        );
        expect(logoFinder, findsOneWidget);

        const welcomeText =
            "Your online grocery app\nwhere you can find everything you need.";
        expect(find.text(welcomeText), findsOneWidget);

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.pump(const Duration(seconds: 3));
      },
    );

    testWidgets('navigates to WelcomeView after 3-second delay', (
      WidgetTester tester,
    ) async {
      // Arrange
      await tester.pumpWidget(
        MaterialApp(
          home: const SplashScreen(),
          routes: {'/welcome': (context) => const WelcomeView()},
        ),
      );

      expect(find.byType(WelcomeView), findsNothing);

      await tester.pumpAndSettle(const Duration(seconds: 3));

      expect(find.byType(WelcomeView), findsOneWidget);
      expect(find.byType(SplashScreen), findsNothing);
    });

    testWidgets('displays initial UI (using fakeAsync)', (
      WidgetTester tester,
    ) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(const MaterialApp(home: SplashScreen()));

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.textContaining('Your online grocery app'), findsOneWidget);
      });
    });
  });
}
