import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/providers.dart';
import '../design/app_assets.dart';

/// The kinds of feedback the app gives.
enum Cue {
  /// A light tap, for selections and toggles.
  tap(Sfx.tap),

  /// Something was written to the database.
  saved(Sfx.saveStamp),

  /// A beat or trick was placed.
  place(Sfx.cardFlip),

  /// Moving between major screens.
  transition(Sfx.transition),

  /// A signal or checklist reached completion.
  complete(Sfx.success),

  /// The whole act reached ready.
  finale(Sfx.finale),

  /// An action could not be completed.
  problem(Sfx.error);

  const Cue(this.asset);

  final String asset;
}

/// Plays the interface sounds and haptics, honouring the user's preferences.
///
/// Both are read fresh from the preferences row at the moment of the cue, so
/// turning sound off in Backstage takes effect on the very next tap without any
/// listener plumbing. A cue is never allowed to fail loudly: audio is
/// best-effort and its errors are swallowed, because a missing sound must not
/// interrupt a save.
class FeedbackService {
  FeedbackService(this._ref);

  final Ref _ref;

  final AudioPlayer _player = AudioPlayer(playerId: 'tumbling_tricks_cues');

  bool _warmed = false;

  /// Loads the audio pipeline so the first real cue is not delayed.
  Future<void> warmUp() async {
    if (_warmed) return;
    _warmed = true;
    try {
      await _player.setReleaseMode(ReleaseMode.stop);
      await _player.setVolume(0.6);
    } catch (_) {
      // An unavailable audio session is not worth reporting: the app is silent
      // and everything else still works.
    }
  }

  Future<void> play(Cue cue) async {
    final bool sound = _ref.read(preferencesProvider).value?.soundEnabled ?? true;
    if (!sound) return;

    try {
      await _player.stop();
      await _player.play(AssetSource(_relative(cue.asset)));
    } catch (_) {
      // Ignored deliberately — see the class comment.
    }
  }

  Future<void> haptic(Cue cue) async {
    final bool haptics = _ref.read(preferencesProvider).value?.hapticsEnabled ?? true;
    if (!haptics) return;

    switch (cue) {
      case Cue.tap:
      case Cue.place:
      case Cue.transition:
        await HapticFeedback.selectionClick();
      case Cue.saved:
        await HapticFeedback.lightImpact();
      case Cue.complete:
      case Cue.finale:
        await HapticFeedback.mediumImpact();
      case Cue.problem:
        await HapticFeedback.heavyImpact();
    }
  }

  /// Sound and haptic together, which is how cues are used at call sites.
  Future<void> cue(Cue cue) async {
    await Future.wait<void>(<Future<void>>[play(cue), haptic(cue)]);
  }

  void dispose() => _player.dispose();

  /// `audioplayers` resolves `AssetSource` against `assets/`, so the leading
  /// segment of the catalogue path has to come off.
  static String _relative(String assetPath) =>
      assetPath.startsWith('assets/') ? assetPath.substring('assets/'.length) : assetPath;
}

final Provider<FeedbackService> feedbackProvider = Provider<FeedbackService>((Ref ref) {
  final FeedbackService service = FeedbackService(ref);
  ref.onDispose(service.dispose);
  return service;
});
