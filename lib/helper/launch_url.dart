import 'package:url_launcher/url_launcher.dart';

Future<void> launchURL(String urlString) async {
  final Uri url = Uri.parse(urlString);
  if (await canLaunchUrl(url)) {
    await launchUrl(url);
  } else {
    throw 'Could not launch $urlString';
  }
}

Future<void> makePhoneCall(String phoneNumber) async {
  final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
  if (await canLaunchUrl(phoneUri)) {
    await launchUrl(phoneUri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}

Future<void> sendEmail(String email,
    {String subject = '', String body = ''}) async {
  final Uri emailUri = Uri(
    scheme: 'mailto',
    path: email,
    queryParameters: {
      'subject': subject,
      'body': body,
    },
  );
  if (await canLaunchUrl(emailUri)) {
    await launchUrl(emailUri);
  } else {
    throw 'Could not launch $email';
  }
}

Future<void> sendSMS(String phoneNumber) async {
  final Uri smsUri = Uri(scheme: 'sms', path: phoneNumber);
  if (await canLaunchUrl(smsUri)) {
    await launchUrl(smsUri);
  } else {
    throw 'Could not launch $phoneNumber';
  }
}

void launchAll(String? url) async {
  if (url == null || url.isEmpty) return;

  if (url.contains('@')) {
    // 如果包含 '@'，判断为邮箱地址
    await sendEmail(url);
  } else if (url.startsWith('tel:') || RegExp(r'^\d+$').hasMatch(url)) {
    // 如果是 'tel:' 开头或全为数字，判断为电话号码
    final phoneNumber = url.startsWith('tel:') ? url.substring(4) : url;
    await makePhoneCall(phoneNumber);
  } else if (url.startsWith('sms:')) {
    // 如果是 'sms:' 开头，判断为短信
    await sendSMS(url.substring(4));
  } else if (url.startsWith('http') || url.startsWith('https')) {
    // 如果是 'http' 或 'https' 开头，判断为网页链接
    await launchURL(url);
  } else {
    throw 'Unsupported URL format: $url';
  }
}
