import 'package:flutter/material.dart';

import '../models/enum/enum_message_type.dart';

/// A utility class for showing consistent SnackBars throughout the app.
class SnackbarService {
  // Private constructor to prevent instantiation
  SnackbarService._();

  /// Shows a SnackBar with a specified message and type.
  static void show(
    BuildContext context,
    String message, {
    // Default to 'info' type if not specified
    MessageType type = MessageType.info,
  }) {
    // Get the current theme's color scheme
    final colorScheme = Theme.of(context).colorScheme;

    // --- Determine colors based on the message type ---
    Color backgroundColor;
    Color textColor;
    IconData iconData;

    switch (type) {
      case MessageType.success:
        // Use primary color for success
        backgroundColor = Colors.green;
        textColor = colorScheme.onPrimary;
        iconData = Icons.check_circle_outline_rounded;
        break;
      case MessageType.error:
        // Use error color for errors
        backgroundColor = colorScheme.error;
        textColor = colorScheme.onError;
        iconData = Icons.error_outline_rounded;
        break;
      case MessageType.warning:
        // Use error color for errors
        backgroundColor = colorScheme.secondary;
        textColor = colorScheme.onSecondary;
        iconData = Icons.warning_amber_rounded;
        break;
      case MessageType.info:
        // Use secondary color for general info
        backgroundColor = Colors.lightBlueAccent;
        textColor = colorScheme.onPrimary;
        iconData = Icons.info_outline_rounded;
        break;
    }

    // --- Hide any snackbar that is currently visible ---
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    // --- Create and show the new snackbar ---
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(iconData, color: textColor),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(message, style: TextStyle(color: textColor)),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      behavior:
          SnackBarBehavior.floating, // Makes it float above the bottom nav bar
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  //another function named 'showWithOption' to show a snackbar with an option to retry
  static void showWithOption(
    BuildContext context,
    String message,
    VoidCallback onRetry,
  ) {
    show(context, message, type: MessageType.error);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.error_outline_rounded, color: Colors.white),
            const SizedBox(width: 8.0),
            Expanded(
              child: Text(message, style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
        action: SnackBarAction(
          label: "Retry",
          textColor: Colors.white,
          onPressed: onRetry,
        ),
      ),
    );
  }
}
