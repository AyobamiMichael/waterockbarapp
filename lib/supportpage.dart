import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SupportPage extends StatefulWidget {
  const SupportPage({super.key});

  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String phoneNumber1 = '';
  String phoneNumber2 = '';
  String emailAddress = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCustomerCareDetails();
  }

  Future<void> _fetchCustomerCareDetails() async {
    const apiUrl =
        'https://waterockapi.wegotam.com/getcustomercaredetails'; // Replace with your backend endpoint
    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          phoneNumber1 = data['customerCareNumber1'] ?? 'Not Available';
          phoneNumber2 = data['customerCareNumber2'] ?? 'Not Available';
          emailAddress = data['customerCareEmail'] ?? 'Not Available';
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load customer care details');
      }
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      // Handle the error appropriately (e.g., show a snackbar or dialog)
      print('Error fetching customer care details: $error');
    }
  }

  void _launchWhatsApp(String phoneNumber) async {
    final whatsappUrl = "https://wa.me/$phoneNumber";
    if (await canLaunchUrl(Uri.parse(whatsappUrl))) {
      await launchUrl(Uri.parse(whatsappUrl));
    } else {
      throw 'Could not launch $whatsappUrl';
    }
  }

  void _launchEmail(String email) async {
    final mailUrl = 'mailto:$email';
    if (await canLaunchUrl(Uri.parse(mailUrl))) {
      await launchUrl(Uri.parse(mailUrl));
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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
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
                        style:
                            const TextStyle(color: Colors.white, fontSize: 16),
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
