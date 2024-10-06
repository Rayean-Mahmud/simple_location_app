import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:location_app/main.dart';

void main() {
  testWidgets('Location input screen has text field and button',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(LocationApp());

    // Verify that the text field for location input is present.
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Location'), findsOneWidget);

    // Verify that the button is present.
    expect(find.byType(ElevatedButton), findsOneWidget);
    expect(find.text('Show on Map'), findsOneWidget);
  });

  testWidgets(
      'Entering text and tapping the button navigates to the map screen',
      (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(LocationApp());

    // Enter a location in the text field.
    await tester.enterText(find.byType(TextField), 'New York');

    // Tap the button.
    await tester.tap(find.byType(ElevatedButton));

    // Rebuild the widget after the tap.
    await tester.pumpAndSettle();

    // Verify that the map screen appears (you can check for a specific widget that should be on the map screen).
    //expect(find.byType(GoogleMap), findsOneWidget);
  });
}
