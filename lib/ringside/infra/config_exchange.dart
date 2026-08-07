import 'dart:convert';

import '../config/marquee_config.dart';
import '../core/relay_models.dart';
import 'attribution_relay.dart';
import 'browser_agent.dart';
import 'stage_vault.dart';

/// Posts the composed attribution body to the config endpoint and caches a
/// granted URL for returning launches.
class ConfigExchange {
  ConfigExchange(this._agent, this._vault);

  final BrowserAgent _agent;
  final StageVault _vault;

  Future<GateReply> request(Map<String, dynamic> payload) async {
    if (!MarqueeConfig.gateReady) {
      return GateReply.rejected('credentials_unavailable');
    }
    try {
      ringTrace(() => '[TT.EXCHANGE] request ${jsonEncode(payload)}');
      final response = await _agent.post(
        Uri.parse(MarqueeConfig.endpoint),
        headers: const <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      ).timeout(MarqueeConfig.configTimeout);
      ringTrace(
        () => '[TT.EXCHANGE] response ${response.statusCode} ${response.body}',
      );
      if (response.statusCode != 200) {
        return GateReply.rejected('http_${response.statusCode}');
      }
      final decoded = jsonDecode(response.body);
      if (decoded is! Map) return GateReply.rejected('invalid_response');
      final reply = GateReply.fromJson(Map<String, dynamic>.from(decoded));
      if (reply.hasDestination) {
        await _vault.cacheUrl(reply.url!, reply.expiresAt);
      }
      return reply;
    } catch (error) {
      ringTrace(() => '[TT.EXCHANGE] failed: $error');
      return GateReply.rejected('network_failure');
    }
  }
}
