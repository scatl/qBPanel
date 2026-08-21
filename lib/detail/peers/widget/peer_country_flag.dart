import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// 按 `country_code` 显示 4×3 旗帜（flag-icons），未知用 `xx`。
class PeerCountryFlag extends StatelessWidget {
  const PeerCountryFlag({
    super.key,
    this.countryCode,
    this.width = 20,
    this.height = 15,
  });

  final String? countryCode;
  final double width;
  final double height;

  static const _unknown = 'assets/flags/xx.svg';
  static final _codePattern = RegExp(r'^[a-z]{2}(?:-[a-z]{2,3})?$');

  static String _assetFor(String? countryCode) {
    final raw = countryCode?.trim().toLowerCase() ?? '';
    if (!_codePattern.hasMatch(raw)) return _unknown;
    return 'assets/flags/$raw.svg';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(2),
      child: SvgPicture.asset(
        _assetFor(countryCode),
        width: width,
        height: height,
        fit: BoxFit.cover,
      ),
    );
  }
}
