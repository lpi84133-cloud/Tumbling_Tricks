import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:tumbling_tricks/design/design.dart';

void main() {
  group('BrassProgressBar', () {
    testWidgets('paints without error across the full range', (
      WidgetTester tester,
    ) async {
      for (final double value in <double>[0, 0.01, 0.5, 1, 1.5, -0.2]) {
        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(width: 240, child: BrassProgressBar(value: value)),
              ),
            ),
          ),
        );
        expect(tester.takeException(), isNull);
      }
    });
  });

  group('Surfaces', () {
    // Cards are almost always used inside a scrollable, where the height
    // constraint is unbounded. Anything that needs a bounded cross axis has to
    // be caught here rather than on device.
    testWidgets('lay out inside an unbounded-height scrollable', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.build(),
          home: Scaffold(
            body: ListView(
              children: <Widget>[
                const PanelCard(child: Text('plain')),
                PanelCard(
                  accent: Palette.emeraldGlow,
                  onTap: () {},
                  child: const Text('accented and tappable'),
                ),
                const PaperCard(
                  texture: Papers.aged,
                  child: PaperInk(child: Text('ink on paper')),
                ),
                const SectionHeading(label: 'section'),
                const MarqueeHeader(
                  title: 'Header',
                  eyebrow: 'eyebrow',
                  subtitle: 'subtitle',
                  crest: Ornaments.crestStar,
                ),
                const GoldRule(ornament: TimelineArt.ornamentFleur),
              ],
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('ink on paper'), findsOneWidget);
    });
  });

  group('Design tokens', () {
    test('the bundled type scale uses only bundled families', () {
      final Set<String?> families = <String?>{
        AppText.brand.fontFamily,
        AppText.display.fontFamily,
        AppText.screenTitle.fontFamily,
        AppText.cardTitle.fontFamily,
        AppText.sectionLabel.fontFamily,
        AppText.body.fontFamily,
        AppText.caption.fontFamily,
        AppText.micro.fontFamily,
        AppText.action.fontFamily,
        AppText.timecode.fontFamily,
      };

      expect(families, <String>{Fonts.marquee, Fonts.heading, Fonts.body});
    });

    test('every catalogued image lives under assets/', () {
      expect(kAllImageAssets, isNotEmpty);
      for (final String asset in kAllImageAssets) {
        expect(asset, startsWith('assets/'));
      }
    });
  });
}
