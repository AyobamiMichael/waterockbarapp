import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatelessWidget {
  const SupportPage({super.key});

  final String phoneNumber1 = '+234080000000';
  final String phoneNumber2 = '+234080000000';
  final String emailAddress = 'support@waterockbars.com';

  void _launchWhatsApp(String phoneNumber) async {
    final whatsappUrl = "https://wa.me/$phoneNumber";
    if (await canLaunchUrl(whatsappUrl as Uri)) {
      await launchUrl(whatsappUrl as Uri);
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  void _launchEmail(String email) async {
    final mailUrl = 'mailto:$email';
    if (await canLaunchUrl(mailUrl as Uri)) {
      await launchUrl(mailUrl as Uri);
    } else {
      throw 'Could not launch $mailUrl';
    }
  }

  Widget _buildContactRow(
      String label, String value, IconData icon, VoidCallback onTap) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.green),
            const SizedBox(width: 10),
            Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ],
        ),
        IconButton(
          icon: SizedBox(
            width: 24,
            height: 24,
            child: Image.asset('assets/images/whatsAppLogo.png'),
          ),
          onPressed: onTap,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Support'),
        backgroundColor: Colors.black,
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Contact Support',
              style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            const SizedBox(height: 20),
            _buildContactRow('Phone', phoneNumber1, Icons.phone,
                () => _launchWhatsApp(phoneNumber1)),
            const SizedBox(height: 10),
            _buildContactRow('Phone', phoneNumber2, Icons.phone,
                () => _launchWhatsApp(phoneNumber2)),
            const SizedBox(height: 20),
            Row(
              children: [
                const Icon(Icons.email, color: Colors.blue),
                const SizedBox(width: 10),
                Text(
                  emailAddress,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.email, color: Colors.blue),
                  onPressed: () => _launchEmail(emailAddress),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
