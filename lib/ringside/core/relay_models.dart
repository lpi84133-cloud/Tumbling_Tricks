/// Persisted routing decision for a given install.
enum GateRoute {
  native,
  portal,
  undecided;

  String get storageValue => switch (this) {
        GateRoute.native => 'native',
        GateRoute.portal => 'portal',
        GateRoute.undecided => 'undecided',
      };

  static GateRoute parse(String? value) => switch (value) {
        'portal' || 'web' => GateRoute.portal,
        'native' || 'game' => GateRoute.native,
        _ => GateRoute.undecided,
      };
}

/// Decoded response from the config endpoint.
class GateReply {
  const GateReply({required this.accepted, this.url, this.expiresAt, this.reason});

  factory GateReply.fromJson(Map<String, dynamic> json) {
    final rawExpiry = json['expires'];
    return GateReply(
      accepted: json['ok'] == true,
      url: json['url'] is String ? json['url'] as String : null,
      expiresAt: rawExpiry is num
          ? rawExpiry.toInt()
          : int.tryParse(rawExpiry?.toString() ?? ''),
      reason: json['message']?.toString(),
    );
  }

  factory GateReply.rejected(String reason) =>
      GateReply(accepted: false, reason: reason);

  final bool accepted;
  final String? url;
  final int? expiresAt;
  final String? reason;

  bool get hasDestination => accepted && (url?.isNotEmpty ?? false);
}

/// Where the boot pipeline decided to send the user.
sealed class GateStage {
  const GateStage();
}

/// Show the native game (organic / unattributed users and reviewers).
final class NativeStage extends GateStage {
  const NativeStage();
}

/// Show the web portal at [url].
final class PortalStage extends GateStage {
  const PortalStage(this.url, {this.coldLaunch = false});

  final String url;
  final bool coldLaunch;
}

/// No connectivity; show the offline screen.
final class OfflineStage extends GateStage {
  const OfflineStage();
}
