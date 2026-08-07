import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';

/// Connectivity checks for the boot pipeline and the portal offline handling.
class ReachProbe {
  final Connectivity _connectivity = Connectivity();

  /// Whether the device has ANY network interface up (fast, no DNS).
  Future<bool> hasInterface() async {
    try {
      final status = await _connectivity.checkConnectivity();
      return status.any((value) => value != ConnectivityResult.none);
    } catch (_) {
      return false;
    }
  }

  /// Confirms real reachability by resolving well-known hosts (not our own
  /// domain, so a VPN or not-yet-propagated domain never reads as offline).
  /// Each lookup is time-boxed so a retry can never hang.
  Future<bool> canReach() async {
    if (!await hasInterface()) return false;
    for (final host in const <String>['www.apple.com', 'one.one.one.one']) {
      try {
        final records = await InternetAddress.lookup(host)
            .timeout(const Duration(seconds: 3));
        if (records.any((r) => r.rawAddress.isNotEmpty)) return true;
      } catch (_) {
        // Try the next host before declaring offline.
      }
    }
    return false;
  }

  Stream<List<ConnectivityResult>> get changes =>
      _connectivity.onConnectivityChanged;
}
