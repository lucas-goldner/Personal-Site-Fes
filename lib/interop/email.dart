/// Sends the contact form through EmailJS, replacing the `emailjs-com` package.
library;

import 'dart:convert';

import 'package:http/http.dart' as http;

/// EmailJS credentials, supplied at build time:
///
/// ```
/// jaspr build \
///   --dart-define=EMAILJS_SERVICE_ID=... \
///   --dart-define=EMAILJS_TEMPLATE_ID=... \
///   --dart-define=EMAILJS_USER_ID=...
/// ```
///
/// These replace the `GATSBY_SERVICE_ID`, `GATSBY_TEMPLATE_ID` and
/// `GATSBY_USER_ID` variables of the Gatsby build. They are public EmailJS
/// identifiers and are meant to be visible in the client bundle.
class EmailJsConfig {
  static const serviceId = String.fromEnvironment('EMAILJS_SERVICE_ID');
  static const templateId = String.fromEnvironment('EMAILJS_TEMPLATE_ID');
  static const userId = String.fromEnvironment('EMAILJS_USER_ID');

  /// Whether all three identifiers were provided to the build.
  static bool get isConfigured => serviceId.isNotEmpty && templateId.isNotEmpty && userId.isNotEmpty;
}

/// Delivers one contact form submission.
///
/// Returns true when EmailJS accepted the message. The template parameter names
/// match the ones the previous site sent, so the existing EmailJS template keeps
/// working unchanged.
Future<bool> sendContactMail({
  required String name,
  required String email,
  required String phone,
  required String message,
}) async {
  if (!EmailJsConfig.isConfigured) return false;

  final response = await http.post(
    Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
    headers: const {'Content-Type': 'application/json'},
    body: jsonEncode({
      'service_id': EmailJsConfig.serviceId,
      'template_id': EmailJsConfig.templateId,
      'user_id': EmailJsConfig.userId,
      'template_params': {
        'from_name': name,
        'email': email,
        'number': phone,
        'message': message,
        'to_name': 'Lucas Goldner',
      },
    }),
  );

  return response.statusCode >= 200 && response.statusCode < 300;
}
