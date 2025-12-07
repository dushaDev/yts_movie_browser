import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:yts_movie_browser/screens/dusha_dev_logo.dart';

class AboutAppScreen extends StatelessWidget {
  const AboutAppScreen({super.key});

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text("About App"),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        centerTitle: false, // Requested: Left aligned title
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. APP LOGO (FROM ASSETS)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'assets/images/yts_logo.png',
                width: 70,
                height: 70,
                fit: BoxFit.contain,
                errorBuilder: (ctx, err, stack) => Icon(
                  Icons.movie_filter,
                  size: 60,
                  color: colorScheme.primary,
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text(
              "YTS Movie Browser",
              style: textTheme.headlineMedium?.copyWith(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: colorScheme.onSurface,
              ),
            ),

            const SizedBox(height: 8),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Version 1.0.1", // Beta removed
                style: TextStyle(
                  color: colorScheme.onPrimaryContainer,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 2. PURPOSE & DOMAIN WARNING
            Text(
              "Designed for YTS enthusiasts to browse, search, and download torrents efficiently.",
              textAlign: TextAlign.center,
              style: textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            // DOMAIN WARNING CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colorScheme.errorContainer.withAlpha(50),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colorScheme.error.withAlpha(100)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.wifi_tethering_error_rounded,
                    color: colorScheme.error,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Service Availability Notice",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "This app relies on the public YTS domain (yts.ag). If the domain is blocked by your ISP or changed by YTS, the app may temporarily fail to load data. Please use a VPN or check for app updates if connection fails.",
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // 3. TECHNICAL DATA
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Technical Specs",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildTechRow(context, "Architecture", "MVVM + Provider"),
            _buildTechRow(context, "API Client", "Dio (REST API)"),
            _buildTechRow(context, "Local DB", "Sqflite (Offline Favorites)"),
            _buildTechRow(context, "Min Android SDK", "21 (Lollipop)"),

            const SizedBox(height: 30),

            // 4. DISCLAIMER
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Legal",
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "We do not host any files. This application is purely a search engine/browser for the public YTS API.",
              style: textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 16),
            TextButton.icon(
              icon: Icon(
                Icons.privacy_tip_outlined,
                color: colorScheme.primary,
              ),
              label: Text(
                'Privacy Policy',
                style: TextStyle(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () => _launchURL(
                'https://sites.google.com/view/yts-browser-privacy-policy/home',
              ),
            ),

            const SizedBox(height: 20),

            // 5. FOOTER (dushaDev)
            Divider(color: colorScheme.outlineVariant),
            const SizedBox(height: 20),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Designed & Built by",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                DushaDevLogo(),
                const SizedBox(height: 4),
                Text(
                  "© 2025",
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTechRow(BuildContext context, String label, String value) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: theme.colorScheme.onSurfaceVariant),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
                fontSize: 12,
                fontFamily: 'Courier', // Monospace for tech look
              ),
            ),
          ),
        ],
      ),
    );
  }
}
