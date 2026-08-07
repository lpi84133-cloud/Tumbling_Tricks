import 'package:flutter/material.dart';

import '../metrics.dart';
import '../palette.dart';

/// A brass hairline that fades out at both ends, optionally interrupted in the
/// middle by a painted flourish from the artwork.
///
/// Used instead of [Divider] so separators feel like inlaid hardware rather
/// than a Material rule.
class GoldRule extends StatelessWidget {
  const GoldRule({this.ornament, this.thickness = 1, this.inset = 0, super.key});

  /// Optional asset from `TimelineArt` / `Ornaments` placed at the centre.
  final String? ornament;

  final double thickness;

  /// Horizontal inset applied to both ends.
  final double inset;

  @override
  Widget build(BuildContext context) {
    final Widget line = Expanded(
      child: Container(
        height: thickness,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              Color(0x00C9A84C),
              Palette.hairlineStrong,
              Color(0x00C9A84C),
            ],
          ),
        ),
      ),
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: inset),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          line,
          if (ornament != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: Gap.sm),
              child: Image.asset(
                ornament!,
                height: 14,
                fit: BoxFit.contain,
                filterQuality: FilterQuality.medium,
              ),
            ),
          if (ornament != null) line,
        ],
      ),
    );
  }
}
