import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_io/main.dart';

void main() {
  testWidgets('MyHomePage widget test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MaterialApp(
      home: MyHomePage(),
    ));

    // Verify that the title text is displayed.
    expect(find.text('Meal.IO'), findsOneWidget);

    // Verify that the two ElevatedButtons are displayed.
    expect(find.byIcon(Icons.perm_media_rounded), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt), findsOneWidget);

    // Tap on the ElevatedButton to pick image from gallery.
    await tester.tap(find.byIcon(Icons.perm_media_rounded));
    await tester.pump();

    // Verify that the Navigator pushes to the recipes page after tapping the ElevatedButton.
    expect(find.byType(MyRecipeFinder), findsOneWidget);
  });
}