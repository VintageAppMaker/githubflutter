import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void shareUrl(String sUrl) async {
  final Uri _url = Uri.parse(sUrl);
  if (!await launchUrl(_url)) throw 'Could not launch $_url';
}