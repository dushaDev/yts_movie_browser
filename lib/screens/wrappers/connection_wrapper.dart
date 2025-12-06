import 'package:flutter/material.dart';
import '../../services/network_service.dart';

class ConnectionWrapper extends StatelessWidget {
  final Widget child;

  const ConnectionWrapper({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<bool>(
        stream: NetworkService().onConnectivityChanged,
        initialData: true, // Assume online initially to avoid flash
        builder: (context, snapshot) {
          final isOnline = snapshot.data ?? true;

          return Column(
            children: [
              // 1. THE APP (Takes up all space)
              Expanded(child: child),

              // 2. THE OFFLINE BANNER (Animate height)
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                height: isOnline ? 0 : 40, // Height 0 when online (hidden)
                color: Colors.red[900],
                child: isOnline
                    ? null
                    : const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.wifi_off, color: Colors.white, size: 16),
                            SizedBox(width: 8),
                            Text(
                              "No Internet Connection",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
