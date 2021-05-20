import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smart_pet_buddy/bottomnavbar_widget.dart';


void main() {
  testWidgets("home button", (WidgetTester tester) async {
    final homeButton = find.byIcon(Icons.home_outlined);

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(homeButton);
    await tester.pump();

    expect(homeButton, findsOneWidget);
  });

  testWidgets("Play button", (WidgetTester tester) async {
    final playButton = find.byIcon(Icons.control_camera_outlined);

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(playButton);
    await tester.pump();

    expect(playButton, findsOneWidget);

  });

  testWidgets("Automated play button", (WidgetTester tester) async {
    final autoButton = find.byIcon(Icons.pest_control_rodent_outlined);

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(autoButton);
    await tester.pump();

    expect(autoButton, findsOneWidget);

  });

  testWidgets("Profile button", (WidgetTester tester) async {
    final profileButton = find.byIcon(Icons.account_circle_outlined);

    await tester.pumpWidget(MaterialApp(home: ConvexBottomBar(Firebase.app())));
    await tester.tap(profileButton);
    await tester.pump();

    expect(profileButton, findsOneWidget);

  });
  }