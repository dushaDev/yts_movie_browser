import 'package:connectivity_plus/connectivity_plus.dart';

class NetworkService {
  // Singleton instance
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();

  final Connectivity _connectivity = Connectivity();

  // 1. Check current status (One-time check)
  Future<bool> get isConnected async {
    final result = await _connectivity.checkConnectivity();
    return _hasConnection(result);
  }

  // 2. Stream (Real-time listener)
  Stream<bool> get onConnectivityChanged {
    return _connectivity.onConnectivityChanged.map(_hasConnection);
  }

  // Helper to interpret the result
  bool _hasConnection(List<ConnectivityResult> results) {
    if (results.contains(ConnectivityResult.none)) {
      return false; // Definitely no connection
    }
    // If we have Wifi, Mobile, or Ethernet, we are good
    return results.contains(ConnectivityResult.mobile) ||
        results.contains(ConnectivityResult.wifi) ||
        results.contains(ConnectivityResult.ethernet) ||
        results.contains(ConnectivityResult.vpn);
  }
}
