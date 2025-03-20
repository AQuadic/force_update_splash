import 'dart:io';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'manual_localization.dart';

class UpdateSheet extends StatefulWidget {
  final Locale appLocale;
  final String? contactUsUrl;

  const UpdateSheet({super.key, required this.appLocale, this.contactUsUrl});

  @override
  State<UpdateSheet> createState() => _UpdateSheetState();
}

class _UpdateSheetState extends State<UpdateSheet> {
  late Map<String, String> localizedText;

  @override
  void initState() {
    localizedText = getLocalizedText(widget.appLocale.languageCode);
    super.initState();
  }

  void _launchStore() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    String packageName = packageInfo.packageName;
    String url = Platform.isAndroid
        ? 'https://play.google.com/store/apps/details?id=$packageName'
        : 'https://apps.apple.com/app/id123456789'; // Replace with actual ID

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      debugPrint("Could not open the store link.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIOS = Platform.isIOS;
    return PopScope(
      canPop: false,
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.all(40),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              isIOS
                  ? 'packages/force_update_splash/assets/images/app_store.png'
                  : 'packages/force_update_splash/assets/images/play_store.png',
              width: 60,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(
                localizedText['title']!,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Text(
              localizedText['message']!,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
            ),
            const SizedBox(height: 15),
            Directionality(
              textDirection: TextDirection.rtl,
              child: ElevatedButton.icon(
                icon: Transform.rotate(
                    angle: 45 * 3.1415927 / 180,
                    child: const Icon(Icons.arrow_upward, color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isIOS ? const Color(0xFF00A1FE) : const Color(0xFF007559),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: _launchStore,
                label: Text(
                  localizedText['updateNow']!,
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            if (widget.contactUsUrl != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    localizedText['runningAnIssue']!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 5),
                  InkWell(
                    onTap: () {
                      launchUrl(Uri.parse(widget.contactUsUrl!));
                    },
                    child: Text(
                      localizedText['contactUs']!,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: isIOS
                            ? const Color(0xFF00A1FE)
                            : const Color(0xFF007559),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
