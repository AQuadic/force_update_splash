import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

/// Fetches the latest version of the app from the respective app store.
Future<String?> getLatestVersion() async {
  if (Platform.isAndroid) {
    return await _getLatestVersionFromPlayStore();
  } else if (Platform.isIOS) {
    return await _getLatestVersionFromAppStore();
  }
  return null;
}

/// Fetches the latest version of the app from the Google Play Store.
Future<String?> _getLatestVersionFromPlayStore() async {
  String packageName = await _getPackageName();
  final response = await http.get(Uri.parse(
      'https://play.google.com/store/apps/details?id=$packageName&hl=en'));

  if (response.statusCode == 200) {
    final match = RegExp(r'\[\[\["([0-9]+(?:\.[0-9]+)*)"\]\]')
        .firstMatch(response.body);
    return match?.group(1);
  } else {
    throw Exception('Failed to fetch latest version from Play Store');
  }
}

/// Fetches the latest version of the app from the Apple App Store.
Future<String?> _getLatestVersionFromAppStore() async {
  final bundleId = await _getPackageName();
  final url = Uri.parse('https://itunes.apple.com/lookup?bundleId=$bundleId');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonData = json.decode(response.body);
    if (jsonData['results'].isEmpty) {
      throw Exception('App not found in App Store');
    }
    return jsonData['results'][0]['version'];
  } else {
    throw Exception('Failed to fetch latest version from App Store');
  }
}

/// Retrieves the package name of the app.
Future<String> _getPackageName() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  return packageInfo.packageName;
}

/// Determines if an update is required by comparing the current version with the latest version.
bool isUpdateRequired(String current, String latest) {
  List<int> currentParts = current.split('.').map(int.parse).toList();
  List<int> latestParts = latest.split('.').map(int.parse).toList();

  for (int i = 0; i < latestParts.length; i++) {
    if (i >= currentParts.length || currentParts[i] < latestParts[i]) {
      return true;
    } else if (currentParts[i] > latestParts[i]) {
      return false;
    }
  }
  return false;
}