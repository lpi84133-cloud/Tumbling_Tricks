import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/app_database.dart';
import '../data/providers.dart';
import '../design/app_assets.dart';
import '../design/typography.dart';
import '../ringside/core/relay_models.dart';
import '../ringside/ring_gate.dart';
import 'analytics.dart';
import 'feedback.dart';
import 'reminders.dart';

/// What the launch screen is allowed to show.
@immutable
class BootstrapProgress {
  const BootstrapProgress({
    required this.value,
    required this.label,
    this.isReady = false,
    this.isSlow = false,
    this.error,
  });

  const BootstrapProgress.initial()
    : value = 0,
      label = 'Opening the house',
      isReady = false,
      isSlow = false,
      error = null;

  /// 0 to 1. This is the real fraction of bootstrap work completed; nothing
  /// inflates it to look busy.
  final double value;

  /// What is actually happening right now.
  final String label;

  /// True only after every step finished and the first frame is on screen.
  final bool isReady;

  /// Set when bootstrap has taken unusually long. The bar does not move because
  /// of this — it only changes what the user is told.
  final bool isSlow;

  final Object? error;

  bool get hasError => error != null;

  BootstrapProgress copyWith({
    double? value,
    String? label,
    bool? isReady,
    bool? isSlow,
    Object? error,
  }) {
    return BootstrapProgress(
      value: value ?? this.value,
      label: label ?? this.label,
      isReady: isReady ?? this.isReady,
      isSlow: isSlow ?? this.isSlow,
      error: error ?? this.error,
    );
  }
}

/// One unit of start-up work.
class _Step {
  const _Step(this.label, this.weight, this.run);

  final String label;

  /// Share of the total bar this step is worth. Weights across all steps sum
  /// to 1, so the bar advances in proportion to real work rather than in equal
  /// jumps per step.
  final double weight;

  /// Reports fractional completion inside the step, for the long ones.
  final Future<void> Function(void Function(double fraction) report) run;
}

/// Runs start-up work and reports progress that cannot lie.
///
/// Two rules hold the whole design together:
///
/// * The bar only moves when a step actually finishes, or when a step that
///   knows its own size reports a fraction. There is no timer nudging it along,
///   so it can never sit at 97% waiting for something that already failed.
/// * `isReady` is set after `endOfFrame`, meaning the first real frame has been
///   rasterised. 100% therefore means the app is genuinely on screen, not that
///   it is about to be.
class BootstrapController extends Notifier<BootstrapProgress> {
  static const Duration _slowThreshold = Duration(seconds: 8);

  bool _started = false;

  @override
  BootstrapProgress build() => const BootstrapProgress.initial();

  /// Starts the sequence. Safe to call more than once; only the first call runs.
  ///
  /// When [essentialsOnly] is true, only the minimum work required to show
  /// the offline view is performed — the database is opened and preferences
  /// are read, but the heavy asset / font / catalog / summary steps are
  /// skipped. This is used when [main] has already decided the launch will
  /// end at the offline view, so the user is not made to wait for artwork
  /// they will not see. The skipped work is picked up naturally on the next
  /// launch (or from Retry, which re-enters the full pipeline).
  Future<void> start(
    BuildContext context, {
    bool essentialsOnly = false,
  }) async {
    if (_started) return;
    _started = true;

    final Stopwatch clock = Stopwatch()..start();
    final List<_Step> steps = essentialsOnly
        ? _buildEssentialSteps()
        : _buildSteps(context);
    final double totalWeight = steps.fold<double>(
      0,
      (double sum, _Step s) => sum + s.weight,
    );

    double completed = 0;

    try {
      for (final _Step step in steps) {
        state = state.copyWith(
          label: step.label,
          value: completed / totalWeight,
          isSlow: clock.elapsed > _slowThreshold,
        );

        await step.run((double fraction) {
          final double within = fraction.clamp(0.0, 1.0) * step.weight;
          state = state.copyWith(value: (completed + within) / totalWeight);
        });

        completed += step.weight;
        state = state.copyWith(
          value: completed / totalWeight,
          isSlow: clock.elapsed > _slowThreshold,
        );
      }
    } catch (error) {
      // A failure stops the bar where it stands rather than completing it.
      state = state.copyWith(label: 'Could not finish opening', error: error);
      return;
    }

    // Everything is done, but the first real frame has not been rasterised yet.
    // Waiting for it is what makes 100% honest.
    await WidgetsBinding.instance.endOfFrame;

    state = state.copyWith(
      value: 1,
      label: 'Ready',
      isReady: true,
      isSlow: false,
    );
  }

  /// The two steps that MUST complete before the offline view can render:
  /// the database (used by Retry / Skip / preferences) and the singleton
  /// preferences row. Everything else — assets, fonts, summary warm-up,
  /// reminders, attribution — is either not needed on the offline screen
  /// or can wait for the next launch without any user-visible cost.
  List<_Step> _buildEssentialSteps() {
    return <_Step>[
      _Step('Opening the archive', 0.5, (void Function(double) report) async {
        final AppDatabase db = ref.read(databaseProvider);
        await db.customSelect('SELECT 1').get();
      }),
      _Step('Reading your settings', 0.5, (void Function(double) report) async {
        final AppDatabase db = ref.read(databaseProvider);
        await db.ensureSingletonRows();
        await ref.read(preferencesRepositoryProvider).read();
      }),
    ];
  }

  List<_Step> _buildSteps(BuildContext context) {
    return <_Step>[
      _Step('Opening the archive', 0.20, (void Function(double) report) async {
        // Forces the database open, which runs migrations and the foreign-key
        // pragma. Until this completes there is nothing else worth doing.
        final AppDatabase db = ref.read(databaseProvider);
        await db.customSelect('SELECT 1').get();
      }),
      _Step('Reading your settings', 0.08, (
        void Function(double) report,
      ) async {
        final AppDatabase db = ref.read(databaseProvider);
        await db.ensureSingletonRows();
        await ref.read(preferencesRepositoryProvider).read();
        await ref.read(profileRepositoryProvider).read();
      }),
      _Step('Stocking the trick library', 0.12, (
        void Function(double) report,
      ) async {
        await ref.read(databaseProvider).mergeTrickCatalog();

        // Runs the mastery-decay pass while the launch bar is still on
        // screen. Cheap in practice — one indexed read plus a batched update
        // — and doing it here means the console opens with the corrected
        // ratings rather than blipping them a moment later.
        final AppPreferenceRow prefs = await ref
            .read(preferencesRepositoryProvider)
            .read();
        if (prefs.decayEnabled) {
          await ref.read(trickRepositoryProvider).applyMasteryDecay();
        }
      }),
      _Step('Hanging the scenery', 0.30, (void Function(double) report) async {
        // The only step big enough to report its own progress, and the reason
        // the first screen paints without popping images in.
        for (int i = 0; i < _warmupImages.length; i++) {
          if (!context.mounted) return;
          await precacheImage(AssetImage(_warmupImages[i]), context);
          report((i + 1) / _warmupImages.length);
        }
      }),
      _Step('Setting the type', 0.10, (void Function(double) report) async {
        // Laying out one line per family forces the font files to be parsed now
        // instead of during the first frame of the first screen.
        for (final TextStyle style in <TextStyle>[
          AppText.brand,
          AppText.screenTitle,
          AppText.body,
        ]) {
          TextPainter(
              text: TextSpan(text: 'Tumbling Tricks', style: style),
              textDirection: TextDirection.ltr,
            )
            ..layout()
            ..dispose();
        }
      }),
      _Step('Checking your acts', 0.12, (void Function(double) report) async {
        // Warms the summary query so the console has data on its first build.
        await ref.read(actRepositoryProvider).watchActive().first;
      }),
      _Step('Raising the curtain', 0.08, (void Function(double) report) async {
        await ref.read(feedbackProvider).warmUp();
        // Keeps the scheduled reminders in step with the stored preference in
        // case the app was reinstalled or the clock changed.
        await ref.read(reminderProvider).sync();
        // Fires the install-attribution SDK without waiting for it to resolve.
        // The postback lives on native side; blocking the launch bar on a
        // network round-trip would be a lie.
        unawaited(ref.read(attributionServiceProvider).initialize());
      }),
      _Step('Warming up the marquee', 0.15, (
        void Function(double) report,
      ) async {
        // Resolves attribution + backend routing while the launch bar is still
        // showing, so a non-organic install goes to its destination without a
        // second loading screen after the bar completes.
        final coordinator = ref.read(ringCoordinatorProvider);
        if (coordinator == null || !coordinator.enabled) {
          coordinator?.outcome = const NativeStage();
          return;
        }
        // Honour the pre-flight decision made in `main.dart`: on any launch
        // that needs the network to decide (undecided route or returning
        // portal) with no interface up, the outcome is already pinned to
        // [OfflineStage] and there is nothing gray-side left to do here.
        if (coordinator.outcome != null) return;
        try {
          coordinator.outcome = await coordinator.resolve();
        } catch (_) {
          coordinator.outcome = const NativeStage();
        }
      }),
    ];
  }

  /// Artwork the first screens need. Deliberately not every bundled image:
  /// decorative timeline and progress pieces are decoded when their screen is
  /// first opened, which keeps launch quick and memory sane.
  static const List<String> _warmupImages = <String>[
    Backdrops.arena,
    Backdrops.stageCurtains,
    Backdrops.finaleStage,
    Brand.logotype,
    Emblems.joker,
    Emblems.mask,
    Emblems.cards,
    Emblems.tent,
    Ornaments.crestTent,
    Ornaments.crestStar,
    Ornaments.crestMask,
    Ornaments.crestShell,
    StatusArt.draft,
    StatusArt.planning,
    StatusArt.rehearsal,
    StatusArt.ready,
    StatusArt.completed,
    TrickArt.acrobatics,
    TrickArt.cards,
    TrickArt.magic,
    TrickArt.stage,
    Papers.aged,
    TimelineArt.ornamentFleur,
  ];
}

final NotifierProvider<BootstrapController, BootstrapProgress>
bootstrapProvider = NotifierProvider<BootstrapController, BootstrapProgress>(
  BootstrapController.new,
);
