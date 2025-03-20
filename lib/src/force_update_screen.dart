import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'update_handler.dart';
import 'update_sheet.dart';

class ForceUpdateSplashScreen extends StatefulWidget {
  final Future? fetchData;
  final Widget splashScreen;
  final Widget? nextScreen;
  final String? contactUsUrl;
  final Locale appLocale;

  ForceUpdateSplashScreen({
    super.key,
    required this.splashScreen,
    this.nextScreen,
    this.contactUsUrl,
    this.appLocale = const Locale('en'),
    this.fetchData,
  });

  @override
  _ForceUpdateSplashScreenState createState() =>
      _ForceUpdateSplashScreenState();
}

class _ForceUpdateSplashScreenState extends State<ForceUpdateSplashScreen> {
  bool _loading = true;
  bool _showUpdateSheet = false;
  String? iosAppId;

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  Future<void> _initApp() async {
    try {
      if (widget.fetchData != null) await widget.fetchData!;
      String currentVersion = await _getCurrentVersion();
      String? latestVersion = await getLatestVersion();
      if (isUpdateRequired(currentVersion, latestVersion ?? '')) {
        setState(() {
          _showUpdateSheet = true;
          Future.microtask(() => _showUpdateDialog());
        });
      } else {
        setState(() => _loading = false);
      }
    } catch (e) {
      debugPrint("Error initializing app: $e");
      setState(() => _loading = false);
    }
  }

  Future<String> _getCurrentVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    return packageInfo.version;
  }

  void _showUpdateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      enableDrag: false,
      isDismissible: false,
      builder: (context) => UpdateSheet(
        appLocale: widget.appLocale,
        contactUsUrl: widget.contactUsUrl,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading || widget.nextScreen == null) return widget.splashScreen;
    return widget.nextScreen ?? const SizedBox();
  }
}
