import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:idle_startup_office/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('Startup Office smoke test exposes the core loop', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const StartupOfficeApp());
    await tester.pump(const Duration(milliseconds: 250));

    expect(find.text('Startup Office'), findsOneWidget);
    expect(find.textContaining('Cash'), findsWidgets);
    expect(find.textContaining('Valuation'), findsWidgets);

    await tester.tap(find.byKey(const Key('founder_tap_button')));
    await tester.pump();

    expect(find.textContaining('Founder Tap'), findsOneWidget);
  });

  test('controller can progress through a prestige-ready loop', () {
    final controller = GameController();

    for (var i = 0; i < 25; i++) {
      controller.founderTap();
    }
    controller.buyTapUpgrade();
    controller.hire(Role.juniorDeveloper);
    controller.hire(Role.uxDesigner);
    controller.tick(120);

    expect(controller.cash, greaterThan(0));
    expect(controller.valuation, greaterThan(0));

    controller.valuation = controller.prestigeTarget;
    controller.prestige();

    expect(controller.lifetimePrestiges, 1);
    expect(controller.prestigePoints, greaterThanOrEqualTo(1));
    expect(controller.cash, 0);
  });
}
