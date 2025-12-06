import 'package:flutter/material.dart';

class DushaDevLogo extends StatelessWidget {
  const DushaDevLogo({super.key});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return RichText(
      text: TextSpan(
        style: const TextStyle(
          fontFamily: 'Courier New', // Monospace font for code look
          fontSize: 15.0,
          fontWeight: FontWeight.bold,
        ),
        children: [
          TextSpan(
            text: '{',
            style: const TextStyle(
              color: Color(0xFFFFAA00),
            ), // Orange bracket
          ),
          TextSpan(
            text: 'Dusha',
            style: TextStyle(
              color: colors.onSurface.withAlpha(200),
            ), // White text
          ),
          TextSpan(
            text: 'D',
            style: const TextStyle(color: Color(0xFFFFAA00)), // Orange 'D'
          ),
          TextSpan(
            text: 'ev',
            style: TextStyle(
              color: colors.onSurface.withAlpha(200),
            ), // White text
          ),
          TextSpan(
            text: '}',
            style: const TextStyle(
              color: Color(0xFFFFAA00),
            ), // Orange bracket
          ),
        ],
      ),
    );
  }
}
