import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/enums.dart';
import '../../data/providers.dart';
import '../../design/design.dart';
import '../../design/enum_art.dart';

/// Shown once, before the Stage Console.
///
/// Three pages, and the last one does real work: the stage name and discipline
/// entered here are written to the profile, so the app starts with something the
/// user recognises rather than an empty shell. Everything is skippable.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({required this.onDone, super.key});

  final VoidCallback onDone;

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final PageController _pages = PageController();
  final TextEditingController _stageName = TextEditingController();

  Discipline? _discipline;
  int _index = 0;
  bool _finishing = false;

  static const int _pageCount = 3;

  @override
  void dispose() {
    _pages.dispose();
    _stageName.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_finishing) return;
    setState(() => _finishing = true);

    final String name = _stageName.text.trim();
    if (name.isNotEmpty || _discipline != null) {
      await ref.read(profileRepositoryProvider).update(
        stageName: name.isEmpty ? null : name,
        discipline: _discipline,
      );
    }
    await ref
        .read(preferencesRepositoryProvider)
        .setOnboardingCompleted(completed: true);

    widget.onDone();
  }

  void _next() {
    if (_index == _pageCount - 1) {
      _finish();
    } else {
      _pages.nextPage(duration: Motion.normal, curve: Motion.enter);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.ink,
      body: StageBackdrop(
        scene: StageScene.curtains,
        artworkOpacity: 0.34,
        child: SafeArea(
          child: Column(
            children: <Widget>[
              Expanded(
                child: PageView(
                  controller: _pages,
                  onPageChanged: (int index) => setState(() => _index = index),
                  children: <Widget>[
                    const _WelcomePage(),
                    const _HowItWorksPage(),
                    _ProfilePage(
                      controller: _stageName,
                      discipline: _discipline,
                      onDiscipline: (Discipline? value) =>
                          setState(() => _discipline = value),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(Layout.pageInset),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        for (int i = 0; i < _pageCount; i++)
                          AnimatedContainer(
                            duration: Motion.quick,
                            margin: const EdgeInsets.symmetric(horizontal: Gap.xs),
                            width: i == _index ? 22 : 7,
                            height: 7,
                            decoration: BoxDecoration(
                              borderRadius: Corners.pill,
                              color: i == _index ? Palette.brass : Palette.brassDim,
                            ),
                          ),
                      ],
                    ),
                    Gap.vLg,
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _finishing ? null : _next,
                        child: Text(
                          _index == _pageCount - 1 ? 'START' : 'NEXT',
                        ),
                      ),
                    ),
                    if (_index < _pageCount - 1)
                      TextButton(
                        onPressed: _finishing ? null : _finish,
                        child: const Text('SKIP'),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomePage extends StatelessWidget {
  const _WelcomePage();

  @override
  Widget build(BuildContext context) {
    return _PageBody(
      children: <Widget>[
        Image.asset(Brand.logotype, height: 78),
        Gap.vXl,
        Text(
          'A planning tool for people who perform.',
          style: AppText.screenTitle,
          textAlign: TextAlign.center,
        ),
        Gap.vLg,
        Text(
          'Build an act, order the tricks inside it, keep the checklist and the '
          'stage plot honest, and log the rehearsals that actually happened.',
          style: AppText.body,
          textAlign: TextAlign.center,
        ),
        Gap.vXl,
        const GoldRule(ornament: TimelineArt.ornamentFleur),
        Gap.vLg,
        Text(
          'Everything is stored on this device and works with no connection.',
          style: AppText.caption,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _HowItWorksPage extends StatelessWidget {
  const _HowItWorksPage();

  @override
  Widget build(BuildContext context) {
    return _PageBody(
      children: <Widget>[
        Text('How readiness works', style: AppText.screenTitle),
        Gap.vSm,
        Text(
          'One number per act, built only from things you record. Opening the app '
          'does not move it.',
          style: AppText.caption,
          textAlign: TextAlign.center,
        ),
        Gap.vXl,
        for (final (String label, String weight, String detail) row
            in const <(String, String, String)>[
          ('Checklist', '25%', 'Checks cleared before the act can go on'),
          ('Choreography', '20%', 'Beats timed and set, not just listed'),
          ('Structure', '15%', 'Blocks that actually contain material'),
          ('Stage plot', '15%', 'Technical lines confirmed with the venue'),
          ('Rehearsal', '15%', 'Sessions logged, and how the runs felt'),
          ('Timing', '10%', 'Planned length against your target'),
        ])
          Padding(
            padding: const EdgeInsets.only(bottom: Gap.md),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  width: 46,
                  child: Text(row.$2, style: AppText.timecode),
                ),
                Gap.hMd,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(row.$1, style: AppText.bodyStrong),
                      Text(row.$3, style: AppText.micro),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _ProfilePage extends StatelessWidget {
  const _ProfilePage({
    required this.controller,
    required this.discipline,
    required this.onDiscipline,
  });

  final TextEditingController controller;
  final Discipline? discipline;
  final ValueChanged<Discipline?> onDiscipline;

  @override
  Widget build(BuildContext context) {
    return _PageBody(
      children: <Widget>[
        Image.asset(Ornaments.crestMask, height: 56),
        Gap.vLg,
        Text('Who is performing?', style: AppText.screenTitle),
        Gap.vSm,
        Text(
          'Optional, and changeable later in Backstage.',
          style: AppText.caption,
          textAlign: TextAlign.center,
        ),
        Gap.vXl,
        TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          textAlign: TextAlign.center,
          maxLength: 60,
          decoration: const InputDecoration(
            labelText: 'Stage name',
            counterText: '',
          ),
        ),
        Gap.vXl,
        Text('WHAT YOU MOSTLY DO', style: AppText.micro),
        Gap.vMd,
        Wrap(
          spacing: Gap.sm,
          runSpacing: Gap.sm,
          alignment: WrapAlignment.center,
          children: <Widget>[
            for (final Discipline value in Discipline.values)
              ChoiceChip(
                label: Text(value.label),
                avatar: Image.asset(value.icon, height: 16),
                selected: discipline == value,
                onSelected: (bool on) => onDiscipline(on ? value : null),
              ),
          ],
        ),
      ],
    );
  }
}

class _PageBody extends StatelessWidget {
  const _PageBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
        horizontal: Layout.pageInset,
        vertical: Gap.xl,
      ),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: Layout.maxContentWidth),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: children,
          ),
        ),
      ),
    );
  }
}
