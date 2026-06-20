import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_startup_office/main.dart';
import 'package:integration_test/integration_test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('simulator acceptance validates events and feature bets', (
    tester,
  ) async {
    await tester.pumpWidget(const StartupOfficeApp());
    await _pumpUntilFound(tester, find.text('Startup Office'));

    await _openTab(tester, 'tab_events', dragX: -260);
    expect(find.textContaining('Burst Events'), findsOneWidget);
    await _pumpUntilEnabled(
      tester,
      find.byKey(const Key('events_claim_button')),
      maxLoops: 0,
    );
    await _tapAndPump(tester, find.byKey(const Key('events_claim_button')));

    await _openTab(tester, 'tab_product', dragX: 260);
    await _pumpUntilEnabled(
      tester,
      find.byKey(const Key('ship_product_button')),
      maxLoops: 0,
    );
    await _tapAndPump(tester, find.byKey(const Key('ship_product_button')));
    await _pumpUntilFound(
      tester,
      find.byKey(const Key('feature_bet_onboarding_button')),
    );
    await _tapAndPump(
      tester,
      find.byKey(const Key('feature_bet_onboarding_button')),
    );
    expect(find.textContaining('Feature bets:'), findsOneWidget);
  });

  testWidgets('simulator acceptance validates board pressure and contracts', (
    tester,
  ) async {
    await tester.pumpWidget(const StartupOfficeApp());
    await _pumpUntilFound(tester, find.text('Startup Office'));

    await _openTab(tester, 'tab_funding', dragX: -260);
    await _scrollPanelUntilFound(
      tester,
      find.textContaining('Board influence'),
    );
    expect(find.textContaining('Active directive:'), findsOneWidget);

    await _openTab(tester, 'tab_expansion', dragX: -260);
    expect(find.textContaining('Contracts & Markets'), findsOneWidget);
    await _scrollPanelUntilFound(
      tester,
      find.byKey(const Key('contract_startupPilot_button')),
    );
    expect(find.textContaining('Needs Trust'), findsWidgets);
    expect(find.textContaining('Playbook Shelf'), findsOneWidget);
  });

  testWidgets('simulator acceptance validates prestige meta surfaces', (
    tester,
  ) async {
    await tester.pumpWidget(const StartupOfficeApp());
    await _pumpUntilFound(tester, find.text('Startup Office'));

    await _openTab(tester, 'tab_prestige', dragX: -260);
    expect(find.textContaining('Portfolio companies'), findsOneWidget);
    expect(find.textContaining('Portfolio meta'), findsOneWidget);
  });
}

Future<void> _tapAndPump(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.tap(finder, warnIfMissed: false);
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _openTab(
  WidgetTester tester,
  String keyName, {
  required double dragX,
}) async {
  final finder = find.byKey(Key(keyName));
  final scrollable = find.byType(ListView).at(0);
  for (var i = 0; i < 12 && finder.evaluate().isEmpty; i++) {
    await tester.drag(scrollable, Offset(dragX, 0), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 350));
  }
  expect(finder, findsOneWidget);
  await tester.ensureVisible(finder);
  await tester.pump(const Duration(milliseconds: 200));
  await tester.tap(finder, warnIfMissed: false);
  for (var i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 200));
  }
}

Future<void> _pumpUntilFound(WidgetTester tester, Finder finder) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 300));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
  }
  expect(finder, findsOneWidget);
}

Future<void> _pumpUntilEnabled(
  WidgetTester tester,
  Finder finder, {
  required int maxLoops,
}) async {
  final loops = maxLoops == 0 ? 1 : maxLoops;
  for (var i = 0; i < loops; i++) {
    if (finder.evaluate().isNotEmpty) {
      final button = tester.widget<FilledButton>(finder);
      if (button.onPressed != null) {
        return;
      }
    }
    await tester.pump(const Duration(seconds: 1));
  }
  final button = tester.widget<FilledButton>(finder);
  expect(button.onPressed, isNotNull);
}

Future<void> _scrollPanelUntilFound(WidgetTester tester, Finder finder) async {
  final scrollable = find.byType(ListView).at(1);
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 250));
    if (finder.evaluate().isNotEmpty) {
      return;
    }
    await tester.drag(scrollable, const Offset(0, -260), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 350));
  }
  expect(finder, findsOneWidget);
}
