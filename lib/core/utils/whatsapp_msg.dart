import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void openWhatsApp(String phoneNumber) async {
  String url = "https://wa.me/$phoneNumber";

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
  } else {
    debugPrint("Could not open WhatsApp");
  }
}
