import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  final VoidCallback onRetry;

  const NoInternetWidget({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    ColorScheme colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 80, color: colors.primary),
            const SizedBox(height: 20),
            Text(
              "Something Went Wrong..",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colors.onSurface.withAlpha(200),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Or check your connection and try again",
              style: TextStyle(color: colors.onSurface.withAlpha(160)),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: Icon(Icons.refresh, color: colors.onPrimary),
              label: const Text("Try Again"),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
